//
//  NSDate+MUDateStyles.m
//  MeetupApp
//
//  Created by Wesley Smith on 7/3/13.
//
//

#import "NSDate+MUDateStyles.h"
#import "TTTTimeIntervalFormatter.h"

@implementation NSDate (MUDateStyles)

#pragma mark - Fixed-style Date Strings -

// We're storing a dictionary of date formatters for time zones because of the performance
// characteristics of NSDateFormatter. For a mean of 5 runs on January 13, 2014 on an iPhone 5s:
//
// 660 * (time to change format) = 12 * (time to change time zone) = time to create formatter
+ (NSDateFormatter *)dateFormatterForTimeZone:(NSTimeZone *)timeZone
{
    NSParameterAssert(timeZone);
    static NSMutableDictionary *dateFormattersByTimeZone = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSRange hoursInDay = [[NSCalendar currentCalendar] maximumRangeOfUnit:NSCalendarUnitHour];
        dateFormattersByTimeZone = [NSMutableDictionary dictionaryWithCapacity:hoursInDay.length];
    });
    
    NSDateFormatter *formatterFromDictionary = dateFormattersByTimeZone[[timeZone name]];
    if (formatterFromDictionary) {
        return formatterFromDictionary;
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:timeZone];
        
        dateFormattersByTimeZone[[timeZone name]] = formatter;
        return formatter;
    }
}

- (NSString *)stringWithDateFormatTemplate:(NSString *)dateFormatTemplate inTimeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *formatter = [[self class] dateFormatterForTimeZone:timeZone];
    [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:dateFormatTemplate
                                                             options:0
                                                              locale:[NSLocale autoupdatingCurrentLocale]]];
    return [formatter stringFromDate:self];
}

- (NSString *)dateFormatTemplate:(NSString *)template appendingYearIfNotThisYearInTimeZone:(NSTimeZone *)timeZone {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // Performance optimization, because setting a calendar's time zone is SLOW and checking it is fast
    if (calendar.timeZone != timeZone) {
        calendar.timeZone = timeZone;
    }
    
    NSInteger currentYear = [[calendar components:NSCalendarUnitYear fromDate:[NSDate date]] year];
    NSInteger    selfYear = [[calendar components:NSCalendarUnitYear fromDate:self         ] year];

    if (selfYear == currentYear){
        return template;
    }
    else return [template stringByAppendingString:@"yyyy"];
}

- (NSString *)stringWithStyle:(MUDateStyleType)dateStyle inTimeZone:(NSTimeZone *)timeZone
{
    NSParameterAssert(timeZone);
    if (!timeZone) timeZone = [NSTimeZone localTimeZone];
    
    NSString *dateString = nil;
    
    switch (dateStyle) {
        case MUDateStyleTypeAbbreviatedDate:
            dateString = [self stringWithDateFormatTemplate:@"EEEMMMdyyyy" inTimeZone:timeZone];
            break;
        case MUDateStyleTypeLongDate: {
            NSString *template = [self dateFormatTemplate:@"EEEEMMMd"
                     appendingYearIfNotThisYearInTimeZone:timeZone];
            dateString = [self stringWithDateFormatTemplate:template inTimeZone:timeZone];
            break;
        }
        case MUDateStyleTypeMonthDayDate:
            dateString = [self stringWithDateFormatTemplate:@"MMMMd" inTimeZone:timeZone];
            break;
        case MUDateStyleTypeAbbreviatedMonthDayDate:
            dateString = [self stringWithDateFormatTemplate:@"MMMd" inTimeZone:timeZone];
            break;
        case MUDateStyleTypeAbbreviatedMonthDayWithYearDate: {
            NSString *template = [self dateFormatTemplate:@"MMMd"
                     appendingYearIfNotThisYearInTimeZone:timeZone];
            dateString = [self stringWithDateFormatTemplate:template inTimeZone:timeZone];
            break;
        }
        case MUDateStyleTypeTime:
            dateString = [self stringWithDateFormatTemplate:@"jmm" inTimeZone:timeZone];
            break;
        case MUDateStyleTypeWeekDayWithTime:
            dateString = [self stringWithDateFormatTemplate:@"EEEEjmm" inTimeZone:timeZone];
            break;
        case MUDateStyleTypeAbbreviatedDateWithTime:
            dateString = [self stringWithDateFormatTemplate:@"EEEMMMdyyyyjmm" inTimeZone:timeZone];
            break;
        case MUDateStyleTypeAbbreviatedMonthWithoutYear:
            dateString = [self stringWithDateFormatTemplate:@"EEEEMMMd" inTimeZone:timeZone];
            break;
        case MUDateStyleTypeTimeLowerCase:
            dateString = [self stringWithDateFormatTemplate:@"jmm" inTimeZone:timeZone];
            dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
            dateString = [dateString lowercaseStringWithLocale:[NSLocale currentLocale]];
            break;
        case MUDateStyleTypeMonthYear:
            dateString = [self stringWithDateFormatTemplate:@"MMMMyyyy" inTimeZone:timeZone];
            break;
        default:
            NSAssert(NO, @"You must speciify a valid ‘dateStyle’.");
            break;
    }
    
    return dateString;
}


