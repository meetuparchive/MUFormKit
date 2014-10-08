//
//  MUFormDatePickerCell.h
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import <UIKit/UIKit.h>
#import "MUFormBaseCell.h"

@interface MUFormDateTimeCell : MUFormBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *indicatorImage;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSTimeZone *timeZone;

@end
