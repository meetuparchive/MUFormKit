//
//  MUFormNumberFieldCell.h
//  MeetupApp
//
//  Created by Wesley Smith on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormBaseCell.h"

@interface MUFormNumberFieldCell : MUFormBaseCell <UITextFieldDelegate, MUFormNextTextResponder>

@property (strong, nonatomic) UIFont *font UI_APPEARANCE_SELECTOR;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberField;

@end
