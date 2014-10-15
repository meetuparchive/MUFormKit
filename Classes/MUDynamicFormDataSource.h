//
//  MUDynamicFormDataSource.h
//  MeetupApp
//
//  Created by Alistair on 11/21/13.
//  Copyright (c) 2013 Meetup, Inc. All rights reserved.
//

#import "MUFormDataSource.h"

typedef NS_ENUM(NSInteger, MUDynamicRowType) {
    MUDynamicRowTypeNone,
    MUDynamicRowTypeDefault,
    MUDynamicRowTypeAddNewItem
};

@class MUDynamicFormDataSource;
@protocol MUMembersFormEditingDelegate <NSObject>

@required
-(BOOL) membersFormDataSource:(MUDynamicFormDataSource*)datasource shouldDeleteItemAtIndexPath:(NSIndexPath*)indexPath;
-(void) membersFormDataSource:(MUDynamicFormDataSource*)datasource didInsertItemAtIndexPath:(NSIndexPath*)indexPath;
-(void) membersFormDataSource:(MUDynamicFormDataSource*)datasource didDeleteItemAtIndexPath:(NSIndexPath*)indexPath;

@end



@interface MUDynamicFormDataSource : MUFormDataSource

/**
 Returns the array property type for the given section or nil if the section does not contain and array property type
 
 @param section The section index to get the array property type
 */

-(NSArray *) arrayPropertyValueForSection:(NSUInteger)section;

/**
 Returns the type of row for the given indexPath
 
 @param indexPath The index path of the item.
 */
-(MUDynamicRowType) rowTypeForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns if this row was added during the current editing context, useful for displaying destructive confirmation dialogues
 
 @param indexPath The index path of the item.
 */
-(BOOL) isAddedRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Updates the datasource for adding an item
 
 @param indexPath The index path of the item.
 */
-(void) tableView:(UITableView *)tableView didAddItemAtIndexPath:(NSIndexPath*)indexPath;

/**
 Updates the datasource for removing an item
 
 @param indexPath The index path of the item.
 */
-(void) tableView:(UITableView *)tableView didRemoveItemAtIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, weak) id<MUMembersFormEditingDelegate> editingDelegate;

@end
