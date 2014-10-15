//
//  MUFormSwitchCell.h
//  MeetupApp
//
//  Created by Wes on 8/18/13.
//
//

#import "MUFormBaseCell.h"

@interface MUFormSwitchCell : MUFormBaseCell

@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (strong, nonatomic) IBOutlet UISwitch *optionSwitch;

@end
