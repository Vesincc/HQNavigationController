//
//  HQNavigationController.m
//  HQNavigationController
//
//  Created by HanQi on 2017/8/24.
//  Copyright © 2017年 HanQi. All rights reserved.
//

#import "HQNavigationController.h"
#import "HQNavigationAnimation.h"

@interface HQNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *screenshotImageView;

@property (nonatomic, strong) NSMutableArray *screenshotImages;

@property (nonatomic, strong) HQNavigationAnimation *animation;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *panGestureRecognizer;

@end

@implementation HQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(-0.8, 0);
    self.view.layer.shadowOpacity = 0.5;
    
    _panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    _panGestureRecognizer.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:_panGestureRecognizer];
    
    _screenshotImageView = [[UIImageView alloc] init];
    _screenshotImageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    _screenshotImages = [NSMutableArray array];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count >= 1) {
    
        viewController.hidesBottomBarWhenPushed = YES;
        [self screenshot];
        
    }
    
    [super pushViewController:viewController animated:animated];

}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    [_screenshotImages removeLastObject];
    
    return [super popViewControllerAnimated:animated];
    
}


- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSInteger removeCount = 0;
    
    for (int i = (int)(self.viewControllers.count - 1); i > 0; i++) {
    
        if (viewController == self.viewControllers[i]) {
        
            break;
            
        }
        
        removeCount++;
        [_screenshotImages removeLastObject];
        
    }
    
    _animation.removeCount = removeCount;
    
    return [super popToViewController:viewController animated:animated];
    
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {

    [_screenshotImages removeAllObjects];
    [_animation removeAllScreenShot];
    
    return [super popToRootViewControllerAnimated:animated];
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {

    self.animation.navigationController = self;
    self.animation.navigationOperation = operation;
    
    return self.animation;
    
}

- (HQNavigationAnimation *)animation {

    if (!_animation) {
    
        _animation = [[HQNavigationAnimation alloc] init];
        
    }
    
    return _animation;
    
}

- (void)screenshot {

    UIViewController *vc = self.view.window.rootViewController;
    
    CGSize size = vc.view.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    if (self.tabBarController == vc) {
        
        [vc.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    
    } else {
    
        [self.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
        
    }
    
    UIImage *shot = UIGraphicsGetImageFromCurrentImageContext();
    
    if (shot) {
    
        [_screenshotImages addObject:shot];
        
    }
    
    UIGraphicsEndImageContext();
    
}

- (void)panGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)panGesture {

    if (self.visibleViewController == self.viewControllers[0]) {
    
        return;
        
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
        
            [self dragBegin];
            break;
        }
            
        
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
        
            [self dragEnd];
            break;
        }
            
        default: {
        
            [self dragging:panGesture];
            break;
            
        }
            
    }
    
}

- (void)dragBegin {
    
    [self.view.window insertSubview:_screenshotImageView atIndex:0];

    _screenshotImageView.image = [_screenshotImages lastObject];
    
}

- (UIViewController *) childViewControllerForStatusBarStyle {
    
    return self.topViewController;

}

- (void)dragEnd {

    CGFloat translateX = self.view.transform.tx;
    
    CGFloat width = self.view.frame.size.width;
    
    if (translateX <= 40) {

        [UIView animateWithDuration:0.3 animations:^{
        
            self.view.transform = CGAffineTransformIdentity;
            _screenshotImageView.transform = CGAffineTransformMakeTranslation(-[[UIScreen mainScreen] bounds].size.width, 0);
            
        } completion:^(BOOL finished) {
    
            [_screenshotImageView removeFromSuperview];
    
        }];
        
    } else {
    
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(width, 0);
            _screenshotImageView.transform = CGAffineTransformMakeTranslation(0, 0);
            
        } completion:^(BOOL finished) {
     
            self.view.transform = CGAffineTransformIdentity;
     
            [_screenshotImageView removeFromSuperview];
     
            [self popViewControllerAnimated:NO];
            [self.animation removeLastScreenShot];
            
        }];
    }
}

- (void)dragging:(UIScreenEdgePanGestureRecognizer *)panGesture {

    CGFloat offsetX = [panGesture translationInView:self.view].x;
    
    if (offsetX > 0) {
        self.view.transform = CGAffineTransformMakeTranslation(offsetX, 0);
    }
    
    if (offsetX < [[UIScreen mainScreen] bounds].size.width) {
        
        _screenshotImageView.transform = CGAffineTransformMakeTranslation((offsetX - [[UIScreen mainScreen] bounds].size.width) * 0.6, 0);
    }
    
    
}




@end
