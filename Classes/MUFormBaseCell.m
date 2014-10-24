//
//  MUFormBaseCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 7/1/13.
//
//

#import "MUFormBaseCell.h"


NSString *const MUFormCellMinimumDateKey = @"MUFormCellMinimumDateKey";
NSString *const MUFormCellMaximumDateKey = @"MUFormCellMaximumDateKey";

static CGFloat const kMUDefaultRowHeight = 44.0;
static CGFloat const kMUErrorLabelHeight = 20.0;

@interface MUFormBaseCell ()

@property (weak, nonatomic) NSLayoutConstraint *topLineLeadingContraint;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic) BOOL hasButtonAccessibilityTrait;

@end

@implementation MUFormBaseCell

+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info
{
    /** Override this method in subclasses. */
    
    CGFloat height = kMUDefaultRowHeight;
    if (info[MUValidationMessagesKey]) {
        height += kMUErrorLabelHeight;
    }
    return height;
}

+ (CGFloat)estimatedCellHeight
{
    return kMUDefaultRowHeight;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        _defaultValueTextColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _textColor = [UIColor colorWithWhite:0.05 alpha:1.0];
        _enabled = YES;
    }
    return self;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    /** Override this in subclasses and call super. */
    
    self.cellAttributes = info[MUFormCellAttributeValuesKey];
    if (info[MUFormCellAccessibilityButtonTraitKey]) {
        self.hasButtonAccessibilityTrait = [info[MUFormCellAccessibilityButtonTraitKey] boolValue];
    }
}

- (void)voiceOverActivate { }

- (UIAccessibilityTraits)accessibilityTraits {
    if (self.hasButtonAccessibilityTrait) {
        return [super accessibilityTraits] | UIAccessibilityTraitButton;
    } else {
        return [super accessibilityTraits];
    }
}

@end
