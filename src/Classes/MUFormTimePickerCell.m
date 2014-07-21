//
//  MUFormTimePickerCell.m
//  MeetupApp
//
//  Created by Wes on 9/9/13.
//
//

#import "MUFormTimePickerCell.h"

@implementation MUFormTimePickerCell

+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info
{    
    return 216.0;
}


#pragma mark - Actions -

- (void)timePickerValueChanged:(UIDatePicker *)sender
{
    if ([self.delegate respondsToSelector:@selector(timePickerCell:didChangeTime:timeZone:)]) {
        [self.delegate timePickerCell:self didChangeTime:sender.date timeZone:self.timePicker.timeZone];
    }
}


#pragma mark - Overrides -

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.timePicker addTarget:self action:@selector(timePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    id timeZoneValue = info[MUFormCellAttributeValuesKey][MUFormCellTimeZoneKey];
    NSAssert(timeZoneValue && [timeZoneValue isKindOfClass:[NSTimeZone class]], @"Expected `MUFormCellTimeZoneKey` to be an NSTimeZone. It was: %@", [timeZoneValue class]);
    self.timePicker.timeZone = (NSTimeZone *)timeZoneValue;
    
    [self.timePicker setDate:value animated:NO];
    NSDate *minimumDate = self.cellAttributes[MUFormCellMinimumDateKey];
    [self.timePicker setMinimumDate:minimumDate];
    NSDate *maximumDate = self.cellAttributes[MUFormCellMaximumDateKey];
    [self.timePicker setMaximumDate:maximumDate];
}

@end
