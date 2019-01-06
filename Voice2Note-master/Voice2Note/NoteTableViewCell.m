//
//  NoteTableViewCell.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "NoteTableViewCell.h"
#import "Colours.h"
#import "VNNote.h"

@interface NoteTableViewCell()

@property (nonatomic, weak)IBOutlet UILabel *date;
@property (nonatomic, weak)IBOutlet UILabel *title;
@property (nonatomic, weak)IBOutlet UILabel *content;
@property (nonatomic, weak)IBOutlet UIView *main;

@end

@implementation NoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.date.textColor = [UIColor whiteColor];
    self.title.textColor = [UIColor whiteColor];
    self.content.textColor = [UIColor whiteColor];
    self.main.backgroundColor = [UIColor systemColor];
    
    self.main.layer.masksToBounds = YES;
    self.main.layer.cornerRadius = 5;
    self.main.layer.borderWidth =1.f;
    self.main.layer.borderColor =[UIColor black25PercentColor].CGColor;
}

- (void)updateWithNote:(VNNote *)note
{
    self.content.text =note.content;
    NSDate *date = [NSDate jk_dateWithString:note.createdDate format:@"yy-MM-dd HH:mm:ss"];
    
    self.date.text =[NSString stringWithFormat:@"%lu\n%lu/%lu",(unsigned long)[NSDate jk_year:date],(unsigned long)[NSDate jk_month:date],(unsigned long)[NSDate jk_month:date]];
    self.title.text = [NSString stringWithFormat:@"%@(%@)",[NSDate jk_dayFromWeekday:date],[NSDate jk_stringWithDate:date format:@"HH:mm:ss"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
