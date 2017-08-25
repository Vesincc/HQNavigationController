//
//  HQNavigationAnimation.h
//  HQNavigationController
//
//  Created by HanQi on 2017/8/24.
//  Copyright © 2017年 HanQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQNavigationAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation navigationOperation;

@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, assign) NSInteger removeCount;

- (void)removeLastScreenShot;

- (void)removeAllScreenShot;

- (void)removeLastScreenShotWithNumber:(NSInteger)number;

@end
