//
//  LZiCloudViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 2016/12/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZiCloudViewController.h"
#import "LZiCloud.h"
#import "NoteManager.h"
#import "VNConstants.h"
#import "VNNote.h"
//#import "LZiCloudDocument.h"

@interface LZiCloudViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSUbiquitousKeyValueStore *myKeyValue;
@end

@implementation LZiCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self tableView];
    _myKeyValue = [NSUbiquitousKeyValueStore defaultStore];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        _tableView = table;
        
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.and.bottom.mas_equalTo(self.view);
        }];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.textLabel.textColor = [UIColor systemColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        //
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor = [UIColor systemColor];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Synchronized To iCloud";
    } else {
        
        cell.textLabel.text = @"From up to sync iCloud";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![LZiCloud iCloudEnable]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"ICloud is not available, please go to\"Settings -iCloud\" to enable it" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ok];
//        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (indexPath.section == 0) {
        [SVProgressHUD show];
        NSArray *list = [[NoteManager sharedManager] readAllNotes];
        NSMutableArray *ma = [NSMutableArray mj_keyValuesArrayWithObjectArray:list];
        //NSData *data=[NSJSONSerialization dataWithJSONObject:ma options:NSJSONWritingPrettyPrinted error:nil];
        [LZiCloud uploadToiCloud:ma resultBlock:^(NSError *error) {
            if (error == nil) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Success", nil)];
                [self->_myKeyValue setObject:ma forKey:@"note"];
                [self->_myKeyValue synchronize];
            } else {

                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fail", nil)];
            }

        }];
    } else {
        [SVProgressHUD show];
        [[NoteManager sharedManager] deleteAllNote];
        NSArray *arr = [_myKeyValue objectForKey:@"note"];
        if (arr.count) {
            for (NSDictionary * dic in arr) {
                VNNote *note = [VNNote mj_objectWithKeyValues:dic];
                [[NoteManager sharedManager] storeNote:note];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCreateFile object:nil];
           [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Success", nil)];
        } else {
           [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fail", nil)];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"Note: syncing to iCloud will overwrite the backup already in iCloud!";
    } else {
        
        return @"Note: iCloud syncing to local overwrites existing data!";
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
