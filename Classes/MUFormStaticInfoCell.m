//
//  MUFormStaticInfoCell.m
//  MeetupApp
//
//  Created by Wes on 8/28/13.
//
//

#import "MUFormStaticInfoCell.h"

//static CGFloat const kMUDefaultheight = 54.0;

@implementation MUFormStaticInfoCell

+ (CGFloat)heightForTableView:(UITableView*)tableView value:(id)value info:(NSDictionary *)info
{
    MUFormStaticInfoCell *cell = (MUFormStaticInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"MUFormStaticInfoCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MUFormStaticInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [cell configureWithValue:value info:info];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        height += 1;
    }

    return height;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
