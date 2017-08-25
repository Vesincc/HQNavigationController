//
//  SecoundViewController.m
//  HQNavigationController
//
//  Created by HanQi on 2017/8/24.
//  Copyright © 2017年 HanQi. All rights reserved.
//

#import "SecoundViewController.h"
#import "ThirdViewController.h"
#import "HQNavigationController.h"

@interface SecoundViewController ()

@end

@implementation SecoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"第二个";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

- (void)action {
    
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    HQNavigationController *navc = (HQNavigationController *)self.navigationController;
    
    NSLog(@"%@", [navc valueForKeyPath:@"_screenshotImages"]);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
//    self.navigationController.navigationBar.hidden = YES;
  
  
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
    
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
