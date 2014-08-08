//
//  MUFormNumberFieldCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 7/1/13.
//
//

#import "MUFormNumberFieldCell.h"

@interface MUFormNumberFieldCell ()

@property (nonatomic) NSUInteger maxCharacters;

@end

@implementation MUFormNumberFieldCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.numberField.delegate = self;
    [self.numberField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)dealloc {
    _numberField.delegate = nil;
}

- (BOOL)becomeFirstResponder
{
    return [self.numberField becomeFirstResponder];
}


- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        NSString *stringValue = [value isKindOfClass:[NSNumber class]] ? [value stringValue] : value;
        MUAssert([stringValue isKindOfClass:[NSString class]], @"Expected ‘value’ to be an NSString. It was: %@", [value class]);
        self.numberField.text = stringValue;
    }
    else {
        NSString *defaultValue = info[MUFormDefaultValueKey];
        self.numberField.placeholder = defaultValue;
    }
    
    NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
    self.maxCharacters = [info[MUFormMaximumCharactersKey] integerValue];
    
    NSArray *validationMessages = info[MUValidationMessagesKey];
    self.messageLabel.text = ([validationMessages count] > 0) ? validationMessages[0] : nil;
}

#pragma mark - Actions -


- (void)textFieldEditingChanged:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(numberFieldCell:numberChanged:)]) {
        [self.delegate numberFieldCell:self numberChanged:textField.text];
    }
}


#pragma mark - Text Field Delegate -


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:shouldBeginEditing:)]) {
        return [self.delegate textInputCell:self shouldBeginEditing:self.numberField];
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
    if ([self.delegate respondsToSelector:@selector(numberFieldCell:didEndEditingWithNumber:)]) {
        [self.delegate numberFieldCell:self didEndEditingWithNumber:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textInputCell:textInputViewShouldReturn:)]) {
        return [self.delegate textInputCell:self textInputViewShouldReturn:textField];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.maxCharacters) {
        NSString *proposedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return proposedText.length <= self.maxCharacters;
    }
    return YES;
}

@end
