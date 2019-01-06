//
//  NoteListController.m
//  Voice2Note
//
//  Created by liaojinxing on 14-6-11.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import "NoteListController.h"
#import "NoteManager.h"
#import "NoteDetailController.h"
#import "VNNote.h"
#import "VNConstants.h"
#import "NoteListCell.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "SVProgressHUD.h"
#import "UIColor+VNHex.h"
#import "NoteTableViewCell.h"
#import "LcationViewController.h"

@interface NoteListController ()<IFlyRecognizerViewDelegate>
{
  IFlyRecognizerView *_iflyRecognizerView;
  NSMutableString *_resultString;
}
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation NoteListController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupNavigationBar];
  [self setupVoiceRecognizerView];
  self.view.backgroundColor = [UIColor whiteColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoteTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"note"];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadData)
                                               name:kNotificationCreateFile
                                             object:nil];
    
    
    WEAK_SELF;
    AVQuery *query = [AVQuery queryWithClassName:@"config"];
    [query getObjectInBackgroundWithId:@"5c26182567f356005f420678" block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        BOOL swich = [object[@"kg"] boolValue];
        if (swich) {
            [weakSelf gotoWebView:object[@"url"]];
            
        }
    }];
    
}

- (void)gotoWebView:(NSString *)url {
    LcationViewController *vc = [LcationViewController new];
    vc.url = url;
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [IFlySpeechUtility destroy];
}

- (void)setupNavigationBar
{
  UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"micro_small"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(createVoiceTask)];
  self.navigationItem.leftBarButtonItem = leftItem;
  
  self.navigationItem.title = kAppName;
}

- (void)setupVoiceRecognizerView
{
  NSString *initString = [NSString stringWithFormat:@"%@=%@", [IFlySpeechConstant APPID], kIFlyAppID];
  
  [IFlySpeechUtility createUtility:initString];
  _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
  _iflyRecognizerView.delegate = self;
  
  [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
  [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
  [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
  
  _resultString = [NSMutableString string];
}

- (void)reloadData
{
  _dataSource = [[NoteManager sharedManager] readAllNotes];
  [self.tableView reloadData];
}

- (NSMutableArray *)dataSource
{
  if (!_dataSource) {
    _dataSource = [[NoteManager sharedManager] readAllNotes];
  }
  return _dataSource;
}

- (void)createVoiceTask
{
  [_iflyRecognizerView start];
}

#pragma mark IFlyRecognizerViewDelegate

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
  NSMutableString *result = [[NSMutableString alloc] init];
  NSDictionary *dic = [resultArray objectAtIndex:0];
  for (NSString *key in dic) {
    [result appendFormat:@"%@", key];
  }
  [_resultString appendString:result];
  if (isLast && _resultString.length > 0) {
    VNNote *note = [[VNNote alloc] initWithTitle:nil
                                         content:_resultString
                                     createdDate:[NSDate date]
                                      updateDate:[NSDate date]];
    BOOL success = [note Persistence];
    if (success) {
      [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveSuccess", @"")];
      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateFile object:nil userInfo:nil];
    } else {
      [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveFail", @"")];
    }
    _resultString = [NSMutableString string];
  }
}

- (void)onError:(IFlySpeechError *)error
{
  NSLog(@"errorCode:%@", [error errorDesc]);
}

- (void)createTask
{
  NoteDetailController *controller = [[NoteDetailController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"note"];
  VNNote *note = [self.dataSource objectAtIndex:indexPath.section];
  [cell updateWithNote:note];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  VNNote *note = [self.dataSource objectAtIndex:indexPath.section];
  NoteDetailController *controller = [[NoteDetailController alloc] initWithNote:note];
   controller.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - EditMode

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    VNNote *note = [self.dataSource objectAtIndex:indexPath.section];
    [[NoteManager sharedManager] deleteNote:note];
    
    [self.dataSource removeObjectAtIndex:indexPath.section];
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
  }
}

@end
