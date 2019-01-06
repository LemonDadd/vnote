
//
//  YinsiViewController.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/20.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "YinsiViewController.h"
#import "Masonry.h"

@interface YinsiViewController ()

@end

@implementation YinsiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
     self.view.backgroundColor = [UIColor whiteColor];
    NSString *str = @"       This software is a class of notes application. The software respects and protects the personal privacy of all users of the service. In order to provide you with more accurate and personalized services, the software will use and disclose your personal information in accordance with the provisions of this privacy policy. However, the software will treat such information with a high degree of diligence and prudence. Unless otherwise provided in this privacy policy, the software will not disclose or provide such information to any third party without your prior permission. The software will update this privacy policy from time to time. When you agree to the use agreement of the software service, you shall be deemed to have agreed to all contents of this privacy policy. This privacy policy is an integral part of the software service usage agreement.";
    UILabel *view = [[UILabel alloc]init];
    [self.view addSubview:view];
    view.numberOfLines = 0;
    view.attributedText =[self getAttributedStringWithString:str lineSpace:8.f];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    
}

//设置行间距
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    return attributedString;
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
