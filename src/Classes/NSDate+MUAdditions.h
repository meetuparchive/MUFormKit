//
//  NSDate+MUAdditions.h
//  MeetupApp
//
//  Created by Wesley Smith on 7/3/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (MUAdditions)

- (BOOL)isBefore:(NSDate *)date;
- (BOOL)isAfter:(NSDate *)date;

- (BOOL)isBeforeNow;
- (BOOL)isAfterNow;

- (BOOL)isCurrentYearInTimeZone:(NSTimeZone *)timeZone;

/**
 Returns the number of days between the receiver and another date in the specified time zone.
 
 For instance, if the two (NSDate *)s were 11:59 PM tonight and 12:01 AM tomorrow morning, this will return 1.
 
 @param startDate   The start date for the time interval in question.
 @param endDate     The end date for the time interval in question.
 @param timeZone    The time zone to compare in.
 
 @return an `NSInteger` indicating the number of days.
 */
+ (NSInteger)daysBetween:(NSDate *)startDate and:(NSDate *)endDate inTimeZone:(NSTimeZone *)timeZone;

/**
 Returns an `NSDateComponents` instance representing the delta between the receiver and another date.
 
 This method returns the difference in day, hour and minute components.
 
 @param startDate   The start date for the time interval in question.
 @param endDate     The end date for the time interval in question.
 */
+ (NSDateComponents *)daysAndTimeBetween:(NSDate *)startDate and:(NSDate *)endDate;


/// Returns a new date with the same day as the receiver–time set to midnight in the specified time zone.
- (instancetype)beginningOfDayInTimeZone:(NSTimeZone *)timeZone;

/**
 Merges the time from another date with the receiver.
 
 @param time A date object whose time should be merged with the receiver's day.
 @param timeZone The time zone to use when merging the dates.
 */
- (instancetype)dateWithTimeFromDate:(NSDate *)time timeZone:(NSTimeZone *)timeZone;

/**
 Returns a date days/hours in the future. Just adds (24*days+hours) hours to the receiver.
 
 @param  days   The number of days to add to the receiver.
 @param  hours  The number of hours to add to the receiver.
 */
- (instancetype)dateByAddingDays:(NSInteger)days hours:(NSInteger)hours;

/// Returns a new date adding the number of years specified.
- (instancetype)dateByAddingYears:(NSInteger)years;

/**
 Returns a new GMT date from the date components of the original, as calculated by a calendar with the passed time zone)
 
 For example: If the receiver is 4/26/2013 at 3:15:34 PM in the passed timeZone, this will return the NSDate that represents 4/26/2013 at 3:15:34 PM in GMT.
 */
- (instancetype)dateInGMTFromDateInTimeZone:(NSTimeZone *)timeZone;

/**
 Returns a new date from the passed in NSTimeInterval in milliseconds
 
 */
+ (instancetype)dateWithMillisecondsSince1970:(NSTimeInterval)millisecondsSinceEpoch;

@end
