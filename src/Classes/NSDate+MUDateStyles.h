//
//  NSDate+MUDateStyles.h
//  MeetupApp
//
//  Created by Wesley Smith on 7/3/13.
//
//

#import <Foundation/Foundation.h>

/// @name Meetup Date Style Types
typedef NS_ENUM(NSInteger, MUDateStyleType) {
    
    /// (e.g. Sat Jul 13, 2013)
    MUDateStyleTypeAbbreviatedDate = 0,
    
    /// (e.g. Saturday, July 13 if it's this year; Saturday, July 13, 2014 if it's not this year)
    MUDateStyleTypeLongDate,

    /// (e.g. August 9)
    MUDateStyleTypeMonthDayDate,
    
    /// (e.g. Aug 9)
    MUDateStyleTypeAbbreviatedMonthDayDate,
    
    /// (e.g. Aug 9 if it's this year, but "Jan 12, 2015" if it's not)
    MUDateStyleTypeAbbreviatedMonthDayWithYearDate,
    
    /// (e.g. 7:00 PM)
    MUDateStyleTypeTime,
    
    /// (e.g. Friday, 7:00 PM)
    MUDateStyleTypeWeekDayWithTime,
    
    /// (e.g. Sat Jul 13, 2013 7:00 PM)
    MUDateStyleTypeAbbreviatedDateWithTime,

    /// (e.g. Friday, Nov 27)
    MUDateStyleTypeAbbreviatedMonthWithoutYear,
    
    /// (e.g. 7:00pm)
    MUDateStyleTypeTimeLowerCase,
    
    /// (e.g. January 2014)
    MUDateStyleTypeMonthYear,
};

@interface NSDate (MUDateStyles)

/** Returns a string representation of the receiver formatted to a specified style.
 
 @param  dateStyle  Indicates the style to be used to format the string.
 @param  timeZone   The time zone to print the date/time in.
 */
- (NSString *)stringWithStyle:(MUDateStyleType)dateStyle inTimeZone:(NSTimeZone *)timeZone;


/**
 If the date is "Yesterday", "Today", or "Tomorrow" (or "Antes de ayer" in Spanish, etc.),
 uses the relative date. Otherwise, uses the dateStyle specified.
 
 Either way, append " at 7:00pm" if hasTime is YES.
 
 @param dateStyle   Indicates the style to be used to format the fallback string.
 @param hasTime     Should the relative and fallback strings have a time appended?
 @param timeZone    The time zone to print the date/time in.
 */
- (NSString *)relativeDateOrStringWithStyle:(MUDateStyleType)dateStyle withTime:(BOOL)hasTime inTimeZone:(NSTimeZone *)timeZone;


/// Returns a string describing the date, relative to now. (e.g. "yesterday", or "3 minutes from now", or "a year ago".)
- (NSString *)relativeDateString;

/// Returns the result of -[relativeDateString] if the time is within `components` of now, and returns the results of -[stringWithStyle:inTimeZone:] otherwise.
- (NSString *)relativeDateStringIfCloserThan:(NSDateComponents *)components orDateWithStyle:(MUDateStyleType)type inTimeZone:(NSTimeZone *)timeZone;

@end
