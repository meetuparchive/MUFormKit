//
//  MUFormPushCell.m
//  MeetupApp
//
//  Created by Wes on 9/9/13.
//
//

#import "MUFormToFormSegueCell.h"

NSString *const MUFormSubformEnabledPropertyNameKey = @"MUFormSubformEnabledPropertyNameKey";
NSString *const MUFormSubformValuePropertyNameKey = @"MUFormSubformValuePropertyNameKey";

@interface MUFormToFormSegueCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateIndicatorLabel;
@end


@implementation MUFormToFormSegueCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageLabel.text = nil;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    NSString *localizedKey = info[MUFormLocalizedStaticTextKey];
    self.staticLabel.text = [[NSBundle mainBundle] localizedStringForKey:localizedKey value:localizedKey table:MUFormKitStringTable];
    
    self.messageLabel.text = nil;
    if (value) {
        MUAssert([value isKindOfClass:[NSString class]], @"Expected ‘value’ to be an NSString. It was: %@", [value class]);
        self.messageLabel.text = value;
    }
    
    NSNumber *state = self.cellAttributes[MUFormSubformEnabledPropertyNameKey];
    NSString *text = self.cellAttributes[MUFormSubformValuePropertyNameKey];
    if (state) {
        self.stateIndicatorLabel.text = [state boolValue] ? NSLocalizedString(@"On", @"Label for an on/off switch") : NSLocalizedString(@"Off", @"Label for an on/off switch");
    }
    else {
        self.stateIndicatorLabel.text = text;
    }

}

@end
