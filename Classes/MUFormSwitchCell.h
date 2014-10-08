//
//  MUFormSwitchCell.h
//  MeetupApp
//
//  Created by Wes on 8/18/13.
//
//

#import "MUFormDynamicHeightCell.h"

@interface MUFormSwitchCell : MUFormDynamicHeightCell

@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (strong, nonatomic) IBOutlet UISwitch *optionSwitch;

@end
