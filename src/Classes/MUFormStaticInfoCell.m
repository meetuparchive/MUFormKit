//
//  MUFormStaticInfoCell.m
//  MeetupApp
//
//  Created by Wes on 8/28/13.
//
//

#import "MUFormStaticInfoCell.h"

static CGFloat const kMUDefaultheight = 54.0;

@implementation MUFormStaticInfoCell

+ (CGFloat)heightForValue:(id)value info:(NSDictionary *)info
{
    return kMUDefaultheight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
