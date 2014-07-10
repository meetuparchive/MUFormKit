//
//  MURelativeDatePickerController.h
//  MeetupApp
//
//  Created by Wes on 8/15/13.
//
//

#import <UIKit/UIKit.h>

@interface MURelativeDatePickerController : UITableViewController <UIAppearanceContainer>

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, getter = isAscending) BOOL ascending;

///-------------------------------------------------------------------
/// @name Initialization
///-------------------------------------------------------------------

- (instancetype)initWithMinimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate;

///-------------------------------------------------------------------
/// @name Block-based Delegation
///-------------------------------------------------------------------

- (void)setCancelBlock:(void(^)(void))block;

- (void)setDidSelectDateBlock:(void(^)(NSDate *date))block;

@end
