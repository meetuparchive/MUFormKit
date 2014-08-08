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
    self.optionSwitch.isAccessibilityElement = NO;
    self.isAccessibilityElement = YES;
}

#pragma mark - Accessibility

- (void)voiceOverActivate
{
    self.optionSwitch.on = !self.optionSwitch.on;
    [self switchValueChanged:self.optionSwitch];
}

- (NSInteger)accessibilityElementCount { return 1; }

- (id)accessibilityElementAtIndex:(NSInteger)index {
    return self.optionSwitch;
}

- (NSInteger)indexOfAccessibilityElement:(id)element{
    return element == self.optionSwitch ? 0 : NSNotFound;
}

- (UIAccessibilityTraits)accessibilityTraits {
    return [super accessibilityTraits] | self.optionSwitch.accessibilityTraits;
}

- (NSString *)accessibilityValue {
    return self.optionSwitch.accessibilityValue;
}

#pragma mark - MUFormBaseCell

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        MUAssert([value isKindOfClass:[NSNumber class]], @"Expected ‘value’ to be an NSNumber. It was: %@", [value class]);
        [self.optionSwitch setOn:[value boolValue] animated:NO];
    }
    else {
        NSNumber *defaultValue = info[MUFormDefaultValueKey];
        [self.optionSwitch setOn:[defaultValue boolValue] animated:NO];
    }
    
    NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
    
    self.accessibilityLabel = self.staticLabel.text;
    self.optionSwitch.accessibilityLabel = [NSString stringWithFormat:NSLocalizedString(@"%@ switch", @"<label> on/off setting switch"), self.staticLabel.text];
    
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if ([self.delegate respondsToSelector:@selector(switchCell:didChangeValue:)]) {
        [self.delegate switchCell:self didChangeValue:sender.isOn];
    }
}

@end
