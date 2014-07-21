//
//  MUResizeableCellsController.m
//  FormKit
//
//  Created by Alistair on 7/21/14.
//  Copyright (c) 2014 Meetup. All rights reserved.
//

#import "MUResizeableCellsController.h"

@interface MUResizeableCellsController ()
@property (nonatomic) BOOL didFlipText;
@property (nonatomic) NSString *resizeableTextString;
@end

@implementation MUResizeableCellsController

#pragma mark - MUFormController Overrides

-(MUFormDataSource*) dataSource {
    MUFormDataSource *dataSource = [super dataSource];
    if (!dataSource) {
        NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"MUResizeableCellsController" ofType:@"json"];
        dataSource = [[MUFormDataSource alloc] initWithModel:self JSONFilePath:jsonFilePath];
        [self setDataSource:dataSource];
    }
    return dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resizeableTextString = [self generateResizeableTextString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rowInfo = [self.dataSource rowInfoForItemAtIndexPath:indexPath];
    NSString *actionIdentifier = rowInfo[MUFormTapActionIdentifierKey];

    if ([actionIdentifier isEqualToString:@"info-label-1"]) {
        self.resizeableTextString = [self generateResizeableTextString];
        [self.tableView reloadData];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Datasource

-(NSString*) generateResizeableTextString {
    NSString *resizeableTextString;
    if(self.didFlipText) {
        resizeableTextString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
    } else {
        resizeableTextString = @"One line of text";
    }
    self.didFlipText = !self.didFlipText;
    return resizeableTextString;
}

@end
