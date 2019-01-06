//
//  PassViewController.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "PassViewController.h"
#import "DNPopinLockPasswordViewController.h"
#import "AppDelegate.h"
#import "BaseTabBarViewController.h"


@interface PassViewController ()

@end

@implementation PassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DNPopinLockPasswordViewController showWithTitle:@"请输入密码"
                                             superVC:self
                                       completeBlock:^(NSString *password, DNPopinLockPasswordViewController *passwordVC) {
                                           if ([password isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"]]) {
                                               [passwordVC dismissComplete:^{
                                                   //do something
                                                   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                   appDelegate.mainTabBarViewController =[[BaseTabBarViewController alloc]init];
                                                   [UIApplication sharedApplication].delegate.window.rootViewController = appDelegate.mainTabBarViewController;
                                               }];
                                           } else {
                                               [CustomView alertMessage:@"密码输入有误" view:self.view];
                                           }
                                           
                                           
                                       }
                                forgetPasswordAction:^(DNPopinLockPasswordViewController *passwordVC) {
                                    [passwordVC dismissComplete:^{
                                        //do something
                                        
                                    }];
                                }
                                        dismissBlock:^{
                                            //do something
                                            
                                        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
