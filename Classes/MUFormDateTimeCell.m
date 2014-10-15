//
//  MUFormDatePickerCell.m
//  MeetupApp
//
//  Created by Wesley Smith on 6/21/13.
//
//

#import "MUFormDateTimeCell.h"

NSString *const MUFormCellDateIndicatorImageKey = @"MUFormCellDateIndicatorImageKey";

static CGFloat const kMUDefaultRowHeight = 44.0;

@implementation MUFormDateTimeCell

+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info
{    
    return kMUDefaultRowHeight;
}

#pragma mark - Accessors -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        
        CGRect expandedDateLabelFrame = self.dateLabel.frame;
        expandedDateLabelFrame.size.height = CGRectGetHeight(self.bounds);
        
        CGRect expandedTimeLabelFrame = self.timeLabel.frame;
        expandedTimeLabelFrame.size.height = CGRectGetHeight(self.bounds);
        
        if (CGRectContainsPoint(expandedDateLabelFrame, touchPoint)) {

            if ([self.delegate respondsToSelector:@selector(dateTimeCellDidTapDate:)]) {
                [self.delegate dateTimeCellDidTapDate:self];
            }
        }
        else if (CGRectContainsPoint(expandedTimeLabelFrame, touchPoint)) {
            
            if ([self.delegate respondsToSelector:@selector(dateTimeCellDidTapTime:)]) {
                [self.delegate dateTimeCellDidTapTime:self];
            }
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    
    if (value) {
        MUAssert([value isKindOfClass:[NSDate class]], @"Expected ‘value’ to be an NSDate. It was: %@", [value class]);

        id timeZoneValue = info[MUFormCellAttributeValuesKey][MUFormCellTimeZoneKey];
        MUAssert(timeZoneValue && [timeZoneValue isKindOfClass:[NSTimeZone class]], @"Expected `MUFormCellTimeZoneKey` to be an NSTimeZone. It was: %@", [timeZoneValue class]);
        self.timeZone = timeZoneValue;
        
        self.dateLabel.text = [value stringWithStyle:MUDateStyleTypeAbbreviatedDate inTimeZone:self.timeZone];
        self.timeLabel.text = [value stringWithStyle:MUDateStyleTypeTime  inTimeZone:self.timeZone];
        
        if (self.representsDefaultValue) {
            self.dateLabel.textColor = self.defaultValueTextColor;
            self.timeLabel.textColor = self.defaultValueTextColor;
            self.timeLabel.highlightedTextColor = self.defaultValueTextColor;
        }
        else {
            self.dateLabel.textColor = self.textColor;
            self.timeLabel.textColor = self.textColor;
            self.timeLabel.highlightedTextColor = self.textColor;
        }
        
        NSString *indicatorImage = self.cellAttributes[MUFormCellDateIndicatorImageKey];
        self.indicatorImage.image = [UIImage imageNamed:indicatorImage];
    }
}

@end
