//
//  MUFormBaseCell.h
//  MeetupApp
//
//  Created by Wesley Smith on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormConstants.h"
#import "MUValidationErrors.h"

extern NSString *const MUFormCellMinimumDateKey;
extern NSString *const MUFormCellMaximumDateKey;

/// The time zone of all dates that are passed into the cell
extern NSString *const MUFormCellTimeZoneKey;


@protocol MUFormNextTextResponder, MUFormCellDelegate;

@class MUFormDateTimeCell, MUFormTimePickerCell, MUFormTextFieldCell, MUFormTextViewCell, MUFormNumberFieldCell, MUFormOptionCell, MUFormSwitchCell, MUFormActivationCell;

@interface MUFormBaseCell : UITableViewCell

///-------------------------------------------------------------------
/// @name Properties
///-------------------------------------------------------------------

/** Defines a color for labels with default/placeholder values. */
@property (nonatomic, strong) UIColor *defaultValueTextColor UI_APPEARANCE_SELECTOR;

/** Defines a text color for labels. */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

/** An object conforming to the `MUFormCellDelegate` protocol. */
@property (nonatomic, weak) id <MUFormCellDelegate> delegate;

/** A dictionary of cell specific attributes if there are any defined. */
@property (nonatomic, strong) NSDictionary *cellAttributes;

/** An image view for displaying an icon. Default is nil. */
@property (nonatomic, weak) IBOutlet UIImageView *iconView;

/**  A label for displaying misc information (e.g. validation message). Default is nil. */
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

/** Indicates whether the value represented is a default. The default value is `NO`. */
@property (nonatomic) BOOL representsDefaultValue;

// iOS6: These can dies when dropping ios 6.
@property (weak, nonatomic) IBOutlet UIView *containerView; // Maybe..
@property (nonatomic, getter = isFirstInSection) BOOL firstInSection; // Kill in iOS 7.
@property (nonatomic, getter = isLastInSection) BOOL lastInSection; // Kill in iOS 7.
@property (nonatomic, getter = isIndented) BOOL indented; // Kill in iOS 7.


///-------------------------------------------------------------------
/// @name Class Methods
///-------------------------------------------------------------------


/**
 Computes and returns the height of a cell for a given configuration.
 
 @param value The value to be represented by the cell.
 @param info  Additional info that can be used by subclasses.
 
 @discussion This method does nothing by default and returns 44.0.
             Subclasses should override this method to compute the cell's height.
 */
+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info;


///-------------------------------------------------------------------
/// @name Instance Methods
///-------------------------------------------------------------------

- (void)awakeFromNib NS_REQUIRES_SUPER;

/**
 Configures the cell.
 
 @param value The value to be represented by the cell.
 @param info  Additional info that can be used by subclasses.
 
 @warning Don't forget to call `super` at the start of the method.
 */
- (void)configureWithValue:(id)value info:(NSDictionary *)info NS_REQUIRES_SUPER;

@end


///-------------------------------------------------------------------
/// @name Form Cell Delegate Protocol
///-------------------------------------------------------------------


@protocol MUFormCellDelegate <NSObject>

@optional

/**
 Tells the delegate that the date was tapped.
 
 @param sender The cell object whose date was tapped.
 
 @discussion Implement this method to invoke a date picker to allow the user to choose a new date.
 */
- (void)dateTimeCellDidTapDate:(MUFormDateTimeCell *)sender;

/**
 Tells the delegate that the time was tapped.
 
 @param sender The cell object whose date was tapped.
 
 @discussion Implement this method to invoke a time picker to allow the user to choose a new time.
 */
- (void)dateTimeCellDidTapTime:(MUFormDateTimeCell *)sender;

/**
 Tells the delegate that the time change.
 
 @param sender The cell object whose time was changed.
 @param time An NSDate object representing the time chosen via the time picker.
 @param timeZone The time zone for the time picker cell.
 */
- (void)timePickerCell:(MUFormTimePickerCell *)sender didChangeTime:(NSDate *)time timeZone:(NSTimeZone *)timeZone;

/**
 Asks the delegate if it editing should begin on a text input cell.
 
 @param sender The cell object whose text field or text view wants to begin editing.
 @param textInputView The text field or text view the user has entered.
 */
- (BOOL)textInputCell:(MUFormBaseCell *)sender shouldBeginEditing:(UIView <UITextInput> *)textInputView;

/**
 Tells the delegate that a text input cell (e.g. MUFormTextFieldCell) began editing.
 
 @param sender         The cell object whose text field or text view began editing.
 @param textInputView  The text field or text view that the user is writing in.
 */
- (void)textInputCell:(MUFormBaseCell *)sender didBeginEditing:(UIView <UITextInput> *)textInputView;

/**
 Tells the delegate that a text input cell (e.g. MUFormTextFieldCell) text changed.
 
 @param sender The cell object whose text field or text view content was changed.
 @param text The current text in the text field or text view.
 */
- (void)textInputCell:(MUFormBaseCell *)sender textChanged:(NSString *)text;

/**
 Asks the delegate if the text field should return.
 
 @param sender The cell object whose text input view's return key was tapped.
 @param textInputView A text field ot text view that received the return tap.
 
 @return Whether or not to process the return tap.
 */
- (BOOL)textInputCell:(MUFormBaseCell *)sender textInputViewShouldReturn:(UIView <UITextInput> *)textInputView;

/**
 Tells the delegate that a text field is done editing.
 
 @param sender The cell object whose text field has completed editing.
 @param text The current text in the text field.
 */
- (void)textFieldCell:(MUFormTextFieldCell *)sender didEndEditingWithText:(NSString *)text;

/**
 Tells the delegate that a text view is done editing.
 
 @param sender The cell object whose text view content has completed editing.
 @param text The current text in the text view.
 */
- (void)textViewCell:(MUFormTextViewCell *)sender didEndEditingWithText:(NSString *)text;

/**
 Tells the delegate that a number field is done editing.
 
 @param sender The cell object whose number field has completed editing.
 @param number The current number in the number field.
 */
- (void)numberFieldCell:(MUFormNumberFieldCell *)sender didEndEditingWithNumber:(NSString *)number;

/**
 Tells the delegate that the number changed.
 
 @param sender The cell object whose number field content was changed.
 @param number The current number in the number field.
 */
- (void)numberFieldCell:(MUFormNumberFieldCell *)sender numberChanged:(NSString *)number;

/**
 Tells the delegate that the option cell was selected.
 
 @param sender The cell object whose text view content was changed.
 */
- (void)optionCellDidBecomeSelectedOptionCell:(MUFormOptionCell *)sender;

/**
 Tells the delegate that the switch value changed.
 
 @param sender The cell object whose switch value changed.
 @param selected The new position of the switch.
 */
- (void)switchCell:(MUFormSwitchCell *)sender didChangeValue:(BOOL)selected;

/**
 Tells the delegate that a form activation cell switch value changed.
 
 @param sender The cell object whose switch value changed.
 @param selected The new position of the switch.
 */
- (void)formActivationCell:(MUFormActivationCell *)sender didChangeValue:(BOOL)selected;

@end


///-------------------------------------------------------------------
/// @name Form Next Text Responder Protocol
///-------------------------------------------------------------------

/**
Form text input cell subclasses that can become the first responder on keyboard 'next' should implement this protocol.
 */
@protocol MUFormNextTextResponder <NSObject>

@end
