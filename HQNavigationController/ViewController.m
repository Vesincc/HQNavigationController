//
//  ViewController.m
//  HQNavigationController
//
//  Created by HanQi on 2017/8/24.
//  Copyright © 2017年 HanQi. All rights reserved.
//

#import "ViewController.h"
#import "SecoundViewController.h"
#import "HQNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"第一个";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    button.backgroundColor = [UIColor cyanColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

- (void)action {

    SecoundViewController *vc = [[SecoundViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    
}

- (void)viewDidAppear:(BOOL)animated {

    HQNavigationController *navc = (HQNavigationController *)self.navigationController;
    
    NSLog(@"%@", [navc valueForKeyPath:@"_screenshotImages"]);
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//
//    return UIStatusBarStyleLightContent;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
