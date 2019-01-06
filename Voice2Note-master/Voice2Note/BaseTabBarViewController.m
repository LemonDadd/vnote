//
//  BaseTabBarViewController.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "NoteListController.h"
#import "NoteDetailController.h"
#import "MineViewController.h"
#import "UIColor+VNHex.h"
#import "MainViewController.h"
#import "PassViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NoteListController *home = [NoteListController new];
    [self addChildVc:home title:@"Note" image:@"mian" selectedImage:@"main_sele"];
    
    MainViewController *guide = [MainViewController new];
    [self addChildVc:guide title:@"" image:@"luyin" selectedImage:@"luyin"];
    
    //    InteractViewController *interact = [InteractViewController new];
    //    [self addChildVc:interact title:@"体验互动" image:@"tyhd_icon" selectedImage:@"tyhd_icon_true"];
    
    //    StaffViewController *staff = [StaffViewController new];
    //    [self addChildViewControllerByController:staff Title:@"首页" Image:nil];
    
    MineViewController *mine = [MineViewController new];
    [self addChildVc:mine title:@"Setting" image:@"shezhi" selectedImage:@"shezhi_sele"];
    
    
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if ([childVc isKindOfClass:[MainViewController class]]) {
         childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(-8, 0, 8, 0);
    }
    
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]}  forState:UIControlStateSelected];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayBackgroudColor]}  forState:UIControlStateNormal];
    
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
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
