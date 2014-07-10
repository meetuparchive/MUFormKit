//
//  MUFormTextViewCell.h
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormBaseCell.h"

@interface MUFormTextViewCell : MUFormBaseCell <UITextViewDelegate, MUFormNextTextResponder>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
