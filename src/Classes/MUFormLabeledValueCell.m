//
//  MUFormLabeledValueCell.m
//  MeetupApp
//
//  Created by Eugene Yee on 6/30/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import "MUFormLabeledValueCell.h"
#import "MUFormConstants.h"

CGFloat const MUFormAttributedTextCellHeight = 48.0f;

@interface MUFormLabeledValueCell()
@property (nonatomic, strong) IBOutlet UILabel *cellLeftLabel;
@property (nonatomic, strong) IBOutlet UILabel *cellRightLabel;
@end

@implementation MUFormLabeledValueCell

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    self.cellLeftLabel.text = [[NSBundle mainBundle] localizedStringForKey:info[MUFormLocalizedStaticTextKey] value:info[MUFormLocalizedStaticTextKey] table:MUFormKitStringTable];
    if ([value isNotEmptyString]) {
        self.cellRightLabel.textColor = [UIColor blackColor];
        self.cellRightLabel.text = value;
    }
    else {
        self.cellRightLabel.textColor = [UIColor darkGrayColor];
        self.cellRightLabel.text = [[NSBundle mainBundle] localizedStringForKey:info[MUFormLocalizedDefaultValueKey] value:info[MUFormLocalizedDefaultValueKey] table:MUFormKitStringTable];
    }

    if (info[MUFormCellLocalizedAccessibilityHintKey]) {
        self.accessibilityHint = [[NSBundle mainBundle] localizedStringForKey:info[MUFormCellLocalizedAccessibilityHintKey] value:info[MUFormCellLocalizedAccessibilityHintKey] table:MUFormKitStringTable];
    }

    self.cellAttributes = info[MUFormCellAttributeValuesKey];

    [super configureWithValue:value info:info];
}

- (NSString *)accessibilityLabel {
    return [NSString stringWithFormat:@"%@ %@", self.cellLeftLabel.text, self.cellRightLabel.text];
}

@end
