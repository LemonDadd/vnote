//
//  YijianViewController.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/22.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "YijianViewController.h"
#import "Masonry.h"
#import "UITextView+Placeholder.h"
#import "UIColor+VNHex.h"
#import "SVProgressHUD.h"

@interface YijianViewController ()<UITextViewDelegate>

@property (nonatomic, strong)UITextView *field;
@property (nonatomic, strong)UILabel *lab;

@end


@implementation YijianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = right;
    
    _field = [UITextView new];
    _field.delegate =self;
    [self.view addSubview:_field];
    [_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
        make.right.bottom.equalTo(@-15);
    }];
    _field.backgroundColor = [UIColor colorWithHex:0xFBFCFD];
    _field.layer.cornerRadius = 3.5;
    _field.layer.borderWidth = 0.5;
    _field.layer.borderColor = [UIColor colorWithHex:0xEBECED].CGColor;
    _field.layer.masksToBounds = YES;
    _field.placeholder = @"Input";
    _field.font = [UIFont systemFontOfSize:15];
    _field.returnKeyType = UIReturnKeyDone;
    _field.delegate = self;
    
}

- (void)save
{
    if (_field.text.length) {
         [SVProgressHUD showErrorWithStatus:@"Please input feedback and submit"];
    }
    [SVProgressHUD showWithStatus:@"Wait..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"Success"];
    });
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
