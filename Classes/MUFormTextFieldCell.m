//
//  MUFormTextFieldCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import "MUFormTextFieldCell.h"

@implementation MUFormTextFieldCell

#pragma mark - Overrides -

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.label.text = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyNext;
    [self.textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)dealloc {
    _textField.delegate = nil;
}
    
- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textField.text = nil;
    self.label.text = nil;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    NSString *placeholderKey = info[MUFormLocalizedDefaultValueKey];
    self.textField.placeholder = [[NSBundle mainBundle] localizedStringForKey:placeholderKey value:placeholderKey table:MUFormKitStringTable];
    if (info[MUFormLocalizedAccessibilityLabelKey]) {
        self.textField.accessibilityLabel = [[NSBundle mainBundle] localizedStringForKey:info[MUFormLocalizedAccessibilityLabelKey]
                                                                                   value:info[MUFormLocalizedAccessibilityLabelKey]
                                                                                   table:MUFormKitStringTable];
    }

    NSNumber *autoCorrectType = info[MUFormUITextAutocorrectionTypeKey];
    if (autoCorrectType ) {
        self.textField.autocorrectionType = [autoCorrectType integerValue];
    } else {
        self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    }
    
    NSNumber *keyboardType = info[MUFormUIKeyboardTypeKey];
    if (keyboardType) {
        self.textField.keyboardType = [keyboardType integerValue];
    } else {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
    
    NSNumber *returnKeyType = info[MUFormUIReturnKeyTypeKey];
    if (returnKeyType) {
        self.textField.returnKeyType = (UIReturnKeyType)[returnKeyType integerValue];
    }
    
    NSNumber *capitalizationType = info[MUFormUITextAutocapitalizationTypeKey];
    if (capitalizationType) {
        self.textField.autocapitalizationType = [capitalizationType integerValue];
    } else {
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    
    NSNumber *secureTextEntry = info[MUFormCellSecureTextEntryEnabledKey];
    self.textField.secureTextEntry = [secureTextEntry boolValue];
    
    if (value) {
        MUAssert([value isKindOfClass:[NSString class]], @"Expected ‘value’ to be an NSString. It was: %@", [value class]);
        self.textField.text = value;
    }
    
    NSString *formLabelKey = info[MUFormLocalizedLabelKey];
    self.label.text = [[NSBundle mainBundle] localizedStringForKey:formLabelKey value:formLabelKey table:MUFormKitStringTable];

    NSArray *validationMessages = info[MUValidationMessagesKey];
    self.messageLabel.text = [validationMessages firstObject];
}

-(NSString*) textFieldText
{
    return self.textField.text;
}

#pragma mark - Actions -


- (void)textFieldEditingChanged:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:textChanged:)]) {
        [self.delegate textInputCell:self textChanged:[self textFieldText]];
    }
}


#pragma mark - Text Field Delegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:shouldBeginEditing:)]) {
        return [self.delegate textInputCell:self shouldBeginEditing:self.textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:didBeginEditing:)]) {
        [self.delegate textInputCell:self didBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldCell:didEndEditingWithText:)]) {
        [self.delegate textFieldCell:self didEndEditingWithText:[self textFieldText]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:textInputViewShouldReturn:)]) {
        return [self.delegate textInputCell:self textInputViewShouldReturn:textField];
    }
    return NO;
}

@end
