//
//  MUFormDataSource.m
//  MeetupApp
//
//  Created by Wes on 8/15/13.
//
//

#import "MUFormDataSource.h"
#import "MUFormBaseCell.h"
#import "MUFormActivationCell.h"
#import "MUValidationErrors.h"

// Form meta data constants definitions.
NSString *const MUFormMetadataKey               = @"MUFormMetadataKey";
NSString *const MUFormLocalizedMetadataTitleKey = @"MUFormLocalizedMetadataTitleKey";
NSString *const MUFormCellTimeZoneKey           = @"MUFormCellTimeZoneKey";
NSString *const MUFormKitStringTable            = @"FormKit";

// Form section constants definitions.
NSString *const MUFormSectionsKey                    = @"MUFormSectionsKey";
NSString *const MUFormSectionTagKey                  = @"MUFormSectionTagKey";
NSString *const MUFormSectionEnabledPropertyNameKey  = @"MUFormSectionEnabledPropertyNameKey";
NSString *const MUFormSectionDynamicRowLimitKey      = @"MUFormSectionDynamicRowLimitKey";
NSString *const MUFormLocalizedSectionHeaderTitleKey = @"MUFormLocalizedSectionHeaderTitleKey";
NSString *const MUFormLocalizedSectionFooterTitleKey = @"MUFormLocalizedSectionFooterTitleKey";
NSString *const MUFormSectionRowsKey                 = @"MUFormSectionRowsKey";
NSString *const MUFormSectionHeaderHeightKey         = @"MUFormSectionHeaderHeightKey";
NSString *const MUFormSectionFooterHeightKey         = @"MUFormSectionFooterHeightKey";

// Form row constants definitions.
NSString *const MUFormCellIdentifierKey                 = @"MUFormCellIdentifierKey";
NSString *const MUFormCellClassKey                      = @"MUFormCellClassKey";
NSString *const MUFormCellTagKey                        = @"MUFormCellTagKey";
NSString *const MUFormCellLocalizedAccessibilityHintKey = @"MUFormCellLocalizedAccessibilityHintKey";
NSString *const MUFormCellAccessibilityButtonTraitKey   = @"MUFormCellAccessibilityButtonTraitKey";
NSString *const MUFormRowExpandedKey                    = @"MUFormRowExpandedKey";
NSString *const MUFormLocalizedStaticTextKey            = @"MUFormLocalizedStaticTextKey";
NSString *const MUFormCellAccessoryTypeKey              = @"MUFormCellAccessoryTypeKey";
NSString *const MUFormPropertyNameKey                   = @"MUFormPropertyNameKey";
NSString *const MUFormDependencyPropertyNameKey         = @"MUFormDependencyPropertyNameKey";
NSString *const MUFormDependentPropertyNameKey          = @"MUFormDependentPropertyNameKey";
NSString *const MUFormPropertyNameGetterKey             = @"MUFormPropertyNameGetterKey";
NSString *const MUFormPropertyNameSetterKey             = @"MUFormPropertyNameSetterKey";
NSString *const MUFormCellAttributeNamesKey             = @"MUFormCellAttributeNamesKey";
NSString *const MUFormCellAttributeValuesKey            = @"MUFormCellAttributeValuesKey";
NSString *const MUFormDefaultValueKey                   = @"MUFormDefaultValueKey";
NSString *const MUFormLocalizedDefaultValueKey          = @"MUFormLocalizedDefaultValueKey";
NSString *const MUFormUITextAutocorrectionTypeKey       = @"MUFormUITextAutocorrectionTypeKey";
NSString *const MUFormUIKeyboardTypeKey                 = @"MUFormUIKeyboardTypeKey";
NSString *const MUFormUIReturnKeyTypeKey                = @"MUFormUIReturnKeyTypeKey";
NSString *const MUFormUITextAutocapitalizationTypeKey   = @"MUFormUITextAutocapitalizationTypeKey";
NSString *const MUFormLocalizedLabelKey            		= @"MUFormLocalizedLabelKey";
NSString *const MUFormLocalizedAccessibilityLabelKey    = @"MUFormLocalizedAccessibilityLabelKey";
NSString *const MUFormLocalizedCellMessageKey           = @"MUFormLocalizedCellMessageKey";
NSString *const MUFormCellSegueIdentifierKey            = @"MUFormCellSegueIdentifierKey";
NSString *const MUFormCellIconNameKey                   = @"MUFormCellIconNameKey";
NSString *const MUFormCellIconURLStringKey              = @"MUFormCellIconURLStringKey";
NSString *const MUFormMinimumDatePropertyNameKey        = @"MUFormMinimumDatePropertyNameKey";
NSString *const MUFormMaximumDatePropertyNameKey        = @"MUFormMaximumDatePropertyNameKey";
NSString *const MUFormLocalizedMetaStringKey            = @"MUFormLocalizedMetaStringKey";
NSString *const MUFormBecomeFirstResponderKey           = @"MUFormBecomeFirstResponderKey";
NSString *const MUFormTapActionIdentifierKey            = @"MUFormTapActionIdentifierKey";
NSString *const MUFormDataSourceFileNameKey             = @"MUFormDataSourceFileNameKey";
NSString *const MUFormMaximumCharactersKey   			= @"MUFormMaximumCharactersKey";
NSString *const MUFormRowHeightKey                      = @"MUFormRowHeightKey";
NSString *const MUFormCellSecureTextEntryEnabledKey     = @"MUFormCellSecureTextEntryEnabledKey";

