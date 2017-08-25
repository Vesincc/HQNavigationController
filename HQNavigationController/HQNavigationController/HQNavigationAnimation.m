//
//  HQNavigationAnimation.m
//  HQNavigationController
//
//  Created by HanQi on 2017/8/24.
//  Copyright © 2017年 HanQi. All rights reserved.
//

#import "HQNavigationAnimation.h"

@interface HQNavigationAnimation ()

@property (nonatomic, strong) NSMutableArray *screenshotImages;

@property (nonatomic, assign) BOOL existTabbar;

@end

@implementation HQNavigationAnimation

- (void)setNavigationController:(UINavigationController *)navigationController {

    _navigationController = navigationController;
    
    UIViewController *vc = navigationController.view.window.rootViewController;
    
    _existTabbar = navigationController.tabBarController == vc ? YES : NO;
    
}

- (NSMutableArray *)screenshotImages {

    if (!_screenshotImages) {
    
        _screenshotImages = [NSMutableArray array];
        
    }
    
    return _screenshotImages;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {

    return 0.3f;
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIImageView * screentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    UIImage * screenImg = [self screenshot];
    screentImgView.image = screenImg;
    
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect fromViewEndFrame = [transitionContext finalFrameForViewController:fromViewController];
    fromViewEndFrame.origin.x = [[UIScreen mainScreen] bounds].size.width;
    CGRect fromViewStartFrame = fromViewEndFrame;
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toViewStartFrame = toViewEndFrame;
    
    UIView * containerView = [transitionContext containerView];
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        
        [self.screenshotImages addObject:screenImg];
        [containerView addSubview:toView];
        toView.frame = toViewStartFrame;
        UIView * nextVC = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
        [self.navigationController.view.window insertSubview:screentImgView atIndex:0];
        
        nextVC.layer.shadowColor = [UIColor blackColor].CGColor;
        nextVC.layer.shadowOffset = CGSizeMake(-0.8, 0);
        nextVC.layer.shadowOpacity = 0.6;
        
        self.navigationController.view.transform = CGAffineTransformMakeTranslation([[UIScreen mainScreen] bounds].size.width, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screentImgView.center = CGPointMake(-([[UIScreen mainScreen] bounds].size.width)/2, ([[UIScreen mainScreen] bounds].size.height) / 2);
            
        } completion:^(BOOL finished) {
            
            [nextVC removeFromSuperview];
            [screentImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
    if (self.navigationOperation == UINavigationControllerOperationPop) {
        
        fromViewStartFrame.origin.x = 0;
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-([[UIScreen mainScreen] bounds].size.width), 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        
        if (_removeCount > 0) {
            for (NSInteger i = 0; i < _removeCount; i ++) {
                if (i == _removeCount - 1) {
                    
                    lastVcImgView.image = [self.screenshotImages lastObject];
                    _removeCount = 0;
                    break;
                } else {
                    
                    [self.screenshotImages removeLastObject];
                
                }
                
            }
        } else {
            
            lastVcImgView.image = [self.screenshotImages lastObject];
        
        }
        
        screentImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screentImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screentImgView.layer.shadowOpacity = 0.6;
        
        [self.navigationController.view.window addSubview:lastVcImgView];
        [self.navigationController.view.window addSubview:screentImgView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screentImgView.center = CGPointMake(([[UIScreen mainScreen] bounds].size.width) * 3 / 2 , ([[UIScreen mainScreen] bounds].size.height) / 2);
            lastVcImgView.center = CGPointMake(([[UIScreen mainScreen] bounds].size.width)/2, ([[UIScreen mainScreen] bounds].size.height)/2);
            
        } completion:^(BOOL finished) {

            [lastVcImgView removeFromSuperview];
            [screentImgView removeFromSuperview];
            [self.screenshotImages removeLastObject];
            [transitionContext completeTransition:YES];
            
        }];
        
        
    }
    
}

- (void)removeLastScreenShot {

    [self.screenshotImages removeLastObject];
}

- (void)removeAllScreenShot {

    [self.screenshotImages removeAllObjects];
    
}

- (void)removeLastScreenShotWithNumber:(NSInteger)number {

    for (int i = 0; i < number; i++) {
    
        [self removeLastScreenShot];
        
    }
    
}

- (UIImage *)screenshot {
    
    UIViewController *vc = self.navigationController.view.window.rootViewController;
    
    CGSize size = vc.view.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    if (self.existTabbar) {
        
        [vc.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
        
    } else {
        
        [self.navigationController.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
        
    }
    
    UIImage *shot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return shot;
    
}


@end
