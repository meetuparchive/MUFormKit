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
@property (weak, nonatomic) IBOutlet UILabel *relativeDateLabel;

@end
