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

    // This is dirty, but it's the only way to get the labels to render at the right height
    // on first layout on iOS 8. If I do this during setFrame or layoutSubviews,
    // it's somehow too late, even if I trigger another layout pass.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        CGFloat staticLabelMargins = CGRectGetWidth(self.frame) - CGRectGetWidth(self.staticLabel.frame);
        CGFloat messageLabelMargins = CGRectGetWidth(self.frame) - CGRectGetWidth(self.messageLabel.frame);
        self.staticLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - staticLabelMargins;
        self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - messageLabelMargins;
    }
}

- (void)setEnabled:(BOOL)enabled {
    self.optionSwitch.enabled = enabled;
}
- (BOOL)isEnabled {
    return self.optionSwitch.isEnabled;
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
    
    NSString *localizedCellMessageKey = info[MUFormLocalizedCellMessageKey];
    self.messageLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedCellMessageKey value:localizedCellMessageKey table:MUFormKitStringTable];

    self.optionSwitch.enabled = ![info[MUFormCellIsDisabledKey] boolValue];
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
