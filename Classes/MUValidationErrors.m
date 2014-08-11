//
//  MUValidationErrors.m
//  MeetupApp
//
//  Created by Wes on 8/7/13.
//
//

#import "MUValidationErrors.h"

///If Core Data validation error key available use it here
#ifdef _COREDATADEFINES_H
#define MUValidationDetailedErrorsKey NSDetailedErrorsKey
#else
NSString * const MUValidationDetailedErrorsKey = @"MUValidationDetailedErrors";
#endif

NSString *const MUValidationMessagesKey = @"MUValidationMessages";

NSInteger ErrorCodeFromName(NSString *errorName)
{
    static NSDictionary *validationErrorCodes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validationErrorCodes =
        @{
            @"MUValidationDateTooSoonError"    : @(MUValidationDateTooSoonError),
            @"MUValidationDateTooLateError"    : @(MUValidationDateTooLateError),
            @"MUValidationStringTooShortError" : @(MUValidationStringTooShortError),
            @"MUValidationStringTooLongError"  : @(MUValidationStringTooLongError)
        };
    });
    
    NSNumber *errorNumber = validationErrorCodes[errorName];
    return [errorNumber integerValue];
}

NSArray *LocalizedValidationMessagesForError(NSError *error)
{
    NSMutableArray *validationMessages = nil;
    
    if (error) {
        
        validationMessages = [NSMutableArray arrayWithCapacity:1];
        
        if ([error code] == MUValidationMultipleErrorsError) {
            
            // Look for detailed errors.
            NSArray *allErrors = [error userInfo][MUValidationDetailedErrorsKey];
            
            [allErrors enumerateObjectsUsingBlock:^(NSError *detailError, NSUInteger idx, BOOL *stop) {
                [validationMessages addObject:[detailError localizedDescription]];
            }];
        }
        else {
            [validationMessages addObject:[error localizedDescription]];
        }
    }
    return [validationMessages copy];
}

NSError *LocalizedValidationErrorForError(NSError *error)
{
    NSString *errorLocalizedDescription = LocalizedErrorStringForError(error);
    NSError *localizedValidationError;
    if (errorLocalizedDescription) {
        NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey : errorLocalizedDescription,
            NSUnderlyingErrorKey : error
        };
        localizedValidationError = [NSError errorWithDomain:MUValidationErrorDomain code:[error code] userInfo:userInfo];
    }
    return localizedValidationError;
}

NSString *LocalizedErrorStringForError(NSError *error)
{
    NSMutableString *errorString = nil;
    NSArray *messages = LocalizedValidationMessagesForError(error);
    if ([messages count] > 0) {
        errorString = [NSMutableString string];
        NSUInteger count = [messages count];
        [messages enumerateObjectsUsingBlock:^(NSString *singleErrorMessage, NSUInteger idx, BOOL *stop) {
            if (idx < count) {
                [errorString appendFormat:@"- %@\n", singleErrorMessage];
            }
            else {
                [errorString appendFormat:@"- %@", singleErrorMessage];
            }
        }];
    }
    return errorString;
}

@implementation MUValidationErrors

+ (BOOL)validateString:(NSString *__autoreleasing *)string
             fieldName:(NSString *)fieldName
             minLength:(NSUInteger)minLength
             maxLength:(NSUInteger)maxLength
                 error:(NSError *__autoreleasing *)outError
{
    BOOL isValid = YES;
    NSString *message = nil;
    
    if (string && [*string length] < minLength) {
        isValid = NO;
        if (outError != NULL) {
            if (minLength > 1) {
                message = [NSString stringWithFormat:NSLocalizedString(@"%@ must be at least %@ characters.", nil), fieldName, @(minLength)];
            }
            else {
                message = [NSString stringWithFormat:NSLocalizedString(@"%@ is required", nil), fieldName];
            }
            
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : message };
            NSError *error = [NSError errorWithDomain:MUValidationErrorDomain code:MUValidationStringTooShortError userInfo:userInfo];
            *outError = [error mu_errorByCombiningWithError:*outError];
        }
    }
    else if (string && [*string length] > maxLength) {
        isValid = NO;
        if (outError != NULL) {
            message = [NSString stringWithFormat:NSLocalizedString(@"%@ cannot be more than %@ characters.", nil), fieldName, @(maxLength)];
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : message };
            NSError *error = [NSError errorWithDomain:MUValidationErrorDomain code:MUValidationStringTooLongError userInfo:userInfo];
            *outError = [error mu_errorByCombiningWithError:*outError];
        }
    }
    return isValid;
}

@end
