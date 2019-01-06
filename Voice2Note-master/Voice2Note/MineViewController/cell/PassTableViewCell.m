//
//  PassTableViewCell.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "PassTableViewCell.h"
#import "DNPopinLockPasswordViewController.h"

@interface PassTableViewCell ()

@property (nonatomic, strong)NSString *passStr;

@end

@implementation PassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.pass.onTintColor = [UIColor systemColor];
    [self.pass addTarget:self action:@selector(switchPass) forControlEvents:UIControlEventValueChanged];
    
}

- (void)switchPass {
    if (self.pass.on) {
        [DNPopinLockPasswordViewController showWithTitle:@"请设置密码"
                                                 superVC:_vc
                                           completeBlock:^(NSString *password, DNPopinLockPasswordViewController *passwordVC) {
                                              self.pass.on = NO;
                                               self->_passStr = password;
                                               [passwordVC dismissComplete:^{
                                                   //do something
                                                   [self showPass1];
                                        
                                               }];
                                           }
                                    forgetPasswordAction:^(DNPopinLockPasswordViewController *passwordVC) {
                                        [passwordVC dismissComplete:^{
                                            //do something
                                             self.pass.on = NO;
                                        }];
                                    }
                                            dismissBlock:^{
                                                //do something
                                                 self.pass.on = NO;
                                            }];
    } else {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pass"];
    }
}

- (void)showPass1 {
    [DNPopinLockPasswordViewController showWithTitle:@"请确认密码"
                                             superVC:_vc
                                       completeBlock:^(NSString *password, DNPopinLockPasswordViewController *passwordVC) {
                                           if ([self.passStr isEqualToString:password]) {
                                               [passwordVC dismissComplete:^{
                                                   //do something
                                                    self.pass.on =YES;
                                                    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"pass"];
                                               }];
                                           } else {
                                               [CustomView alertMessage:@"两次密码输入不一致" view:passwordVC.view];
                                           }
                                           
                                       }
                                forgetPasswordAction:^(DNPopinLockPasswordViewController *passwordVC) {
                                    [passwordVC dismissComplete:^{
                                        //do something
                                        self.pass.on =NO;
                                    }];
                                }
                                        dismissBlock:^{
                                            //do something
                                             self.pass.on =NO;
                                        }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
