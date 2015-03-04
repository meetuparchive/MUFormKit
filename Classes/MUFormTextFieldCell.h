//
//  MUFormTextFieldCell.h
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormIconCell.h"

@interface MUFormTextFieldCell : MUFormIconCell <UITextFieldDelegate, MUFormNextTextResponder>

/** @name Appearance Proxy */

@property (nonatomic) UITextBorderStyle borderStyle UI_APPEARANCE_SELECTOR;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelDescriptionHeightConstraint;

- (void)textFieldEditingChanged:(UITextField *)textField;
-(NSString*) textFieldText;

- (void)awakeFromNib NS_REQUIRES_SUPER;

@end
