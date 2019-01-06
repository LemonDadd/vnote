//
//  MainViewController.m
//  
//
//  Created by 关云秀 on 2018/12/20.
//

#import "MainViewController.h"
#import "NoteDetailController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NoteDetailController *detail =[NoteDetailController new];
    UINavigationController *nav = [UINavigationController new];
    [nav addChildViewController:detail];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
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
