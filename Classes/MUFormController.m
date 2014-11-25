//
//  MUFormController.m
//  MeetupApp
//
//  Created by Wes on 8/18/13.
//
//

#import "MUFormController.h"
#import "MUFormKit.h"
#import "MUFormDataSource.h"
#import "MURelativeDatePickerController.h"

static CGFloat const kMUDefaulSectionHeaderHeight = 17.0;
static CGFloat const kMUDefaultSectionFooterHeight = 17.0;

@interface MUFormController ()

@property (nonatomic, assign) BOOL isKeyboardShowing;
@property (nonatomic) CGRect keyboardFrame;

/// To give correct estimates for cells that have been displayed but are now offscreen (from user scrolling down)
@property (nonatomic, strong) NSMutableDictionary *cellHeightForDisplayedCells;


@end

@implementation MUFormController


- (void)dealloc
{
    // Stop observing the keyboard.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)mu_handleTimeTapAtIndexPath:(NSIndexPath *)indexPath withTimeZone:(NSTimeZone *)timeZone
{
    NSIndexPath *timePickerIndexPath = self.dataSource.timePickerIndexPath;
    
    NSInteger row = indexPath.row + 1;
    if ((timePickerIndexPath != nil) && indexPath.section == timePickerIndexPath.section) {
        row = (timePickerIndexPath.row < indexPath.row) ? indexPath.row : indexPath.row + 1;
    }
    NSIndexPath *nextTimePickerIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
    
    [self.tableView beginUpdates];
    if (timePickerIndexPath && [nextTimePickerIndexPath compare:timePickerIndexPath] == NSOrderedSame) {
        [self.dataSource deleteTimePickerAtIndexPath:timePickerIndexPath];
        [self.tableView deleteRowsAtIndexPaths:@[timePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        
        if (timePickerIndexPath) {
            [self.dataSource deleteTimePickerAtIndexPath:timePickerIndexPath];
            [self.tableView deleteRowsAtIndexPaths:@[timePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.dataSource insertTimePickerAtIndexPath:nextTimePickerIndexPath relatedIndexPath:indexPath withTimeZone:timeZone];
        [self.tableView insertRowsAtIndexPaths:@[nextTimePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}

- (void)mu_removeTimePickerCellWithCompletion:(void(^)())completion
{
    NSIndexPath *timePickerIndexPath = self.dataSource.timePickerIndexPath;
    if (timePickerIndexPath == nil) return;
    [self.dataSource deleteTimePickerAtIndexPath:timePickerIndexPath];
    
    // See https://developer.apple.com/videos/wwdc/2011/ session 121
    [CATransaction setCompletionBlock:^{
        if (completion) completion();
    }];
    [self.tableView deleteRowsAtIndexPaths:@[timePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];

    NSIndexPath *relatedIndexPath = [NSIndexPath indexPathForRow:timePickerIndexPath.row - 1 inSection:timePickerIndexPath.section];
    [self.tableView deselectRowAtIndexPath:relatedIndexPath animated:YES];
}

- (void)mu_handleRelativeDateTapAtIndexpath:(NSIndexPath *)indexPath
{
    NSDate *currentDate = [self.dataSource valueForItemAtIndexPath:indexPath];
    NSDictionary *rowInfo = [self.dataSource rowInfoForItemAtIndexPath:indexPath];
    NSDictionary *cellAttributes = rowInfo[MUFormCellAttributeValuesKey];
    NSDate *maximumDate = cellAttributes[MUFormCellMaximumDateKey];
    
    NSTimeZone *timeZone = nil;
    if ([cellAttributes[MUFormCellTimeZoneKey] isKindOfClass:[NSTimeZone class]]) {
        timeZone = cellAttributes[MUFormCellTimeZoneKey];
    }
    
    BOOL ascending = [cellAttributes[MUFormCellDateAscendingKey] boolValue];
    
    MURelativeDatePickerController *controller = [[MURelativeDatePickerController alloc] initWithMinimumDate:[NSDate date] maximumDate:maximumDate];
    controller.ascending = ascending;
    controller.selectedDate = currentDate;
    controller.timeZone = timeZone;
    NSString *localizedKey = rowInfo[MUFormLocalizedMetaStringKey];
    controller.title = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
    
    [controller setDidSelectDateBlock:^(NSDate *date) {
        NSDate *mergedDateTime = [date dateWithTimeFromDate:currentDate timeZone:timeZone];
        [self changeValue:mergedDateTime forItemAtIndexPath:indexPath];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
}
    
- (void)mu_adjustCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    MUFormBaseCell *cell = (MUFormBaseCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // Update the cell's height if there's a validation error.
    CGFloat height = [self heightForRowAtIndexPath:indexPath];
    if (height != CGRectGetHeight(cell.bounds)) {
        
        id value = [self.dataSource valueForItemAtIndexPath:indexPath];
        NSDictionary *info = [self.dataSource rowInfoForItemAtIndexPath:indexPath];
        
        [self.tableView beginUpdates];
        [cell configureWithValue:value info:info];
        [self.tableView endUpdates];
    }
    
    // Adjust the table view's content offset if necessary.
    if ([self.dataSource validationErrorForItemAtIndexPath:indexPath]) {
        
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = height;
        CGRect cellFrameInWindow = [self.tableView convertRect:cellFrame toView:self.view.window];
        
        CGRect intersectRect = CGRectIntersection(cellFrameInWindow, _keyboardFrame);
        
        if (!CGRectIsNull(intersectRect)) {
            
            CGPoint offset = self.tableView.contentOffset;
            offset.y += CGRectGetHeight(intersectRect);
            [self.tableView setContentOffset:offset animated:YES];
        }
    }
}

#pragma mark - Accessors -


- (void)setDataSource:(MUFormDataSource *)dataSource
{
    _dataSource = dataSource;
    
    __weak __typeof__(self) weakSelf = self;
    [self.dataSource setCellConfigureBlock:^(NSIndexPath *indexPath, MUFormBaseCell *cell, id value, NSDictionary *itemInfo) {        
        [cell configureWithValue:value info:itemInfo];
        cell.delegate = weakSelf;
    }];
    
    self.nextResponderController.dataSource = dataSource;
    
    MUAssert(self.tableView, @"Expected tableview to be loaded");
    self.tableView.dataSource = self.dataSource;
    
    // Register the form cells with the tableview.
    [self.dataSource.cellClassesByIdentifier enumerateKeysAndObjectsUsingBlock:^(NSString *identifier, NSString *nibName, BOOL *stop) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    }];
    
    // The time picker.
    UINib *nib = [UINib nibWithNibName:@"MUFormTimePickerCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"form-time-picker"];
    
    NSString *localizedKey = self.dataSource.metadata[MUFormLocalizedMetadataTitleKey];
    self.title = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
    
    [self.tableView reloadData];
}

- (MUNextResponderController*) nextResponderController {
    if (!_nextResponderController) {
        _nextResponderController = [[MUNextResponderController alloc] init];
    }
    return _nextResponderController;
}

#pragma mark - UIViewController -


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nextResponderController.tableView = self.tableView;
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    self.tableView.backgroundView = nil;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.sectionHeaderHeight = kMUDefaulSectionHeaderHeight;
    self.tableView.sectionFooterHeight = kMUDefaultSectionFooterHeight;
    self.cellHeightForDisplayedCells = [NSMutableDictionary dictionary];
    
    // Observe the keyboard.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeKeyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeKeyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.lastTappedIndexPath];
    [cell setSelected:YES animated:NO];
    [self performBlock:^{
       [cell setSelected:NO animated:YES];
    } afterDelay:0.1]; // A bit of a hack, but it looks right.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.dataSource.timePickerIndexPath) {
        [self mu_removeTimePickerCellWithCompletion:NULL];
    }
    
    if ([segue.identifier isEqualToString:@"form-to-form-segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *rowInfo = [self.dataSource rowInfoForItemAtIndexPath:indexPath];
        NSString *dataSourceName = rowInfo[MUFormDataSourceFileNameKey];
        
        NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:dataSourceName ofType:@"json"];
        MUFormDataSource *dataSource = [[MUFormDataSource alloc] initWithModel:self.dataSource.model JSONFilePath:jsonFilePath];
        MUFormController *controller = segue.destinationViewController;
        [controller setDataSource:dataSource];
    }
}

    
#pragma mark - Row Height & Adjustments -

+ (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    NSDictionary *rowInfo = [self.dataSource rowInfoForItemAtIndexPath:indexPath];
    NSNumber *staticHeight = rowInfo[MUFormRowHeightKey];
    if ([staticHeight floatValue] > 0) {
        height = [staticHeight floatValue];
    }
    else {
        Class class = [self.dataSource cellClassForItemAtIndexPath:indexPath];
        id value = [self.dataSource valueForItemAtIndexPath:indexPath];
        height = [class heightForTableView:self.tableView value:value info:rowInfo];
    }
    
    return height;
}

#pragma mark - Notifications -

- (void)observeKeyboardDidShowNotification:(NSNotification *)notification
{
    NSValue *keyboardFrameValue = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrame = [keyboardFrameValue CGRectValue];
    self.isKeyboardShowing = YES;
}


- (void)observeKeyboardDidHideNotification:(NSNotification *)notification
{
    self.keyboardFrame = CGRectZero;
    self.isKeyboardShowing = NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.nextResponderController willDisplayCell:cell forRowAtIndexPath:indexPath];    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell isKindOfClass:[MUFormBaseCell class]]) {
        [(MUFormBaseCell *)cell setDelegate:nil];
    }

    self.cellHeightForDisplayedCells[[[self class] keyForIndexPath:indexPath]] = @(CGRectGetHeight(cell.bounds));
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.lastTappedIndexPath = indexPath;
    MUFormBaseCell *cell = (MUFormBaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    MUAssert([cell isKindOfClass:[MUFormBaseCell class]], @"Expected cell type MUFormBaseCell was %@",cell);
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        [cell voiceOverActivate];
    }
    
    NSString *segueIdentifier = [self.dataSource segueIdentifierForitemAtIndexPath:indexPath];
    if ([segueIdentifier length] > 0) {
        [self performSegueWithIdentifier:segueIdentifier sender:cell];
    }
    else if ([cell conformsToProtocol:@protocol(MUFormNextTextResponder)]) {
        [cell becomeFirstResponder];
    }
    else if ([cell isKindOfClass:[MUFormTimeCell class]]) {
        MUFormTimeCell *timeCell = (MUFormTimeCell *)cell;
        [self mu_handleTimeTapAtIndexPath:indexPath withTimeZone:timeCell.timeZone];
    }
    else if ([cell isKindOfClass:[MUFormRelativeDateCell class]]) {
        [self mu_handleRelativeDateTapAtIndexpath:indexPath];
    }
    else if ([cell isKindOfClass:[MUFormOptionCell class]]) {
        if (cell.enabled && cell.accessoryType == UITableViewCellAccessoryNone) {
            [self optionCellDidBecomeSelectedOptionCell:(MUFormOptionCell *)cell];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.dataSource heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self.dataSource heightForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *cellHeightForDisplayedCell = self.cellHeightForDisplayedCells[[[self class] keyForIndexPath:indexPath]];
    if (cellHeightForDisplayedCell) {
        return [cellHeightForDisplayedCell floatValue];
    }
    
    Class cellClass = [self.dataSource cellClassForItemAtIndexPath:indexPath];
    MUAssert(cellClass, @"Expected a cellClass set at indexPath %@",indexPath);
    return [cellClass estimatedCellHeight];
}

#pragma mark - Form events

- (void)changeValue:(id)value forItemAtIndexPath:(NSIndexPath *)indexPath
{
    id oldValue = [self.dataSource valueForItemAtIndexPath:indexPath];
    if (value && ![value isEqual:oldValue]) {
        [self.dataSource setValue:value forItemAtIndexPath:indexPath];
        [self didChangeValue:value forItemAtIndexPath:indexPath previousValue:oldValue];
    }
}

- (void)didChangeValue:(id)value forItemAtIndexPath:(NSIndexPath *)indexPath previousValue:(id)previousValue {
    // For subclasses to override
}

#pragma mark - Form Cell Delegate Methods

#pragma mark - Date picker

- (void)dateTimeCellDidTapTime:(MUFormDateTimeCell *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self mu_handleTimeTapAtIndexPath:indexPath withTimeZone:sender.timeZone];
}

#pragma mark - Time picker

- (void)timePickerCell:(MUFormTimePickerCell *)sender didChangeTime:(NSDate *)time timeZone:(NSTimeZone *)timeZone
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSIndexPath *relatedIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    
    // Merge the time with the existing date and update the model.
    NSDate *currentDate = [self.dataSource valueForItemAtIndexPath:relatedIndexPath];
    NSDate *mergedDateTime = [currentDate dateWithTimeFromDate:time timeZone:timeZone];
    [self changeValue:mergedDateTime forItemAtIndexPath:relatedIndexPath];
    [self.tableView reloadRowsAtIndexPaths:@[relatedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Text input

- (BOOL)textInputCell:(MUFormBaseCell *)sender shouldBeginEditing:(UIView <UITextInput> *)textInputView
{
    BOOL shouldBeginEditing = YES;
    if (self.dataSource.timePickerIndexPath) {
        
        [self mu_removeTimePickerCellWithCompletion:^{
            [textInputView becomeFirstResponder];
        }];
        
        shouldBeginEditing = NO;
    }
    
    return shouldBeginEditing;
}

- (void)textInputCell:(MUFormBaseCell *)sender didBeginEditing:(UIView <UITextInput> *)textInputView
{
    [self mu_removeTimePickerCellWithCompletion:NULL];
}

- (void)textInputCell:(MUFormBaseCell *)sender textChanged:(NSString *)text
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self changeValue:text forItemAtIndexPath:indexPath];
    [self mu_adjustCellHeightAtIndexPath:indexPath];
}

- (BOOL)textInputCell:(MUFormBaseCell *)sender textInputViewShouldReturn:(UIView <UITextInput> *)textInputView
{
    if ([sender isKindOfClass:[MUFormTextViewCell class]]) return YES;
    
    NSIndexPath *currentResponderIndexPath = [self.tableView indexPathForCell:sender];

    [self.nextResponderController focusOnNextResponderFromIndexPath:currentResponderIndexPath
    completion:^(BOOL didFindNextResponder) {
        if (!didFindNextResponder) {
            [textInputView resignFirstResponder];
        }
    }];
    return NO;
}

#pragma mark - Text field

- (void)textFieldCell:(MUFormTextFieldCell *)sender didEndEditingWithText:(NSString *)text
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self changeValue:text forItemAtIndexPath:indexPath];
}

- (void)textViewCell:(MUFormTextViewCell *)sender didEndEditingWithText:(NSString *)text
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self changeValue:text forItemAtIndexPath:indexPath];
}

#pragma mark - Number input

- (void)numberFieldCell:(MUFormNumberFieldCell *)sender didEndEditingWithNumber:(NSString *)numberString
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSNumber *number = ([numberString length]) ? @([numberString integerValue]) : nil;
    [self changeValue:number forItemAtIndexPath:indexPath];
}

- (void)numberFieldCell:(MUFormNumberFieldCell *)sender numberChanged:(NSString *)numberString
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSNumber *number = ([numberString length]) ? @([numberString integerValue]) : nil;
    [self changeValue:number forItemAtIndexPath:indexPath];
    [self mu_adjustCellHeightAtIndexPath:indexPath];
}

- (void)optionCellDidBecomeSelectedOptionCell:(MUFormOptionCell *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

    NSDictionary *rowInfo = [self.dataSource rowInfoForItemAtIndexPath:indexPath];
    NSNumber *defaultValue = rowInfo[MUFormDefaultValueKey];
    
    NSNumber *value = [self.dataSource valueForItemAtIndexPath:indexPath];
    if ([value isEqual:defaultValue] == NO) {
        [self changeValue:defaultValue forItemAtIndexPath:indexPath];
    }
    
    // We use this delay to give the table view time to perform the cell selection/deselection animation.
    // We prefer this over using +[CATransaction setCompletionBlock:] to reload at animation completion
    // because the cell deselection animation ease-out is very gradual, making the reload look really slow.
    [self performBlock:^{
        NSArray *relatedOptionsCells = [self.dataSource indexPathsForPropertyWithName:rowInfo[MUFormPropertyNameKey]];
        for (NSIndexPath *relatedIndexPath in relatedOptionsCells) {
            MUFormBaseCell *cell = (MUFormBaseCell *)[self.tableView cellForRowAtIndexPath:relatedIndexPath];
            [self.dataSource reconfigureCell:cell atIndexPath:relatedIndexPath];
        }
    } afterDelay:0.15];

}

- (void)switchCell:(MUFormSwitchCell *)sender didChangeValue:(BOOL)selected
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self changeValue:@(selected) forItemAtIndexPath:indexPath];
    // Don't reload or the switch won't animate.
}

- (void)formActivationCell:(MUFormActivationCell *)sender didChangeValue:(BOOL)selected
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self changeValue:@(selected) forItemAtIndexPath:indexPath];
    [self.dataSource tableView:self.tableView updateEnabledSectionsWithIndexPath:indexPath];
}

@end
