//
//  LcationViewController.m
//  Voice2Note
//
//  Created by 关云秀 on 2019/1/6.
//  Copyright © 2019 jinxing. All rights reserved.
//

#import "LcationViewController.h"

@interface LcationViewController ()
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIWebView *web;
@end

@implementation LcationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor =[UIColor colorWithHex:0xd8d8d8]; //[UIColor colorWithNumber:LINECOLOR];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    
    NSArray *images = @[@"left",@"right",@"shuaxin",@"zhuye"];
    NSMutableArray *btns = [NSMutableArray new];
    for (int i=0; i<images.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [_bottomView addSubview:btn];
        [btns addObject:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnSeleted:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView);
    }];
    
    
    
    _web = [UIWebView new];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    _web.scrollView.bounces = NO;
    [_web loadRequest:request];
    [self.view addSubview:_web];
    [_web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)btnSeleted:(UIButton *)sender {
    if (sender.tag == 0) {
        if (_web.canGoBack) {
            [_web goBack];
        }
    } else if (sender.tag ==1) {
        if (_web.canGoForward) {
            [_web goForward];
        }
    } else if (sender.tag == 2) {
        [_web reload];
    } else if (sender.tag == 3) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_web loadRequest:request];
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
