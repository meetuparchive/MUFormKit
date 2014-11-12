//
//  MUFormPushCell.h
//  MeetupApp
//
//  Created by Wes on 9/9/13.
//
//

#import "MUFormIconCell.h"

/// Indicates whether or not the sub form is enabled.
extern NSString *const MUFormSubformEnabledPropertyNameKey;

/// KeyPath to a summarized value of the sub-form.
extern NSString *const MUFormSubformValuePropertyNameKey;

///-------------------------------------------------------------------
/// @name Form to Form Segue Cell
///-------------------------------------------------------------------

/**
 Use this cell to create seques between a form and pushed sub-forms.
 */
@interface MUFormToFormSegueCell : MUFormIconCell

@end
