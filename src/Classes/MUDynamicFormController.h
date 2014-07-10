//
//  MUDynamicFormController.h
//  MeetupApp
//
//  Created by Alistair on 1/13/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import "MUFormController.h"
#import "MUDynamicFormDataSource.h"

@interface MUDynamicFormController : MUFormController

@property (nonatomic, strong) MUDynamicFormDataSource *dataSource;

@end