// Form error constants definitions.
NSString *const MUValidationErrorDomain = @"MUValidationErrorDomain";


@interface MUFormDataSource ()

@property (nonatomic, strong, readwrite) NSDictionary *metadata;
@property (nonatomic, strong, readwrite) NSArray *rawSections;
@property (nonatomic, strong, readwrite) NSMutableArray *activeSections;
@property (nonatomic, strong, readwrite) NSDictionary *cellClassesByIdentifier;
@property (nonatomic, strong, readwrite) NSIndexSet *dependentSectionIndexSet;
@property (nonatomic, strong) NSMutableArray *mutableTextInputIndexPaths;
@property (nonatomic, strong, readwrite) NSIndexPath *timePickerIndexPath;
@property (nonatomic, strong) NSDictionary *timePickerRowInfo;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;

@end

@implementation MUFormDataSource


- (NSDictionary *)cellClassesByIdentifier
{
    if (_cellClassesByIdentifier == nil) {
        NSArray *rows = [self.rawSections valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfArrays.%@",MUFormSectionRowsKey]];
        NSMutableDictionary *classesById = [NSMutableDictionary dictionaryWithCapacity:[rows count]];
        for (NSDictionary *rowInfo in rows) {
            classesById[rowInfo[MUFormCellIdentifierKey]] = rowInfo[MUFormCellClassKey];
        }
        _cellClassesByIdentifier = [classesById copy];
    }
    return _cellClassesByIdentifier;
}

#pragma mark - Initialization & Configuration -

- (instancetype)initWithModel:(id)model JSONFilePath:(NSString *)filePath
{
    MUParameterAssert(model);
    MUParameterAssert(filePath);
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSMutableDictionary *formStructure = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    MUAssert(error == nil, @"Error parsing json datasource file: %@\n%@", [error localizedDescription], [error userInfo]);
    
    return [self initWithModel:model formStructure:formStructure];
}

- (instancetype)initWithModel:(id)model formStructure:(NSDictionary *)formStructure
{
    MUParameterAssert(model);
    MUParameterAssert(formStructure);
    
    self = [super init];
    if (self) {
        _model = model;

        CFDictionaryRef mutableCFFormStructure = CFPropertyListCreateDeepCopy(kCFAllocatorDefault,
                                                                              (CFDictionaryRef)formStructure,
                                                                              kCFPropertyListMutableContainers);
        NSMutableDictionary *mutableFormStructure = (__bridge_transfer NSMutableDictionary *)mutableCFFormStructure;

        self.metadata = mutableFormStructure[MUFormMetadataKey];
        self.rawSections = [mutableFormStructure[MUFormSectionsKey] copy];
        [self reloadFormData];
        
    }
    return self;
}

- (void)setCellConfigureBlock:(ConfigureCellBlock)cellConfigureBlock
{
    MUParameterAssert(cellConfigureBlock);
    self.configureCellBlock = cellConfigureBlock;
}

-(void) reloadFormData
{
    [self updateActiveSections];
    _cellClassesByIdentifier = nil;
}

-(void) updateActiveSections
{
    NSMutableArray *enabledSections = [NSMutableArray arrayWithCapacity:[self.rawSections count]];
    [self enumerateSectionsUsingBlock:^(NSDictionary *sectionInfo, NSUInteger idx, BOOL *stop) {
        NSNumber *isEnabled = nil;
        NSString *keyPath = sectionInfo[MUFormSectionEnabledPropertyNameKey];
        if ([keyPath length] > 0) {
            isEnabled = [self.model valueForKeyPath:keyPath];
            if ([isEnabled boolValue] || (isEnabled == nil)) {
                [enabledSections addObject:[sectionInfo mutableCopy]];
            }
        }
        else {
            [enabledSections addObject:[sectionInfo mutableCopy]];
        }
    }];
    self.activeSections = enabledSections;
}

#pragma mark - Private Methods -

- (NSMutableDictionary *)mu_rowInfoForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (NSMutableDictionary *)[self rowInfoForItemAtIndexPath:indexPath]; // It really is mutable, I swear!
}

