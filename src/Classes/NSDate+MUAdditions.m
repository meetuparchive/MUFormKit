//
//  NSDate+MUAdditions.m
//  MeetupApp
//
//  Created by Wesley Smith on 7/3/13.
//
//


@implementation NSDate (MUAdditions)

- (BOOL)isBefore:(NSDate *)date {
    NSParameterAssert(date);
    return ([self compare:date] == NSOrderedAscending);
}
- (BOOL)isAfter:(NSDate *)date {
    NSParameterAssert(date);
    return ([self compare:date] == NSOrderedDescending);
}
- (BOOL)isBeforeNow {
    return ([self timeIntervalSinceNow] < 0.0);
}
- (BOOL)isAfterNow {
    return ([self timeIntervalSinceNow] > 0.0);
}

- (BOOL)isCurrentYearInTimeZone:(NSTimeZone *)timeZone {
    NSParameterAssert(timeZone);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    
	NSDateComponents    *selfYear = [calendar components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *currentYear = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    return (selfYear.year == currentYear.year);
}

+ (NSInteger)daysBetween:(NSDate *)startDate and:(NSDate *)endDate inTimeZone:(NSTimeZone *)timeZone {
    NSParameterAssert(startDate && endDate && timeZone);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    
    NSDate *beginningOfStartDay = [startDate beginningOfDayInTimeZone:timeZone];
    NSDate *beginningOfEndDay   = [  endDate beginningOfDayInTimeZone:timeZone];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:beginningOfStartDay toDate:beginningOfEndDay options:0];
    return components.day;
}

+ (NSDateComponents *)daysAndTimeBetween:(NSDate *)startDate and:(NSDate *)endDate {
    NSParameterAssert(startDate && endDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

    return [calendar components:unitFlags fromDate:startDate toDate:endDate options:0];
}

- (NSDate *)beginningOfDayInTimeZone:(NSTimeZone *)timeZone {
    NSParameterAssert(timeZone);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    
	NSUInteger components = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
	return [calendar dateFromComponents:dateComponents];
}

- (NSDate *)dateWithTimeFromDate:(NSDate *)time timeZone:(NSTimeZone *)timeZone {
    NSParameterAssert(time);
    NSParameterAssert(timeZone);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    
    NSDateComponents *timeComponents = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit
                                                   fromDate:time];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                   fromDate:self];
    dateComponents.hour = timeComponents.hour;
    dateComponents.minute = timeComponents.minute;
    dateComponents.second = 0;
    
    return [calendar dateFromComponents:dateComponents];
}

- (NSDate *)dateByAddingDays:(NSInteger)days hours:(NSInteger)hours {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setDay:days];
    [dateComponents setHour:hours];

    return [calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setYear:years];
    
    return [calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dateInGMTFromDateInTimeZone:(NSTimeZone *)timeZone {
    NSCalendar *localCalendar = [NSCalendar currentCalendar];
    localCalendar.timeZone = timeZone;
    
    NSCalendar *GMTCalendar = [NSCalendar currentCalendar];
    GMTCalendar.timeZone = [NSTimeZone GMT];
    
    NSCalendarUnit allUnits = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [localCalendar components:allUnits fromDate:self];
    
    return [GMTCalendar dateFromComponents:components];
}

+ (instancetype)dateWithMillisecondsSince1970:(NSTimeInterval)millisecondsSince1970
{
    NSTimeInterval secondsSinceEpoch = millisecondsSince1970 / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:secondsSinceEpoch];
}

@end
