//
//  MUFormTextViewCell.h
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormDynamicHeightCell.h"
#import "MUResizingTextView.h"

@interface MUFormTextViewCell : MUFormDynamicHeightCell <MUResizingTextViewDelegate, MUFormNextTextResponder>

@property (weak, nonatomic) IBOutlet MUResizingTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