- (NSDictionary *)mu_cellAttributeValuesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self rowInfoForItemAtIndexPath:indexPath];
    NSDictionary *cellAttributeNames = rowInfo[MUFormCellAttributeNamesKey];
    NSMutableDictionary *cellAttributeValues = [NSMutableDictionary dictionaryWithCapacity:[cellAttributeNames count]];
    [cellAttributeNames enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        
        id value = val;
        
        // If `val` is a string, try getting a value from the model.
        if ([val isKindOfClass:[NSString class]]) {
            SEL selector = NSSelectorFromString(val);
            if ([self.model respondsToSelector:selector]) {
                value = [self.model valueForKey:val];
            }
        }
        
        if (value) {
            cellAttributeValues[key] = value;
        }
    }];
    
    return cellAttributeValues;
}


#pragma mark - Getting & Setting Row Item Information -


- (NSUInteger)numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    NSArray *rows = sectionInfo[MUFormSectionRowsKey];
    return [rows count];
}

- (NSIndexSet *)indexPathsForSection:(NSInteger)section
{
    NSUInteger count = [self.activeSections count];
    MUAssert((section < (NSInteger)count), @"Section index (%ld) is out of bounds (%lu).", (long)section, (unsigned long)count);
    NSDictionary *sectionInfo = self.activeSections[section];
    NSArray *rows = sectionInfo[MUFormSectionRowsKey];
    NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:[rows count]];
    [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [indexes addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    return [indexes copy];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    NSNumber *sectionHeaderHeight = sectionInfo[MUFormSectionHeaderHeightKey];
    CGFloat height = (sectionHeaderHeight) ? [sectionHeaderHeight floatValue] : UITableViewAutomaticDimension;
    return height;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    NSNumber *sectionFooterHeight = sectionInfo[MUFormSectionFooterHeightKey];
    CGFloat height = (sectionFooterHeight) ? [sectionFooterHeight floatValue] : UITableViewAutomaticDimension;
    return height;
}

- (NSDictionary *)rowInfoForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        return nil;
    }
    NSDictionary *sectionInfo = self.activeSections[indexPath.section];
    NSArray *rows = sectionInfo[MUFormSectionRowsKey];
    NSMutableDictionary *rowInfo  = rows[indexPath.row];
    return rowInfo;
}

- (Class)cellClassForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    return NSClassFromString(rowInfo[MUFormCellClassKey]);
}

- (NSString *)segueIdentifierForitemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    return rowInfo[MUFormCellSegueIdentifierKey];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    NSNumber *height = rowInfo[MUFormRowHeightKey];
    return (height) ? [height floatValue] : 0.0;
}

- (void)insertTimePickerAtIndexPath:(NSIndexPath *)indexPath relatedIndexPath:(NSIndexPath *)relatedIndexPath withTimeZone:(NSTimeZone *)timeZone
{
    self.timePickerIndexPath = indexPath;
    
    NSMutableDictionary *sectionInfo = self.activeSections[indexPath.section];
    NSMutableArray *mutableRows = sectionInfo[MUFormSectionRowsKey];
    
    NSDictionary *relatedRow = mutableRows[relatedIndexPath.row];
    NSMutableDictionary *timePickerRowInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    timePickerRowInfo[MUFormCellIdentifierKey] = @"form-time-picker";
    timePickerRowInfo[MUFormCellClassKey] = @"MUFormTimePickerCell";
    timePickerRowInfo[MUFormPropertyNameKey] = relatedRow[MUFormPropertyNameKey];
    timePickerRowInfo[MUFormCellAttributeNamesKey] = relatedRow[MUFormCellAttributeNamesKey];
    timePickerRowInfo[MUFormCellTimeZoneKey] = timeZone;
    self.timePickerRowInfo = timePickerRowInfo;
}

- (void)deleteTimePickerAtIndexPath:(NSIndexPath *)indexPath
{
    MUAssert([indexPath compare:self.timePickerIndexPath] == NSOrderedSame, @"Time picker indexPath (%@) does not match the time picker indexPath to delete (%@)", self.timePickerIndexPath, indexPath);
    self.timePickerIndexPath = nil;
    self.timePickerRowInfo = nil;
}

- (NSArray *)indexPathsForTextInputRowItems
{
    return [self.mutableTextInputIndexPaths sortedArrayUsingSelector:@selector(compare:)];
}

