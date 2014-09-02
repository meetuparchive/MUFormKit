//
//  MURelativeDatePickerController.m
//  MeetupApp
//
//  Created by Wes on 8/15/13.
//
//

#import "MURelativeDatePickerController.h"


@interface MURelativeDatePickerController ()

@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^didSelectDateBlock)(NSDate *);

@property (nonatomic, copy) NSIndexPath  *selectedIndexPath;
@property (nonatomic, copy) NSDictionary *titlesForRows;
@property (nonatomic, copy) NSDictionary *subtitlesForRows;

@end

@implementation MURelativeDatePickerController

#pragma mark - Private Methods -


- (NSDate *)mu_dateForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows = self.sections[indexPath.section];
    NSDate *date = rows[indexPath.row];
    return date;
}

- (NSDate *)mu_dateAtIndex:(NSInteger)index
{
    NSDate *date = nil;
    if (self.isAscending) {
        date = [self.minimumDate dateByAddingDays:index hours:0];
    }
    else {
        date = [self.maximumDate dateByAddingDays:-index hours:0];
    }
    return date;
}

- (NSArray *)mu_unsectionedDates
{
    NSInteger numberOfDays = [NSDate daysBetween:self.minimumDate and:self.maximumDate inTimeZone:self.timeZone] + 1;
    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:numberOfDays];

    for (NSInteger i = 0; i < numberOfDays; i++) {
        NSDate *date = [self mu_dateAtIndex:i];
        [dates addObject:date];
    }
    return @[dates];
}

#pragma mark - Initialization -


- (instancetype)initWithMinimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate
{
    MUParameterAssert(minimumDate);
    MUParameterAssert(maximumDate);
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.minimumDate = minimumDate;
        self.maximumDate = maximumDate;
    }
    return self;
}


#pragma mark - UIViewController -


- (void)viewDidLoad
{
    [super viewDidLoad];

    MUAssert(self.minimumDate, @"You must set a `minimumDate` before %@ is presented.", NSStringFromClass([self class]));
    MUAssert(self.maximumDate, @"You must set a `maximumDate` before %@ is presented.", NSStringFromClass([self class]));
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    self.tableView.rowHeight = 50.0;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.sections = [self mu_unsectionedDates];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Select the cell correscponding to the selected date.
    if (self.selectedDate) {
        __block NSIndexPath *indexPath = nil;
        __weak __typeof__(self) weakSelf = self;
        [self.sections enumerateObjectsUsingBlock:^(NSArray *rows, NSUInteger section, BOOL *sectionStop) {
            [rows enumerateObjectsUsingBlock:^(NSDate *date, NSUInteger row, BOOL *rowStop) {
                if ([NSDate daysBetween:weakSelf.selectedDate and:date inTimeZone:self.timeZone] == 0) {
                    indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    *sectionStop = YES; *rowStop = YES;
                }
            }];
        }];
        self.selectedIndexPath = indexPath;
    }
    
    [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}


#pragma mark - Actions -


- (void)cancel:(UIBarButtonItem *)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [self.sections count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = self.sections[section];
    NSInteger count = [rows count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDate *date = [self mu_dateForRowAtIndexPath:indexPath];
    NSInteger day = [NSDate daysBetween:date and:self.maximumDate inTimeZone:self.timeZone];
    
    if (self.titlesForRows == nil) {
        
        self.titlesForRows =
        @{
            @0 : NSLocalizedString(@"Day of Meetup", nil),
            @1 : NSLocalizedString(@"The day before", @"The day before [the event]")
        };
    }
    if (self.subtitlesForRows == nil) {
        
        NSArray *allDates = [self.sections valueForKeyPath:@"@unionOfArrays.self"];
        self.subtitlesForRows =
        @{
            @([allDates count]) : [NSString stringWithFormat:NSLocalizedString(@"%@ (Today)", @"e.g. 'April 24 (Today)'"), [date stringWithStyle:MUDateStyleTypeMonthDayDate inTimeZone:self.timeZone]]
         };
    }

    NSString *title = self.titlesForRows[@(day)];
    if (title == nil) {
        title = [NSString stringWithFormat:NSLocalizedString(@"%d days before", @"Used in a relative date picker. '<number> [of] days before [a Meetup event]'"), day];
    }
    
    NSString *subtitle = self.subtitlesForRows[@(day)];
    if (subtitle == nil) {
        subtitle = [date stringWithStyle:MUDateStyleTypeLongDate inTimeZone:self.timeZone];
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    if (self.selectedIndexPath && [indexPath isEqual:self.selectedIndexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [tableView reloadData];
    
    NSDate *date = [self mu_dateForRowAtIndexPath:indexPath];
    if (self.didSelectDateBlock) {
        self.didSelectDateBlock(date);
    }
}

@end
