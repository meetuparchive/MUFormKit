//
//  MUFormDynamicHeightCell.m
//  MeetupApp
//
//  Created by Alistair on 8/19/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import "MUFormDynamicHeightCell.h"

@implementation MUFormDynamicHeightCell

+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info
{
    NSString *cellIdentifierAndNibName = NSStringFromClass(self);
    MUFormDynamicHeightCell *cell = (MUFormDynamicHeightCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierAndNibName];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifierAndNibName owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        NSAssert(cell, @"Expected a cell created from class %@ Nib file %@",cellIdentifierAndNibName,cellIdentifierAndNibName);
    }
    
    [cell configureWithValue:value info:info];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        height += 1;
    }

    return height;
}

@end
