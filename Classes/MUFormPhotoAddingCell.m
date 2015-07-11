//
//  MUFormPhotoAddingCell.m
//  MeetupApp
//
//  Created by Phil Tang on 11/12/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import "MUFormPhotoAddingCell.h"

@implementation MUFormPhotoAddingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = CGRectGetWidth(self.iconView.frame) / 2.0f;
}

- (void)photoAddingController:(MUPhotoAddingController *)photoAddingController didPickImage:(UIImage *)image {
    self.iconView.image = image;
    if ([self.delegate respondsToSelector:@selector(photoAddingCell:didPickImage:)]) {
        [self.delegate photoAddingCell:self didPickImage:image];
    }
}

@end
