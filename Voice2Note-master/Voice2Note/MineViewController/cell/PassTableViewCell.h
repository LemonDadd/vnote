//
//  PassTableViewCell.h
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassTableViewCell : UITableViewCell
@property (nonatomic, weak)IBOutlet UISwitch *pass;
@property (nonatomic, strong)UIViewController *vc;

@end

NS_ASSUME_NONNULL_END
