//
//  BaseViewController.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabBarViewController.h"
#import "AppDelegate.h"
#import "PassViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *pass = [[NSUserDefaults  standardUserDefaults]objectForKey:@"pass"];
    if (pass) {
        PassViewController *pass = [PassViewController new];
        [UIApplication sharedApplication].delegate.window.rootViewController  = pass;
    } else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.mainTabBarViewController =[[BaseTabBarViewController alloc]init];
        [UIApplication sharedApplication].delegate.window.rootViewController = appDelegate.mainTabBarViewController;
    }
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
