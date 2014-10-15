//
//  NSError+MUValidation.h
//  MeetupApp
//
//  Created by Wes on 8/17/13.
//
//

#import <Foundation/Foundation.h>

/** A default error message title for display. */
extern NSString *const MUValidationDefaultTitleKey;


@interface NSError (MUValidation)

/**
 Combines the receiver and another error into an `NSValidationMultipleErrorsError`.
 
 @param error An error to be combined with the receiver.
 */
- (NSError *)mu_errorByCombiningWithError:(NSError *)error;

/**
 Creates a displayable error message with the given validationMessage
 
 @param validationMessage message to display
 @param code error code associated with the message
 */
+ (NSError *)errorWithValidationMessage:(NSString *)validationMessage code:(NSInteger)code;

/**
  Creates a displayable error message with the given validationMessage and saves underlying error
 
 @param validationMessage message to display
 */
- (NSError *)errorWithValidationMessage:(NSString *)validationMessage;

/**
  Title to display when showing error and error message
 
 */
- (NSString *)localizedValidationErrorTitle;

@end
