//
//  MUDynamicFormDataSource.m
//  MeetupApp
//
//  Created by Alistair on 11/21/13.
//  Copyright (c) 2013 Meetup, Inc. All rights reserved.
//

#import "MUDynamicFormDataSource.h"
#import "MUFormConstants.h"

NSString *const MUFormSectionRowPrototypeKey        = @"MUFormSectionRowPrototypeKey";
NSString *const MUFormSectionRowAddKey              = @"MUFormSectionRowAddKey";
NSString *const MUFormSectionArrayKeypathKey        = @"MUFormSectionArrayKeypathKey";
NSString *const MUFormSectionIndexedValueKeypathKey = @"MUFormSectionIndexedValueKeypathKey";


@interface MUDynamicFormDataSource ()

/**
 A dictionary of cell classes keyed by reuse identifiers generated from the form structure.
 */
@property (nonatomic, strong) NSDictionary *dynamicCellClassesByIdentifier;

/**
 A dictionary of index paths for new cells
 */
@property (nonatomic, readonly, strong) NSMutableDictionary *addedCellIndexPaths;


@end

@implementation MUDynamicFormDataSource

- (id)initWithModel:(id)model JSONFilePath:(NSString *)filePath
{
    self = [super initWithModel:model JSONFilePath:filePath];
    if (self) {
        _addedCellIndexPaths = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - MUFormDataSource overrides -

- (NSDictionary *)cellClassesByIdentifier
{
    if (!self.dynamicCellClassesByIdentifier) {
        NSDictionary *parentIdentifiers = [super cellClassesByIdentifier];
        
        NSArray *prototypeRows = [self.rawSections valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@",MUFormSectionRowPrototypeKey]];
        NSArray *addCellRows = [self.rawSections valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@",MUFormSectionRowAddKey]];
        NSArray *rows = [prototypeRows arrayByAddingObjectsFromArray:addCellRows];
        
        NSMutableDictionary *classesById = [NSMutableDictionary dictionaryWithDictionary:parentIdentifiers];
        for (NSDictionary *rowInfo in rows) {
            classesById[rowInfo[MUFormCellIdentifierKey]] = rowInfo[MUFormCellClassKey];
        }
        self.dynamicCellClassesByIdentifier = [classesById copy];
    }
    return self.dynamicCellClassesByIdentifier;
}

- (NSDictionary *)rowInfoForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        return nil;
    }
    NSDictionary *prototypeRowInfo = [self prototypeRowInfoForIndexPath:indexPath];
    if (prototypeRowInfo) {
        return prototypeRowInfo;
    } else {
        return [super rowInfoForItemAtIndexPath:indexPath];
    }
}

- (id)valueForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        return nil;
    }
    
    id value;
    NSArray *arrayPropertyValue = (NSArray *)[self arrayPropertyValueForSection:[indexPath section]];
    if(arrayPropertyValue) {
        if ([self isAddNewItemForRowAtIndexPath:indexPath]) {
            return nil;
        } else {
            MUAssert([arrayPropertyValue respondsToSelector:@selector(objectAtIndex:)],
            @"Dynamic property is incorrect object type for indexPath (%@)\n", indexPath);
            
            value = arrayPropertyValue[[indexPath row]];
            NSDictionary *sectionInfo = self.activeSections[[indexPath section]];
            NSString *indexedKeypath = sectionInfo[MUFormSectionIndexedValueKeypathKey];
            if (indexedKeypath) {
                value = [value valueForKeyPath:indexedKeypath];
            }
            
        }
    } else {
        value = [super valueForItemAtIndexPath:indexPath];
    }
    
    return value;
}

- (void)setValue:(id)value forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        return;
    }
    
    NSArray *arrayPropertyValue = (NSArray *)[self arrayPropertyValueForSection:[indexPath section]];
    
    if(arrayPropertyValue) {
        
        NSDictionary *sectionInfo = self.activeSections[[indexPath section]];
        NSString *indexedKeypath = sectionInfo[MUFormSectionIndexedValueKeypathKey];
        if ((NSUInteger)[indexPath row]<[arrayPropertyValue count]) {
            id indexedValue = [arrayPropertyValue objectAtIndex:[indexPath row]];
            @try {
                [indexedValue setValue:value forKeyPath:indexedKeypath];
            }
            @catch (NSException *exception) {
                MUAssert(NO, @"Attempt to set a value (%@) at an invalid keypath %@\n%@", value, indexedKeypath, [exception reason]);
            }
        }
    } else {
        [super setValue:value forItemAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource overrides

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dynamicValues = (NSArray *)[self arrayPropertyValueForSection:section];
    if (dynamicValues) {
        NSUInteger dynamicValuesWithAddNewCell = [dynamicValues count] + ([self hasAddNewCellForSection:section] ? 1 : 0);
        NSUInteger maxCellsCount = [self maxRowsForDynamicSection:section];
        return MIN(dynamicValuesWithAddNewCell, maxCellsCount);
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)    tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.editingDelegate membersFormDataSource:self shouldDeleteItemAtIndexPath:indexPath]) {
            [self tableView:tableView didRemoveItemAtIndexPath:indexPath];
        }
    }
}

