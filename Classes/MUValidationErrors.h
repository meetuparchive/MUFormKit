//
//  MUValidationErrors.h
//  MeetupApp
//
//  Created by Wes on 8/7/13.
//
//
#import <Foundation/Foundation.h>

/** @name Validation Constants */

/** The Validation Error Domain */
extern NSString *const MUValidationErrorDomain;

/** If multiple validation errors occur in one operation, they are collected in an array and added with this key to the "top-level error" of the operation. */
extern NSString *const MUValidationDetailedErrorsKey;

/** An array of user friendly, localized validation strings. */
extern NSString *const MUValidationMessagesKey;


/** @name Validation Error Codes */

// When adding to this enum, remember to update `ErrorCodeFromName()`.
#ifdef _COREDATADEFINES_H
#import "CoreData/CoreDataErrors.h"

typedef NS_ENUM(NSInteger, MUValidationErrorType) {
    MUValidationUnknownError        = 0,
    MUValidationMultipleErrorsError = NSValidationMultipleErrorsError,
    MUValidationDateTooSoonError    = NSValidationDateTooSoonError,
    MUValidationDateTooLateError    = NSValidationDateTooLateError,
    MUValidationStringTooShortError = NSValidationStringTooShortError,
    MUValidationStringTooLongError  = NSValidationStringTooLongError,
    MUValidationNumberTooLargeError = NSValidationNumberTooLargeError,
    MUValidationNumberTooSmallError = NSValidationNumberTooSmallError,
    MUValidationStringPatternMatchingError = NSValidationStringPatternMatchingError
    
};
#else

typedef NS_ENUM(NSInteger, MUValidationErrorType) {
    MUValidationUnknownError        = 0,
    MUValidationMultipleErrorsError = 1200,
    MUValidationDateTooSoonError    = 1210,
    MUValidationDateTooLateError    = 1220,
    MUValidationStringTooShortError = 1230,
    MUValidationStringTooLongError  = 1240,
    MUValidationNumberTooLargeError = 1250,
    MUValidationNumberTooSmallError = 1260,
    MUValidationStringPatternMatchingError = 1270
};

#endif

///-----------------------------
/// @name Error Helper Functions
///-----------------------------

/**
 Returns the error code for a given error name.
 
 @param errorName The name of the error code (e.g. ‘MUValidationDateTooSoonError’).
 */
NSInteger ErrorCodeFromName(NSString *errorName);

/**
 Interrogates an error and any detailed errors it may contain and assembles an array of localized descriptions.
 
 @param error An error object to be interrogated.
 
 @return An array of localized error descriptions.
 */
NSArray *LocalizedValidationMessagesForError(NSError *error);

/**
 Assembles a displayable string of error messages from an error object.
 
 @param error An error object.
 
 @return A string of localized error descriptions in a displayable format.
 */
NSString *LocalizedErrorStringForError(NSError *error);

/**
 Assembles a displayable validation error an error object.
 
 @param error An error object.
 
 @return A error in a displayable format, if no displayable errors or passed in error is nil, returned error will be nil
 */
NSError *LocalizedValidationErrorForError(NSError *error);

@interface MUValidationErrors : NSObject

/**
 A helper to the KVC validation used when validating FormKit string values.
 
 @param string The string to be validated.
 @param fieldName A user friendly name of the field being validated. This will be used in the error.
 @param minLength The minimum length of the string for it to be valid (pass 0 to allow empty string).
 @param maxLength The maximum length of the string for it to be valid (pass NSUIntegerMax to ignore).
 @param outError A pointer to an error which will be set if the string is not valid.
 */
+ (BOOL)validateString:(NSString *__autoreleasing *)string
             fieldName:(NSString *)fieldName
             minLength:(NSUInteger)minLength
             maxLength:(NSUInteger)maxLength
                 error:(NSError *__autoreleasing *)outError;

@end

