//
//  MUFormTimeCell.m
//  MeetupApp
//
//  Created by Wes on 9/13/13.
//
//

#import "MUFormTimeCell.h"
#import "NSDate+MUDateStyles.h"

@implementation MUFormTimeCell
    
- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        NSAssert([value isKindOfClass:[NSDate class]], @"Expected ‘value’ to be an NSDate. It was: %@", [value class]);
    }
    
    id timeZoneValue = info[MUFormCellAttributeValuesKey][MUFormCellTimeZoneKey];
    NSAssert(timeZoneValue && [timeZoneValue isKindOfClass:[NSTimeZone class]], @"Expected `MUFormCellTimeZoneKey` to be an NSTimeZone. It was: %@", [timeZoneValue class]);
    self.timeZone = timeZoneValue;

    NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
    self.timeLabel.text = [value stringWithStyle:MUDateStyleTypeTime inTimeZone:self.timeZone];
}

@end