-(void) tableView:(UITableView *)tableView updateEnabledSectionsWithIndexPath:(NSIndexPath*)indexPath
{
    NSString *dependencyPropertyName = [self rowInfoForItemAtIndexPath:indexPath][MUFormDependencyPropertyNameKey];
    NSString *propertyName = dependencyPropertyName ?: [self rowInfoForItemAtIndexPath:indexPath][MUFormPropertyNameKey];
    MUAssert(propertyName, @"Expected property name for indexpath %@",indexPath);
    
    NSMutableArray *dependentSectionPropertyNames = [NSMutableArray array];
    [self enumerateSectionsUsingBlock:^(NSDictionary *sectionInfo, NSUInteger idx, BOOL *stop) {
        if ([propertyName isEqualToString:sectionInfo[MUFormSectionEnabledPropertyNameKey]]) {
            [dependentSectionPropertyNames addObject:@(idx)];
        }
    }];
    
    if ([dependentSectionPropertyNames count]) {
        BOOL enabled = [[self.model valueForKeyPath:propertyName] boolValue];
        [tableView beginUpdates];
        for (NSNumber *sectionNumber in dependentSectionPropertyNames) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([sectionNumber integerValue], 1)];
            if (enabled) {
                [tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        [tableView endUpdates];
    }
}

#pragma mark - Getting & Setting Section Information -

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    NSString *localizedKey = sectionInfo[MUFormLocalizedSectionHeaderTitleKey];
    return [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
}

- (NSString *)titleForFooterInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    NSString *localizedKey = sectionInfo[MUFormLocalizedSectionFooterTitleKey];
    return [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
}


#pragma mark - Getting & Setting Values on the Model -

- (void)enumerateSectionsUsingBlock:(void (^)(NSDictionary *sectionInfo, NSUInteger idx, BOOL *stop))block
{
    [self.rawSections enumerateObjectsUsingBlock:block];
}

- (id)valueForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        return nil;
    }
    
    id value = nil;
    NSDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    NSString *keyPath = rowInfo[MUFormPropertyNameKey];
    if ([keyPath length] == 0) {
        keyPath = rowInfo[MUFormPropertyNameGetterKey];
    }
    
    if ([keyPath length] > 0) {
        @try {
            value = [self.model valueForKeyPath:keyPath];
        }
        @catch (NSException *exception) {
            MUAssert(YES, @"Attempt to get a value at an invalid keypath (%@) for indexPath (%@)\n%@",
                     keyPath, indexPath, [exception reason]);
        }
    }
    
    return value;
}

- (void)setValue:(id)value forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        return;
    }
    
    NSDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    NSString *keyPath = rowInfo[MUFormPropertyNameKey];
    if ([keyPath length] == 0) {
        keyPath = rowInfo[MUFormPropertyNameSetterKey];
    }    
    
    if ([keyPath length] > 0) {
        @try {
            [self validateValue:&value forItemAtIndexPath:indexPath error:NULL];
            [self.model setValue:value forKeyPath:keyPath];
        }
        @catch (NSException *exception) {
            MUAssert(YES, @"Attempt to set a value (%@) at an invalid keypath (%@)\n%@",
                     value, keyPath, [exception reason]);
        }
    }
}

