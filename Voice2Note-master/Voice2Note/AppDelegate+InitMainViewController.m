//
//  AppDelegate+InitMainViewController.m
//  jinheLV
//
//  Created by 今合网技术部 on 16/6/30.
//  Copyright © 2016年 今合网技术部. All rights reserved.
//

#import "AppDelegate+InitMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NoteListController.h"
#import "NoteDetailController.h"
#import "MineViewController.h"
#import "UIColor+VNHex.h"
#import "MainViewController.h"

@implementation AppDelegate (InitMainViewController)

- (void)rootTabBarViewController {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f], NSBackgroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [UINavigationBar appearance] .layer.borderWidth = 0.50;
    [UINavigationBar appearance] .layer.borderColor = [UINavigationBar appearance].tintColor.CGColor;
    
    //直播
    NoteListController *main = [[NoteListController alloc] init];
    UIImage* selectimage =[[UIImage imageNamed:@"mian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* selectedimage = [[UIImage imageNamed:@"main_sele"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem* airTabBarItem = main.tabBarItem;
    [airTabBarItem setImage:selectimage];
    [airTabBarItem setSelectedImage:selectedimage];
    [airTabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]}  forState:UIControlStateSelected];
    [airTabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayBackgroudColor]}  forState:UIControlStateNormal];
    UINavigationController *homeNavigationContoller = [[UINavigationController alloc] initWithRootViewController:main];
    [homeNavigationContoller.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    
    //播放
    MainViewController *vc = [[MainViewController alloc] init];
    UIImage* recordSelectimage = [[UIImage imageNamed:@"luyin"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* recordSelectedimage = [[UIImage imageNamed:@"luyin"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem* roundTabBarItem = vc.tabBarItem;
    
    [roundTabBarItem setImage:recordSelectimage];
    [roundTabBarItem setSelectedImage:recordSelectedimage];
    roundTabBarItem.imageInsets = UIEdgeInsetsMake(-8, 0, 8, 0);
    UINavigationController *recordNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //个人中心
    MineViewController * mine= [[MineViewController alloc] init];
    
    UIImage* personcenterSelectimage = [[UIImage imageNamed:@"shezhi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* personcenterSelectedimage = [[UIImage imageNamed:@"shezhi_sele"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem* otherTabBarItem = mine.tabBarItem;
    [otherTabBarItem setImage:personcenterSelectimage];
    [otherTabBarItem setSelectedImage:personcenterSelectedimage];
    [otherTabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]}  forState:UIControlStateSelected];
    [otherTabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayBackgroudColor]}  forState:UIControlStateNormal];
    UINavigationController *settingNavigationController = [[UINavigationController alloc] initWithRootViewController:mine];
    
    self.mainTabBarViewController = [[UITabBarController alloc] init];
    self.mainTabBarViewController.viewControllers = [NSArray arrayWithObjects:homeNavigationContoller, recordNavigationController, settingNavigationController, nil];
    self.mainTabBarViewController.delegate = self;
    
   
    //    self.mainTabBarViewController.viewControllers = [NSArray arrayWithObjects:homeNavigationContoller, nil];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

@end













