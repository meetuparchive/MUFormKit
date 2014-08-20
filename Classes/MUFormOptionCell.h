//
//  MUFormOptionCell.h
//  MeetupApp
//
//  Created by Wesley Smith on 7/2/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormDynamicHeightCell.h"

@interface MUFormOptionCell : MUFormDynamicHeightCell

@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *staticLabelTrailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet UILabel *staticDetailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *staticDetailLabelTrailingSpaceConstraint;

@end
