//
//  MUFormOptionCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 7/2/13.
//
//

#import "MUFormOptionCell.h"

@implementation MUFormOptionCell

#pragma mark - Overrides -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        if (self.accessoryType == UITableViewCellAccessoryNone &&
            [self.delegate respondsToSelector:@selector(optionCellDidBecomeSelectedOptionCell:)]) {
            [self.delegate optionCellDidBecomeSelectedOptionCell:self];
        }
    }
    else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        MUAssert([value isKindOfClass:[NSNumber class]],
                 @"Expected ‘value’ to be an NSNumber. It was: %@", [value class]);
    }

    NSNumber *defaultValue = info[MUFormDefaultValueKey];
    if (defaultValue) {
        MUAssert([defaultValue isKindOfClass:[NSNumber class]],
                 @"Expected ‘defaultValue’ to be an NSNumber. It was: %@", [value class]);
    }
    
    if ([value isEqualToNumber:defaultValue]) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
}

@end
