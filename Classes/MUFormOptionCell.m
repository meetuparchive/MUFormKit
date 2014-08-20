//
//  MUFormOptionCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 7/2/13.
//
//

#import "MUFormOptionCell.h"

static CGFloat const MUDefaultCheckMarkAccessoryWidth = 38.5;

@implementation MUFormOptionCell

#pragma mark - Overrides -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1 &&
        self.accessoryType == UITableViewCellAccessoryNone &&
        [self.delegate respondsToSelector:@selector(optionCellDidBecomeSelectedOptionCell:)]) {
        [self.delegate optionCellDidBecomeSelectedOptionCell:self];
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
    
    BOOL isValueEqualToDefault = [value isEqualToNumber:defaultValue];
    
    if (isValueEqualToDefault && self.accessoryType != UITableViewCellAccessoryCheckmark) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.staticLabelTrailingSpaceConstraint.constant = 0;
        self.staticDetailLabelTrailingSpaceConstraint.constant = 0.;
        [self setNeedsUpdateConstraints];
    }
    else if (!isValueEqualToDefault && self.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.staticLabelTrailingSpaceConstraint.constant = MUDefaultCheckMarkAccessoryWidth;
        self.staticDetailLabelTrailingSpaceConstraint.constant = MUDefaultCheckMarkAccessoryWidth;
        [self setNeedsUpdateConstraints];
    }
    
    NSString *localizedStaticTextKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedStaticTextKey value:localizedStaticTextKey table:MUFormKitStringTable];
   
    NSString *localizedStaticDetailTextKey = info[MUFormLocalizedStaticDetailTextKey];
    self.staticDetailLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedStaticDetailTextKey value:localizedStaticDetailTextKey table:MUFormKitStringTable];
    
}

@end
