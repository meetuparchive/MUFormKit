//
//  MUFormStaticLabelCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import "MUFormStaticLabelCell.h"

CGFloat const kMUPadding = 13.0;

@interface MUFormStaticLabelCell ()

@end

@implementation MUFormStaticLabelCell

@dynamic staticLabel;
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.iconView.image = nil;
    self.staticLabel.text = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        MUAssert([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]], @"Expected a NSString or NSNumber.");
    }
    
    self.staticLabel.textColor = self.textColor;
    
    NSString *text = nil;
    if (value == nil || [value isKindOfClass:[NSString class]]) {
        text = (NSString *)value;
        
        // Try the default value.
        if ([text length] == 0) {
            NSString *localizedKey = info[MUFormLocalizedDefaultValueKey];
            text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
            if ([text length]) {
                self.staticLabel.textColor = self.defaultValueTextColor;
            }
        }
        
        // Try the static value.
        if ([text length] == 0) {
            NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
            text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
        }
    }
    
    // Try to combine numbers with static text.
    if ([value isKindOfClass:[NSNumber class]]) {
        NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
        NSString *staticText = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
        NSRange formatRange = [staticText rangeOfString:@"%@"];
        if (formatRange.location != NSNotFound) {
            NSString *numberString = [value stringValue];
            if ([value integerValue] == 0) {
                numberString = NSLocalizedString(@"No", nil);
            }
            text = [NSString stringWithFormat:staticText, numberString];
        }
    }
    
    self.staticLabel.text = text;

    if (info[MUFormLocalizedAccessibilityLabelKey]) {
        NSString *labelText = [[NSBundle mainBundle] localizedStringForKey:info[MUFormLocalizedAccessibilityLabelKey]
                                                                     value:info[MUFormLocalizedAccessibilityLabelKey]
                                                                     table:MUFormKitStringTable];
        self.staticLabel.accessibilityLabel = [NSString stringWithFormat:@"%@, %@", labelText, text];
    }
    
    UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
    NSNumber *accessoryTypeNumber = info[MUFormCellAccessoryTypeKey];
    if (accessoryTypeNumber) {
        accessoryType = [accessoryTypeNumber integerValue];
    }
    self.accessoryType = accessoryType;
}

@end
