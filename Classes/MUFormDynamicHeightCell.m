//
//  MUFormDynamicHeightCell.m
//  MeetupApp
//
//  Created by Alistair on 8/19/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import "MUFormDynamicHeightCell.h"

@implementation MUFormDynamicHeightCell

static BOOL isiOS8 = NO;
+(void) initialize
{
    isiOS8 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8");
}

+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info
{
    if (isiOS8) {
        return UITableViewAutomaticDimension;
    }

    NSString *cellNibName = info[MUFormCellClassKey];
    NSString *cellIdentifier = info[MUFormCellIdentifierKey];
    MUFormDynamicHeightCell *cell = (MUFormDynamicHeightCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        NSAssert(cell, @"Expected a cell created from identifier %@ Nib file %@",cellIdentifier,cellNibName);
    }
    
    [cell configureWithValue:value info:info];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        //Leave room for separators on the top and bottom of this cell
        height += 2.0f/[UIScreen mainScreen].scale;
    }

    return height;
}

@end
