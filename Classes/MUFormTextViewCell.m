//
//  MUFormTextViewCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import "MUFormTextViewCell.h"

static const CGFloat MUFormTextViewNumberOfLines = 3.0f;

@interface MUFormTextViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *validationMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleMarginConstraint;
@property (nonatomic, assign) CGFloat titleMarginConstraintConstant;
@property (nonatomic, assign) CGFloat validationMarginConstraintConstant;
@end

@implementation MUFormTextViewCell

#pragma mark - Overrides -

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.delegate = self;
    self.titleMarginConstraintConstant = self.titleMarginConstraint.constant;
    self.validationMarginConstraintConstant = self.validationMarginConstraint.constant;
    self.textView.minimumNumberOfLines = MUFormTextViewNumberOfLines;
    self.textView.maximumNumberOfLines = MUFormTextViewNumberOfLines;
}

- (void)dealloc {
    _textView.delegate = nil;
}
    
- (BOOL)becomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textView.text = nil;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        MUAssert([value isKindOfClass:[NSString class]], @"Expected ‘value’ to be an NSString. It was: %@", [value class]);
        self.textView.text = value;
    }
    else if (info[MUFormLocalizedDefaultValueKey]) {
        NSDictionary *attributes = @{
                       NSFontAttributeName: self.textView.font,
            NSForegroundColorAttributeName: self.defaultValueTextColor
        };
        
        NSString *localizedKey = info[MUFormLocalizedDefaultValueKey];
        NSString *localizedString = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
        self.textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:localizedString
                                                                              attributes:attributes];
    }
    
    NSString *staticLabelKey = info[MUFormLocalizedStaticTextKey];
    NSString *staticLabelString = [[NSBundle mainBundle] localizedStringForKey:staticLabelKey value:staticLabelKey table:MUFormKitStringTable];
    if ([staticLabelString length] > 0) {
        self.titleLabel.text = staticLabelString;
        self.titleMarginConstraint.constant = self.titleMarginConstraintConstant;
    }
    else {
        self.titleLabel.text = nil;
        self.titleMarginConstraint.constant = 0.0f;
    }

    if (info[MUFormLocalizedAccessibilityLabelKey]) {
        NSString *accessibilityLabelKey = info[MUFormLocalizedAccessibilityLabelKey];
        NSString *accessibilityLabelString = [[NSBundle mainBundle] localizedStringForKey:accessibilityLabelKey value:accessibilityLabelKey table:MUFormKitStringTable];
        self.textView.accessibilityLabel = accessibilityLabelString;
    }

    NSArray *validationMessages = info[MUValidationMessagesKey];
    if ([validationMessages count] > 0) {
        self.messageLabel.text = validationMessages[0];
        self.validationMarginConstraint.constant = self.validationMarginConstraintConstant;
    }
    else {
        self.messageLabel.text = @"";
        self.validationMarginConstraint.constant = 0.0f;
    }

    self.textView.editable = ![info[MUFormCellIsDisabledKey] boolValue];
}

- (void)setEnabled:(BOOL)enabled {
    self.textView.editable = enabled;
}
- (BOOL)isEnabled {
    return self.textView.editable;
}

#pragma mark - Properties -
- (void)setFont:(UIFont *)font {
    _font = font;
    self.textView.font = font;
    self.titleLabel.font = font;
    // Necessary for updating the placeholder font, if it's set
    if (self.textView.placeholder) {
        self.textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.textView.placeholder attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: self.defaultValueTextColor}];
    }
}

#pragma mark - Text View Delegate -


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:shouldBeginEditing:)]) {
        return [self.delegate textInputCell:self shouldBeginEditing:self.textView];
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:didBeginEditing:)]) {
        [self.delegate textInputCell:self didBeginEditing:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:textChanged:)]) {
        [self.delegate textInputCell:self textChanged:textView.text];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewCell:didEndEditingWithText:)]) {
        [self.delegate textViewCell:self didEndEditingWithText:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [textView scrollToCursorIfNecessaryForReplacementText:text];
    return YES;
}

@end
