//
//  NSError+MUValidation.m
//  MeetupApp
//
//  Created by Wes on 8/17/13.
//
//

#import "NSError+MUValidation.h"
#import "MUValidationErrors.h"

/** A default error message title for display. */
NSString *const MUValidationDefaultTitleKey = @"MUValidationDefaultTitleKey";


@implementation NSError (MUValidation)

- (NSError *)mu_errorByCombiningWithError:(NSError *)error
{
    if (error == nil) {
        return self;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSMutableArray *errors = [NSMutableArray arrayWithObject:self];
    
    if ([error code] == MUValidationMultipleErrorsError) {
        
        [userInfo addEntriesFromDictionary:[error userInfo]];
        [errors addObjectsFromArray:userInfo[MUValidationDetailedErrorsKey]];
    }
    else {
        [errors addObject:error];
    }
    
    [userInfo setObject:errors forKey:MUValidationDetailedErrorsKey];
    
    return [NSError errorWithDomain:MUValidationErrorDomain
                               code:MUValidationMultipleErrorsError
                           userInfo:userInfo];
}

+ (NSError *)errorWithValidationMessage:(NSString *)validationMessage code:(NSInteger)code
{
    NSDictionary *userInfo = @{
        MUValidationDefaultTitleKey : NSLocalizedString(@"Oops! You missed something.", nil),
        NSLocalizedDescriptionKey : validationMessage,
    };
    return [NSError errorWithDomain:MUValidationErrorDomain code:code userInfo:userInfo];
}

- (NSError *)errorWithValidationMessage:(NSString *)validationMessage
{
    NSDictionary *userInfo = @{
        MUValidationDefaultTitleKey : NSLocalizedString(@"Oops! You missed something.", nil),
        NSLocalizedDescriptionKey : validationMessage,
        NSUnderlyingErrorKey : self
    };
    return [NSError errorWithDomain:MUValidationErrorDomain code:MUValidationMultipleErrorsError userInfo:userInfo];
}

- (NSString *)localizedValidationErrorTitle {
    return [[self userInfo][MUValidationDefaultTitleKey] copy];
}

@end
