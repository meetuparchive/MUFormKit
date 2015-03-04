//
//  MUFormRelativeDatePickerCell.h
//  MeetupApp
//
//  Created by Wes on 8/9/13.
//
//

#import "MUFormDateTimeCell.h"

/** YES or NO (default is NO)*/
extern NSString *const MUFormCellDateAscendingKey;

@interface MUFormRelativeDateCell : MUFormBaseCell
@property (strong, nonatomic) UIFont *font UI_APPEARANCE_SELECTOR;
@property (weak, nonatomic) IBOutlet UILabel *relativeDateLabel;

@end
