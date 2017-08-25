//
//  ThirdViewController.m
//  HQNavigationController
//
//  Created by HanQi on 2017/8/24.
//  Copyright © 2017年 HanQi. All rights reserved.
//

#import "ThirdViewController.h"
#import "HQNavigationController.h"
#import "ViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"第三个";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
    button2.backgroundColor = [UIColor cyanColor];
    [button2 addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    [self.view addSubview:button2];
    
}

- (void)backAction {

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)action {
    
    ViewController *vc = [[ViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    HQNavigationController *navc = (HQNavigationController *)self.navigationController;
    
    NSLog(@"%@", [navc valueForKeyPath:@"_screenshotImages"]);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    
    
    
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
