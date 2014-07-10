//
//  MUFormSwitchCell.m
//  MeetupApp
//
//  Created by Wes on 8/18/13.
//
//

#import "MUFormSwitchCell.h"

@implementation MUFormSwitchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        NSAssert([value isKindOfClass:[NSNumber class]], @"Expected ‘value’ to be an NSNumber. It was: %@", [value class]);
        [self.optionSwitch setOn:[value boolValue] animated:NO];
    }
    else {
        NSNumber *defaultValue = info[MUFormDefaultValueKey];
        [self.optionSwitch setOn:[defaultValue boolValue] animated:NO];
    }
    
    NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if ([self.delegate respondsToSelector:@selector(switchCell:didChangeValue:)]) {
        [self.delegate switchCell:self didChangeValue:sender.isOn];
    }
}

@end
