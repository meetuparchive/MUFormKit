//
//  MUFormToggleCell.m
//  MeetupApp
//
//  Created by Wes on 9/12/13.
//
//

#import "MUFormActivationCell.h"

@implementation MUFormActivationCell

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if ([self.delegate respondsToSelector:@selector(formActivationCell:didChangeValue:)]) {
        [self.delegate formActivationCell:self didChangeValue:self.optionSwitch.isOn];
    }
}

@end
