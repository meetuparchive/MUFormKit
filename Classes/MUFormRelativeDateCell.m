//
//  MUFormRelativeDatePickerCell.m
//  MeetupApp
//
//  Created by Wes on 8/9/13.
//
//

#import "MUFormRelativeDateCell.h"

NSString *const MUFormCellDateAscendingKey = @"MUFormCellDateAscendingKey";

static CGFloat const kMUDefaultRowHeight = 44.0;
static CGFloat const kMUHeightWithMessage = 56.0;

@interface MUFormRelativeDateCell ()

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, getter = isDateAscending) BOOL dateAscending;
@property (nonatomic) NSInteger numberOfDays;

@end

@implementation MUFormRelativeDateCell

+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info
{
    NSString *localizedKey = info[MUFormLocalizedCellMessageKey];
    NSString *message = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];

    return ([message length] > 0) ? kMUHeightWithMessage : kMUDefaultRowHeight;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    MUAssert([value isKindOfClass:[NSDate class]], @"Expected ‘value’ to be an NSDate. It was: %@", [value class]);
    
    id timeZoneValue = info[MUFormCellAttributeValuesKey][MUFormCellTimeZoneKey];
    MUAssert(timeZoneValue && [timeZoneValue isKindOfClass:[NSTimeZone class]], @"Expected `MUFormCellTimeZoneKey` to be an NSTimeZone. It was: %@", [timeZoneValue class]);
    NSTimeZone *timeZone = (NSTimeZone *)timeZoneValue;

    
    NSString *localizedKey = info[MUFormLocalizedCellMessageKey];
    NSString *message = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
    if ([message length] > 0) {
        self.messageLabel.text = [NSString stringWithFormat:message, [value stringWithStyle:MUDateStyleTypeLongDate
                                                                                 inTimeZone:timeZone]];
    }
    
    NSDate *minimumDate = self.cellAttributes[MUFormCellMinimumDateKey];
    self.minimumDate = (minimumDate) ?: [NSDate date];
    self.maximumDate = self.cellAttributes[MUFormCellMaximumDateKey];
    
    NSInteger days = [NSDate daysBetween:value and:self.maximumDate inTimeZone:timeZone];

    if (days == 0) {
        self.relativeDateLabel.text = NSLocalizedString(@"Day of Meetup", nil);
    }
    else if (days == 1) {
        self.relativeDateLabel.text = NSLocalizedString(@"The day before", @"The day before [the event]");
    }
    else {
        self.relativeDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld days before", @"Used in a relative date picker. '<number> [of] days before [a Meetup event]'"), (long)days];
    }
}

@end