#pragma mark - Relative Date Strings -

- (NSString *)relativeDateOrStringWithStyle:(MUDateStyleType)dateStyle withTime:(BOOL)hasTime inTimeZone:(NSTimeZone *)timeZone
{
    NSParameterAssert(timeZone);
    if (!timeZone) timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateFormatter *formatter = [[self class] dateFormatterForTimeZone:timeZone];
    BOOL didRelativeFormatting = [formatter doesRelativeDateFormatting];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    NSString *relativeFormattedDate = [formatter stringFromDate:self];

    [formatter setDoesRelativeDateFormatting:NO];
    NSString *nonRelativeFormattedDate = [formatter stringFromDate:self];

    [formatter setDoesRelativeDateFormatting:didRelativeFormatting];
    
    if ([relativeFormattedDate isEqualToString:nonRelativeFormattedDate]) {
        if (hasTime) {
            return [NSString stringWithFormat:NSLocalizedString(@"%@ at %@", @"<date> at <time>"),
                    [self stringWithStyle:dateStyle inTimeZone:timeZone],
                    [self stringWithStyle:MUDateStyleTypeTimeLowerCase inTimeZone:timeZone]];
        }
        else return [self stringWithStyle:dateStyle inTimeZone:timeZone];
    }
    else if (hasTime) {
        return [NSString stringWithFormat:NSLocalizedString(@"%@ at %@", @"<date> at <time>"),
                relativeFormattedDate,
                [self stringWithStyle:MUDateStyleTypeTimeLowerCase inTimeZone:timeZone]];
    }
    else return relativeFormattedDate;

}

- (NSString *)relativeDateString {
    static TTTTimeIntervalFormatter *timeIntervalFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        [timeIntervalFormatter setPresentTimeIntervalMargin:60];
        [timeIntervalFormatter setUsesIdiomaticDeicticExpressions:YES];
        [timeIntervalFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    });
    
    NSTimeInterval intervalSinceNow = [self timeIntervalSinceNow];
    return [timeIntervalFormatter stringForTimeInterval:intervalSinceNow];
}

- (NSString *)relativeDateStringIfCloserThan:(NSDateComponents *)components orDateWithStyle:(MUDateStyleType)type inTimeZone:(NSTimeZone *)timeZone {

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    if (fabs([date timeIntervalSinceNow]) > fabs([self timeIntervalSinceNow])) {
        return [self relativeDateString];
    }
    else return [self stringWithStyle:type inTimeZone:timeZone];
}


#pragma mark - Debug -

- (NSString *)debugDescription {
    return [self stringWithStyle:MUDateStyleTypeAbbreviatedDateWithTime inTimeZone:[NSTimeZone defaultTimeZone]];
}

@end
