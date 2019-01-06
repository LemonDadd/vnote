//
//  PushTableViewCell.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "PushTableViewCell.h"


@interface PushTableViewCell ()

@end

@implementation PushTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.time setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
    self.push.onTintColor = [UIColor systemColor];
    [self.push addTarget:self action:@selector(switchPush) forControlEvents:UIControlEventValueChanged];
    
}

- (void)switchPush {
    if (self.push.on) {
        [[NSUserDefaults standardUserDefaults]setObject:@"push" forKey:@"push"];
    } else {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"push"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
