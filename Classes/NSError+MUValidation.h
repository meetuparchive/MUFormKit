//
//  NSError+MUValidation.h
//  MeetupApp
//
//  Created by Wes on 8/17/13.
//
//

#import <Foundation/Foundation.h>

@interface NSError (MUValidation)

/**
 Combines the receiver and another error into an `NSValidationMultipleErrorsError`.
 
 @param error An error to be combined with the receiver.
 */
- (NSError *)mu_errorByCombiningWithError:(NSError *)error;

@end
