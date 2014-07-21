//
//  MUViewController.m
//  FormKit
//
//  Created by Wes on 7/3/14.
//  Copyright (c) 2014 Meetup. All rights reserved.
//

#import "MUHomeViewController.h"
#import "MUFormDataSource.h"
#import "MUResizeableCellsController.h"

@interface MUHomeViewController ()

@end

@implementation MUHomeViewController

-(MUFormDataSource*) dataSource {
    MUFormDataSource *dataSource = [super dataSource];
    if (!dataSource) {
        NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"MUHomeViewController" ofType:@"json"];
        dataSource = [[MUFormDataSource alloc] initWithModel:self JSONFilePath:jsonFilePath];
        [self setDataSource:dataSource];
    }
    return dataSource;
}

@end
