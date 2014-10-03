//
//  MUFormOptionCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 7/2/13.
//
//

#import "MUFormOptionCell.h"

static CGFloat const MUDefaultCheckMarkAccessoryWidth = 38.5;

@interface MUFormOptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *staticLabelTrailingSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTrailingSpaceConstraint;

@end

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

    BOOL isValueEqualToDefault = [value isEqual:info[MUFormDefaultValueKey]];
    if (isValueEqualToDefault && self.accessoryType != UITableViewCellAccessoryCheckmark) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.staticLabelTrailingSpaceConstraint.constant = 0;
        self.messageLabelTrailingSpaceConstraint.constant = 0.;
        [self setNeedsUpdateConstraints];
    }
    else if (!isValueEqualToDefault && self.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.staticLabelTrailingSpaceConstraint.constant = MUDefaultCheckMarkAccessoryWidth;
        self.messageLabelTrailingSpaceConstraint.constant = MUDefaultCheckMarkAccessoryWidth;
        [self setNeedsUpdateConstraints];
    }
    
    NSString *localizedStaticTextKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedStaticTextKey value:localizedStaticTextKey table:MUFormKitStringTable];
   
    NSString *localizedCellMessageKey = info[MUFormLocalizedCellMessageKey];
    self.messageLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedCellMessageKey value:localizedCellMessageKey table:MUFormKitStringTable];
    
}

@end
