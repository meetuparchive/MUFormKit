
#import "MUFormBaseCell.h"
#import "MUFormDataSource.h"

@interface MUNextResponderController : NSObject



/**
 Triggers a next responder event at the given index path, force this index to become the first responder
 
 @param indexPath the index path to focus first reponder on
 @param completion a callback for completion of the next responder
 */

- (void) focusOnNextResponderAtIndexPath:(NSIndexPath*)indexPath completion:(void(^)(BOOL didFindNextResponder))completion;


/**
 Triggers a next responder search from the given index path, if a subsequent compatible cell is found it will be made first responder, typically called when the user taps 'Next' on the keyboard. If no cell is found completion is called with didFindNextResponder = NO
 
 @param indexPath the index path from which to start searching for next responder
 @param completion a callback for completion of the next responder search
 */

- (void) focusOnNextResponderFromIndexPath:(NSIndexPath*)indexPath completion:(void(^)(BOOL didFindNextResponder))completion;

/**
 Allows this controller to make the displayed cell the first responder if necessary
 
 @param cell the cell displayed
 @param indexPath the the cell displayed index
 */

- (void) willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) MUFormDataSource *dataSource;


@end
