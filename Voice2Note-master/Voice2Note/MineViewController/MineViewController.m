//
//  MineViewController.m
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/19.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import "MineViewController.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyContact.h"
#import "SVProgressHUD.h"
#import "UIColor+VNHex.h"
#import "NoteManager.h"
#import "YinsiViewController.h"
#import "YijianViewController.h"
#import "PassTableViewCell.h"
#import "PushTableViewCell.h"
#import "DateTimePickerView.h"
#import "LZiCloudViewController.h"
#import "LZAboutusViewController.h"
#import "VNConstants.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate>

@property (nonatomic, strong)UITableView *tab;
@property (nonatomic, strong)NSArray *list;
@end

@implementation MineViewController
{
    NSString *time;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Setting";
    
    time = @"21:00";
    
    _tab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tab.delegate =self;
    _tab.dataSource =self;
    _tab.sectionHeaderHeight = 0;
    _tab.sectionFooterHeight = 0;
    [self.view addSubview:_tab];
    
    _list = @[@[@"Backup&Recovery"],@[@"Upload AB",@"Clear All Notes"],@[@"Set Password",@"Remind Me"],@[@"Feedback",@"Privacy Policy",@"About"]];
     [_tab registerNib:[UINib nibWithNibName:NSStringFromClass([PassTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"pass"];
     [_tab registerNib:[UINib nibWithNibName:NSStringFromClass([PushTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"push"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _list[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = _list[indexPath.section];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            PassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pass"];
            NSString *pass =[[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
            
            cell.pass.on =pass?YES:NO;
            cell.textLabel.text =arr[indexPath.row];
            cell.textLabel.textColor = [UIColor systemColor];
            cell.vc = self;
            return cell;
        } else {
            PushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"push"];
            [cell.time setTitle:[NSString stringWithFormat:@"| %@ |",time] forState:UIControlStateNormal];
            NSString *push =[[NSUserDefaults standardUserDefaults] objectForKey:@"push"];
            cell.push.on =push?YES:NO;
            [cell.time addTarget:self action:@selector(showTime) forControlEvents:UIControlEventTouchUpInside];
            cell.textLabel.text =arr[indexPath.row];
            cell.textLabel.textColor = [UIColor systemColor];
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.text =arr[indexPath.row];
        cell.textLabel.textColor = [UIColor systemColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 1 && indexPath.row ==0) {
            NSString * user = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
            if (user.length) {
               cell.detailTextLabel.text =@"Uploaded";
            }else {
               
               cell.detailTextLabel.text = @"No uploaded";
            }
        }
        return cell;
    }
    
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = _list[indexPath.section];
    if (indexPath.section == 0) {
        LZiCloudViewController *vc = [LZiCloudViewController new];
        vc.title = arr[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self uploadUser];
        }
        if (indexPath.row == 1) {
            [[NoteManager sharedManager]deleteAllNote];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCreateFile object:nil];
            [CustomView alertMessage:@"Success" view:self.view];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            YijianViewController *vc =[YijianViewController new];
            vc.title = arr[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            YinsiViewController *vc =[YinsiViewController new];
            vc.title = arr[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            LZAboutusViewController *vc =[LZAboutusViewController new];
            vc.title = arr[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)uploadUser {
    
    NSString * user = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    if (user.length) {
        return;
    }
    
    IFlyDataUploader *_uploader = [[IFlyDataUploader alloc] init];
    IFlyContact *iFlyContact = [[IFlyContact alloc] init]; NSString *contactList = [iFlyContact contact];
    [_uploader setParameter:@"uup" forKey:@"subject"];
    [_uploader setParameter:@"contact" forKey:@"dtt"];
    //启动上传
    
    [_uploader uploadDataWithCompletionHandler:^(NSString *grammerID, IFlySpeechError *error) {
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [[NSUserDefaults standardUserDefaults]setObject:@"user" forKey:@"user"];
        [self->_tab reloadData];
    } name:@"contact" data:contactList];
}


- (void)showTime {
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    pickerView.delegate = self;
    pickerView.pickerViewMode = DatePickerViewTimeMode;
    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
}

- (void)setPass {
    
}

- (void)setPass2 {
    
}

- (void)didClickFinishDateTimePickerView:(NSString *)date {
    time = date;
    [_tab reloadData];
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
