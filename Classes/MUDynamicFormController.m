//
//  MUDynamicFormController.m
//  MeetupApp
//
//  Created by Alistair on 1/13/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import "MUDynamicFormController.h"
#import "MUDynamicFormDataSource.h"

@interface MUDynamicFormController ()


@end

@implementation MUDynamicFormController

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource rowTypeForRowAtIndexPath:indexPath] == MUDynamicRowTypeAddNewItem) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.dataSource tableView:tableView didAddItemAtIndexPath:indexPath];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *questions = (NSArray *)[self.dataSource arrayPropertyValueForSection:indexPath.section];
    if (questions && [self.dataSource rowTypeForRowAtIndexPath:indexPath] == MUDynamicRowTypeDefault) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


@end