#pragma mark - Data editing

-(void) tableView:(UITableView *)tableView didRemoveItemAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView beginUpdates];
    BOOL outCouldAddMore;
    [self removeCellForRowAtIndexPath:indexPath couldAddMore:&outCouldAddMore];
    if (outCouldAddMore) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        //User has deleted a row but the actual amount of cells does not change, reload the whole section
        //so the 'Add more' cell can become visible again.
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
}

-(void) tableView:(UITableView *)tableView didAddItemAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView beginUpdates];
    BOOL canAddMore;
    [self addNewCellForRowAtIndexPath:indexPath canAddMore:&canAddMore];
    if (canAddMore) {
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
}

#pragma mark - Helpers

-(NSArray *) arrayPropertyValueForSection:(NSUInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    NSString *propertyKeyPath = sectionInfo[MUFormSectionArrayKeypathKey];
    if ([propertyKeyPath length]) {
        @try {
            return [self.model valueForKeyPath:propertyKeyPath];
        }
        @catch (NSException *exception) {
            MUAssert(NO, @"Attempt to get a dynamic value %@ for section (%lu)\n%@", propertyKeyPath, (unsigned long)section, [exception reason]);
        }
    }
    return nil;
}

-(NSUInteger) maxRowsForDynamicSection:(NSUInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    NSNumber *maxRowsNumber = sectionInfo[MUFormSectionDynamicRowLimitKey];
    NSInteger maxRowsInteger = NSUIntegerMax;
    if (maxRowsNumber) {
        maxRowsInteger = [maxRowsNumber integerValue];
    }
    return maxRowsInteger;
}

-(NSDictionary*) prototypeRowInfoForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionInfo = self.activeSections[[indexPath section]];
    if ([self isAddNewItemForRowAtIndexPath:indexPath]) {
        return sectionInfo[MUFormSectionRowAddKey];
    } else {
        return sectionInfo[MUFormSectionRowPrototypeKey];
    }
}

-(MUDynamicRowType) rowTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dynamicCellsDatasource = [self arrayPropertyValueForSection:[indexPath section]];
    if (dynamicCellsDatasource) {
        NSUInteger count = [dynamicCellsDatasource count];
        if ((NSUInteger)[indexPath row]<count) {
            return MUDynamicRowTypeDefault;
        }
        NSUInteger max = [self maxRowsForDynamicSection:[indexPath section]];
        if (count<max) {
            return MUDynamicRowTypeAddNewItem;
        }
    }
    return MUDynamicRowTypeNone;
}

-(NSIndexPath*) indexPathForAddNewItemWithSection:(NSUInteger)section
{
    NSUInteger maxRowsForDynamicSection = [self maxRowsForDynamicSection:section];
    return [NSIndexPath indexPathForRow:maxRowsForDynamicSection-1 inSection:section];
}

#pragma mark - Add New Cell

-(BOOL) isAddNewItemForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self rowTypeForRowAtIndexPath:indexPath] == MUDynamicRowTypeAddNewItem;
}

-(BOOL) isAddedRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.addedCellIndexPaths[indexPath] != nil;
}

-(BOOL) hasAddNewCellForSection:(NSInteger)section
{
    NSDictionary *sectionInfo = self.activeSections[section];
    return sectionInfo[MUFormSectionRowAddKey] != nil;
}

-(void) addNewCellForRowAtIndexPath:(NSIndexPath *)indexPath canAddMore:(BOOL *)outCanAddMore
{
    NSInteger section = [indexPath section];
    self.addedCellIndexPaths[indexPath] = @1;
    [self.editingDelegate membersFormDataSource:self didInsertItemAtIndexPath:indexPath];
    NSArray *dynamicCellsDatasource = [self arrayPropertyValueForSection:section];
    if (outCanAddMore) {
        (*outCanAddMore) = [dynamicCellsDatasource count] < [self maxRowsForDynamicSection:section];
    }
}

-(void) removeCellForRowAtIndexPath:(NSIndexPath *)indexPath couldAddMore:(BOOL *)outCouldAddMore
{
    NSInteger section = [indexPath section];
    NSArray *dynamicCellsDatasource = [self arrayPropertyValueForSection:section];
    if (outCouldAddMore) {
        (*outCouldAddMore) = [dynamicCellsDatasource count] < [self maxRowsForDynamicSection:section];
    }
    [self.editingDelegate membersFormDataSource:self didDeleteItemAtIndexPath:indexPath];
}


@end
