//
//  MUFormController.h
//  MeetupApp
//
//  Created by Wes on 8/18/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormBaseCell.h"
#import "MUNextResponderController.h"

@class MUFormDataSource;

@interface MUFormController : UITableViewController <MUFormCellDelegate>

/** The data source binding a model object the form. */
@property (nonatomic, strong) MUFormDataSource *dataSource;

/** Stored the last tapped index path. */
@property (nonatomic, strong) NSIndexPath *lastTappedIndexPath;

@property (nonatomic) MUNextResponderController *nextResponderController;

@property (nonatomic, assign, readonly) BOOL isKeyboardShowing;

/**
 Returns the height for a row at the specified index path.
 
 @discussion This method gets the cell height from the cell defined for the specified index path.
 */
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;


- (void)viewDidLoad NS_REQUIRES_SUPER;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

/**
    Should be called by any overriden cell delegate method. Passes the changes on to the
    data source and calls `-didChangeValue:forItemAtIndexPath:`.
*/
- (void)changeValue:(id)value forItemAtIndexPath:(NSIndexPath *)indexPath;

/**
    Never call this method directly. This is exposed for subclasses to override and
    perform additional operations whenever form values change.
*/
- (void)didChangeValue:(id)value forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