- (void)selectOptionAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    NSNumber *defaultValue = rowInfo[MUFormDefaultValueKey];
    
    NSNumber *value = [self valueForItemAtIndexPath:indexPath];
    if ([value isEqualToNumber:defaultValue] == NO) {
        [self setValue:defaultValue forItemAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)indexPathForRowInfoWithTag:(NSString *)tag
{
    __block NSIndexPath *indexPath;
     [self enumerateSectionsUsingBlock:^(NSDictionary *sectionInfo, NSUInteger sectionIdx, BOOL *stopForSections) {
        NSArray *rows = sectionInfo[MUFormSectionRowsKey];
        [rows enumerateObjectsUsingBlock:^(NSDictionary *rowInfo, NSUInteger rowIdx, BOOL *stopForRows) {
            if ([tag isEqualToString:rowInfo[MUFormCellTagKey]]) {
                indexPath = [NSIndexPath indexPathForRow:rowIdx inSection:sectionIdx];
                (*stopForRows) = YES;
                (*stopForSections) = YES;
            }
        }];
     }];
     return indexPath;
}

- (NSInteger)indexForSectionInfoWithTag:(NSString *)tag
{
    __block NSInteger index = NSNotFound;
     [self enumerateSectionsUsingBlock:^(NSDictionary *sectionInfo, NSUInteger sectionIdx, BOOL *stop) {
        if ([tag isEqualToString:sectionInfo[MUFormSectionTagKey]]) {
            index = sectionIdx;
            (*stop) = YES;
        }
     }];
     return index;
}

- (void)addRowInfo:(NSDictionary *)rowInfo inSection:(NSInteger)section
{
    NSMutableDictionary *sectionInfo = [self.rawSections[section] mutableCopy];
    NSMutableArray *rows = [sectionInfo[MUFormSectionRowsKey] mutableCopy];
    if (!rows) {
        rows = [NSMutableArray array];
    }
    [rows addObject:[rowInfo mutableCopy]];
    sectionInfo[MUFormSectionRowsKey] = rows;
    NSMutableArray *rawSectionsMutable = [self.rawSections mutableCopy];
    rawSectionsMutable[section] = sectionInfo;
    
    self.rawSections = rawSectionsMutable;
    [self reloadFormData];
}

#pragma mark - Validation -


- (BOOL)validateValue:(__autoreleasing id *)value forItemAtIndexPath:(NSIndexPath *)indexPath error:(NSError *__autoreleasing *)outError
{
    NSMutableDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    NSString *keyPath = rowInfo[MUFormPropertyNameKey];
    if ([keyPath length] == 0) {
        keyPath = rowInfo[MUFormPropertyNameSetterKey];
    }
    
    NSError *error = nil;
    BOOL isValid = [self.model validateValue:value forKey:keyPath error:&error];
    if (outError != NULL) {
        *outError = error;
    }
    
    NSArray *validationMessages = LocalizedValidationMessagesForError(error);
    if (validationMessages) {
        rowInfo[MUValidationMessagesKey] = validationMessages;
    }
    else {
        [rowInfo removeObjectForKey:MUValidationMessagesKey];
    }
    
    return isValid;
}

- (BOOL)validationErrorForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    return (rowInfo[MUValidationMessagesKey] != nil);
}

#pragma mark - Table View Data Source -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.mutableTextInputIndexPaths = nil;
    [self updateActiveSections];
    return [self.activeSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *sectionInfo = self.activeSections[section];
    NSArray *rows = sectionInfo[MUFormSectionRowsKey];
    
    // Count and include only the rows that are enabled or don't specify a dependency.
    NSMutableArray *enabledRows = [NSMutableArray arrayWithCapacity:[rows count]];
    [rows enumerateObjectsUsingBlock:^(NSDictionary *rowInfo, NSUInteger idx, BOOL *stop) {
        BOOL isEnabled = YES;
        id value = nil;
        NSString *keyPath = rowInfo[MUFormDependentPropertyNameKey];
        if ([keyPath length] > 0) {
            value = [self.model valueForKeyPath:keyPath];
            if ([value isKindOfClass:[NSNumber class]]) {
                isEnabled = [value boolValue];
            }
            else {
                isEnabled = (value != nil);
            }
        }
        
        if (isEnabled) {
            [enabledRows addObject:rowInfo];
            
            // Collect index paths for rows representing text input.
            Class class = NSClassFromString(rowInfo[MUFormCellClassKey]);
            if ([class conformsToProtocol:@protocol(MUFormNextTextResponder)]) {
                if (self.mutableTextInputIndexPaths == nil) {
                    self.mutableTextInputIndexPaths = [NSMutableArray array];
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:section];
                [self.mutableTextInputIndexPaths addObject:indexPath];
            }
        }
    }];
    
    // Insert a time-picker cell, if necessary.
    if (self.timePickerIndexPath && (self.timePickerIndexPath.section == section)) {
        [enabledRows insertObject:self.timePickerRowInfo atIndex:self.timePickerIndexPath.row];
    }
    
    sectionInfo[MUFormSectionRowsKey] = enabledRows;
    self.activeSections[section] = sectionInfo;
    NSInteger count = [enabledRows count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *rowInfo = [self mu_rowInfoForItemAtIndexPath:indexPath];
    NSString *cellIdentifier = rowInfo[MUFormCellIdentifierKey];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if ([cell isKindOfClass:[MUFormBaseCell class]]) {
        
        id value = [self valueForItemAtIndexPath:indexPath];
        rowInfo[MUFormCellAttributeValuesKey] = [self mu_cellAttributeValuesForItemAtIndexPath:indexPath];
        
        if (self.configureCellBlock) {
            self.configureCellBlock(indexPath, (MUFormBaseCell *)cell, value, rowInfo);
        }
        else {
            [(MUFormBaseCell *)cell configureWithValue:value info:rowInfo];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self titleForFooterInSection:section];
}

@end
