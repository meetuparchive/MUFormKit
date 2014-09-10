//
//  MUFormIconCell.h
//  MeetupApp
//
//  Created by Alistair on 11/14/13.
//  Copyright (c) 2013 Meetup, Inc. All rights reserved.
//

#import "MUFormDynamicHeightCell.h"

@interface MUFormIconCell : MUFormDynamicHeightCell

/** Constraint for the padding to the right of the iconView, exposed to be able to collapse the view */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewLabelLeadingHorizontalConstraint;

/** Constraint for the width of the iconView, exposed to be able to collapse the view */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewWidthConstraint;

/** Constraint for the height of the iconView, exposed to be able to collapse the view */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewHeightConstraint;

- (void)awakeFromNib NS_REQUIRES_SUPER;

@end
