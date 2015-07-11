//
//  MUFormLabeledValueCell.h
//  MeetupApp
//
//  Created by Eugene Yee on 6/30/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUFormBaseCell.h"

extern CGFloat const MUFormAttributedTextCellHeight;

@interface MUFormLabeledValueCell : MUFormBaseCell

@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;

@end
