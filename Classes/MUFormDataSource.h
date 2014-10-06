//
//  MUFormDataSource.h
//  MeetupApp
//
//  Created by Wes on 8/15/13.
//
//

#import <Foundation/Foundation.h>

@class MUFormBaseCell;

/**
 A configuration block executed when the table view requests a cell.
 
 @param cell The cell instance to be returned to the table view.
 @param value The value the cell is be representing.
 @param itemInfo Auxilliary information about how the cell should represent the value.
 */
typedef void (^ConfigureCellBlock)(NSIndexPath *indexPath, MUFormBaseCell *cell, id value, NSDictionary *itemInfo);


@interface MUFormDataSource : NSObject <UITableViewDataSource>

/**
 The model represented by the data source.
 */
@property (nonatomic, readonly, strong) id model;
    
/**
 A dictionary of cell classes keyed by reuse identifiers generated from the form structure.
 */
@property (nonatomic, readonly, strong) NSDictionary *cellClassesByIdentifier;

/**
 Metadata for the form.
 
 The keys for this dictionary are listed in “Form Metadata Keys.”
 */
@property (nonatomic, readonly, strong) NSDictionary *metadata;

/** 
 The structure of the form constructed as active sections depending on MUFormDependentPropertyNameKey
 
 Subclasses can redeclare this property as readwrite.
 */
@property (nonatomic, strong, readonly) NSMutableArray *activeSections;


/** 
 The structure of the form constructed as sections.
 
 */
@property (nonatomic, strong, readonly) NSArray *rawSections;

/**
 Indicates the index path of the time-picker, or nil if the time-picker is not active.
 */
@property (nonatomic, strong, readonly) NSIndexPath *timePickerIndexPath;


///-------------------------------------------------------------------
/// @name Initialization & Configuration
///-------------------------------------------------------------------


/**
 Instantiates an instance of the form data source.
 
 @param model The model this data source is representing - *required*.
 @param filePath The path to a JSON file containing the form structure.
 */
- (instancetype)initWithModel:(id)model JSONFilePath:(NSString *)filePath;

/**
 Instantiates an instance of the form data source.
 
 This is the designated initializer.
 
 @param model The model this data source is representing - *required*.
 @param formStructure The dictionary that describes this form.
 */
- (instancetype)initWithModel:(id)model formStructure:(NSDictionary *)formStructure;

/**
 Sets a configuration block for table view cells.
 
 @param cellConfigureBlock A block object to be executed when the table view requests a cell.
 @see `ConfigureCellBlock`
 */
- (void)setCellConfigureBlock:(ConfigureCellBlock)cellConfigureBlock;

///-------------------------------------------------------------------
/// @name Getting & Setting Row Item Information
///-------------------------------------------------------------------


/**
 Returns information about a data source item.
 
 @param indexPath The index path of the item.
 */
- (NSDictionary *)rowInfoForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a cell `Class` defined for a data source item at the specified index path.
 
 @param indexPath The index path of the item. 
 
 @return The `Class` indicating the cell used to represent an item at a given index path, or nil.
 */
- (Class)cellClassForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a segue identifier defined for a data source item at the specified index path.
 
 @param indexPath The index path of the item. 
 
 @return A segue identifier for a segue that should be performed when the item is tapped, or nil.
 */
- (NSString *)segueIdentifierForitemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns the height of a row at a given index path.
 
 @param indexPath The index path of the row.
 */
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Inserts a time picker cell at the specified index path.
 
 @param indexPath The index path of the row.
 @param relatedIndexPath The index path of the row invoking the time picker.
 @param timeZone  The time zone that the time picker should display times in.
 */
- (void)insertTimePickerAtIndexPath:(NSIndexPath *)indexPath relatedIndexPath:(NSIndexPath *)relatedIndexPath withTimeZone:(NSTimeZone *)timeZone;

/**
 Removes a time picker cell at the specified index path.
 
 @param indexPath The index path of the row.
 */
- (void)deleteTimePickerAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns an array of index paths where the row represents a text input form item.
 */
- (NSArray *)indexPathsForTextInputRowItems;

/**
 Signals to update tableview sections which were depandant on properties to display
 
 */
-(void) tableView:(UITableView *)tableView updateEnabledSectionsWithIndexPath:(NSIndexPath*)indexPath;


/// Disable the main UIControl on the cell.
- (void)setEnabled:(BOOL)isEnabled forRowAtIndexPath:(NSIndexPath *)indexPath;

///-------------------------------------------------------------------
/// @name Getting & Setting Section Information
///-------------------------------------------------------------------


/**
 Returns the number of rows in a section.
 
 @param section A section index into the data source.
 */
- (NSUInteger)numberOfRowsInSection:(NSInteger)section;

/**
 Returns an array of indexPaths in a section.
 
 @param section A section index into the data source.
 
 @return An array of indexPaths
 */
- (NSArray *)indexPathsForSection:(NSInteger)section;

/**
 Returns the height for a section header.
 
 @param section The section of the header height to return.
 */
- (CGFloat)heightForHeaderInSection:(NSInteger)section;

/**
 Returns the height for a section footer.
 
 @param section The section of the footer height to return.
 */
- (CGFloat)heightForFooterInSection:(NSInteger)section;

/**
 Returns the title for a given section header.
 
 @param section The section whose header title you want returned.
 */
- (NSString *)titleForHeaderInSection:(NSInteger)section;

/**
 Returns the title for a given section footer.
 
 @param section The section whose header footer you want returned.
 */
- (NSString *)titleForFooterInSection:(NSInteger)section;


///-------------------------------------------------------------------
/// @name Getting & Setting Values on the Model
///-------------------------------------------------------------------


/**
 Returns the value for the item at a given index path.
 
 @param indexPath The index path of the item whose value to retrieve.
 */
- (id)valueForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Sets the value of an item at a given index path.
 
 @param value The value to be set.
 @param indexPath The index path of the item whose value should be set.
 */
- (void)setValue:(id)value forItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns the indexPath for the row info with the given tag, nil if no row info was found
 
 @param tag The tag of the item whose indexPath to retreive.
 */
- (NSIndexPath *)indexPathForRowInfoWithTag:(NSString *)tag;

/**
 Returns the index for the row info with the given tag, nil if no row info was found
 
 @param tag The tag of the item whose index to retreive.
 */
- (NSInteger)indexForSectionInfoWithTag:(NSString *)tag;

/**
 Adds row info to existing form structure
 
 @param rowInfo The info to add, appended to existing rows
 @param section The section to add row info
 */
- (void)addRowInfo:(NSDictionary *)rowInfo inSection:(NSInteger)section;

///-------------------------------------------------------------------
/// @name Validation
///-------------------------------------------------------------------


/**
 Validates a value at a given index path.
 
 @param value A pointer to a value to be validated.
 @param indexPath The index path of the data-source item mapped to the value to be validated.
 @param error An out error object that describes the validation error.
 
 @see `validationErrorAtIndexPath:`
 */
- (BOOL)validateValue:(id *)value forItemAtIndexPath:(NSIndexPath *)indexPath error:(NSError **)error;

/**
 Indicates whether or not there are validation errors at a given index path.
 */
- (BOOL)validationErrorForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
