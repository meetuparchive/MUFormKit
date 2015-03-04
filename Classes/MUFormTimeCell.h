//
//  MUFormTimeCell.h
//  MeetupApp
//
//  Created by Wes on 9/13/13.
//
//

#import "MUFormBaseCell.h"

@interface MUFormTimeCell : MUFormBaseCell

@property (strong, nonatomic) UIFont *font UI_APPEARANCE_SELECTOR;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSTimeZone *timeZone;
    
@end
