//
//  MUFormIconCell.m
//  MeetupApp
//
//  Created by Alistair on 11/14/13.
//  Copyright (c) 2013 Meetup, Inc. All rights reserved.
//

#import "MUFormIconCell.h"

@interface MUFormIconCell ()
/// Constraint between the icon and the superview (for setting separator insets)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewSuperviewHorizontalConstraint;

@property (nonatomic) CGFloat iconViewLabelLeadingHorizontalConstraintConstant;
@property (nonatomic) CGFloat iconViewWidthConstant;
@property (nonatomic) CGFloat iconViewHeightConstant;
@end

@implementation MUFormIconCell

- (void)setFont:(UIFont *)font {
    _font = font;
    self.staticLabel.font = font;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.iconViewLabelLeadingHorizontalConstraintConstant = self.iconViewLabelLeadingHorizontalConstraint.constant;
    self.iconViewWidthConstant = self.iconViewWidthConstraint.constant;
    self.iconViewHeightConstant = self.iconViewHeightConstraint.constant;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.iconView.image = nil;
    [self.iconView setMeetupUrl:nil];
    self.iconViewLabelLeadingHorizontalConstraint.constant = 0.0;
    self.iconViewWidthConstraint.constant = 0.0;
    self.iconViewHeightConstraint.constant = 0.0;    
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    NSString *iconName = info[MUFormCellIconNameKey];
    NSString *iconURLString = info[MUFormCellIconURLStringKey];
    if ([value isKindOfClass:[UIImage class]]) {
        self.iconView.image = value;
        self.iconViewLabelLeadingHorizontalConstraint.constant = self.iconViewLabelLeadingHorizontalConstraintConstant;
        self.iconViewWidthConstraint.constant = self.iconViewWidthConstant;
        self.iconViewHeightConstraint.constant = self.iconViewHeightConstant;
    }
    else if ([iconURLString length] > 0) {
        UIImage *placeholder = ([iconName length] > 0) ? [UIImage imageNamed:iconName] : nil;
        [self.iconView setMeetupUrl:[NSURL URLWithString:iconURLString] placeHolderImage:placeholder];
        self.iconViewLabelLeadingHorizontalConstraint.constant = self.iconViewLabelLeadingHorizontalConstraintConstant;
        self.iconViewWidthConstraint.constant = self.iconViewWidthConstant;
        self.iconViewHeightConstraint.constant = self.iconViewHeightConstant;
    }
    else if ([iconName length] > 0) {
        self.iconView.image = [UIImage imageNamed:iconName];
        self.iconViewLabelLeadingHorizontalConstraint.constant = self.iconViewLabelLeadingHorizontalConstraintConstant;
        self.iconViewWidthConstraint.constant = self.iconViewWidthConstant;
        self.iconViewHeightConstraint.constant = self.iconViewHeightConstant;
    }
    else {
        self.iconView.image = nil;
        [self.iconView setMeetupUrl:nil];
        self.iconViewLabelLeadingHorizontalConstraint.constant = 0.0;
        self.iconViewWidthConstraint.constant = 0.0;
        self.iconViewHeightConstraint.constant = 0.0;
    }

    CGFloat leftInset = self.iconViewSuperviewHorizontalConstraint.constant + self.iconViewWidthConstraint.constant + self.iconViewLabelLeadingHorizontalConstraint.constant;
    [self setSeparatorInset:UIEdgeInsetsMake(0.0f, leftInset, 0.0f, 0.0f)];
    
    NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
}

@end
