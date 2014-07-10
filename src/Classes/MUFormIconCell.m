//
//  MUFormIconCell.m
//  MeetupApp
//
//  Created by Alistair on 11/14/13.
//  Copyright (c) 2013 Meetup, Inc. All rights reserved.
//

#import "MUFormIconCell.h"

@interface MUFormIconCell ()
@property (nonatomic) CGFloat iconViewLabelLeadingHorizontalConstraintConstant;
@property (nonatomic) CGFloat iconViewWidthConstant;
@property (nonatomic) CGFloat iconViewHeightConstant;
@end

@implementation MUFormIconCell

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
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    NSString *iconName = info[MUFormCellIconNameKey];   
    if ([iconName length] > 0) {
        self.iconView.image = [UIImage imageNamed:iconName];
        self.iconViewLabelLeadingHorizontalConstraint.constant = self.iconViewLabelLeadingHorizontalConstraintConstant;
        self.iconViewWidthConstraint.constant = self.iconViewWidthConstant;
        self.iconViewHeightConstraint.constant = self.iconViewHeightConstant;
    }
    else {
        self.iconView.image = nil;
        self.iconViewLabelLeadingHorizontalConstraint.constant = 0.0;
        self.iconViewWidthConstraint.constant = 0.0;
        self.iconViewHeightConstraint.constant = 0.0;
    }

}

@end
