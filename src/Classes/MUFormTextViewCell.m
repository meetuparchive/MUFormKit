//
//  MUFormTextViewCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import "MUFormTextViewCell.h"
#import "UITextView+ReturnBugFix.h"

static CGFloat kMUCellHeight = 120.0;
static CGFloat kMUErrorLabelHeight = 20.0;

@implementation MUFormTextViewCell

#pragma mark - Overrides -


+ (CGFloat)heightForValue:(id)value info:(NSDictionary *)info
{
    CGFloat height = kMUCellHeight;
    if (info[MUValidationMessagesKey]) {
        height += kMUErrorLabelHeight;
    }
    return height;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.delegate = self;
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
        NSAssert([value isKindOfClass:[NSString class]], @"Expected ‘value’ to be an NSString. It was: %@", [value class]);
        self.textView.text = value;
    }
    else if (info[MUFormLocalizedDefaultValueKey]) {
        NSDictionary *attributes = @{
                       NSFontAttributeName: self.textView.font,
            NSForegroundColorAttributeName: self.defaultValueTextColor
        };
        
        NSString *localizedKey = info[MUFormLocalizedDefaultValueKey];
        NSString *localizedString = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];

//        self.textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:localizedString
//                                                                              attributes:attributes];
    }
    
    NSArray *validationMessages = info[MUValidationMessagesKey];
    if ([validationMessages count] > 0) {
        self.messageLabel.text = validationMessages[0];
        self.messageLabel.hidden = NO;
    }
    else {
        self.messageLabel.hidden = YES;
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
