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

@property (assign, nonatomic, getter=isAnimating) BOOL animating;
@property (copy, nonatomic) void(^selectedAnimationCompletion)();
@end

@implementation MUFormOptionCell

#pragma mark - Properties -

- (void)setFont:(UIFont *)font {
    _font = font;
    self.staticLabel.font = font;
}

#pragma mark - Overrides -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!selected && animated) {
        self.animating = YES;
        
        // This block will be run at the end of the selected animation.
        [CATransaction setCompletionBlock:^{
            self.animating = NO;
            if (self.selectedAnimationCompletion) {
                self.selectedAnimationCompletion();
                self.selectedAnimationCompletion = NULL;
            }
        }];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];

    __weak __typeof__(self) weakSelf = self;
    void (^setStyle)() = ^{
        weakSelf.selectionStyle = enabled ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    };
    
    if (self.isAnimating) {
        self.selectedAnimationCompletion = setStyle;
    }
    else {
        setStyle();
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
    
    self.enabled = ![info[MUFormCellIsDisabledKey] boolValue];
}

@end
