//
//  HCPushSettingViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCPushSettingViewController.h"
#import <objc/runtime.h>

@interface HCPushSettingViewController ()

@end

@implementation HCPushSettingViewController {
    BOOL __viewDidLoad;
}

- (instancetype)initWithContentController:(UIViewController *)controller {
    if (self = [super init]) {
        [self setup];
        [self setPushChildViewController:controller];
    }
    return self;
}

+ (instancetype)settingControllerWithContentController:(UIViewController *)controller {
    return [[self alloc] initWithContentController:controller];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateChildViewConstraits];
    __viewDidLoad = YES;
}

- (void)updateChildViewConstraits {
    UIView *childView = self.pushChildViewController.view;
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    childView.frame = self.hcContentView.bounds;
    [self.hcContentView addSubview:childView];
    ///must add to hcContentView, not self.view
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)setPushChildViewController:(UIViewController * _Nonnull)pushChildViewController {
    if (_pushChildViewController) {
        [_pushChildViewController.view removeFromSuperview];
        [_pushChildViewController removeFromParentViewController];
        
    }
    _pushChildViewController = pushChildViewController;
    // to resolve _pushChildViewController dismiss action
    [self addChildViewController:_pushChildViewController];
    if (__viewDidLoad) {
        [self updateChildViewConstraits];
    }
}

- (void)setup {
    __viewDidLoad = NO;
}

#pragma mark - lift cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_viewWillShowHandler) {
        _viewWillShowHandler(self.pushChildViewController.view);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_viewDidShowHandler) {
        _viewDidShowHandler(self.pushChildViewController.view);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_viewWillHideHandler) {
        _viewWillHideHandler(self.pushChildViewController.view);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_viewDidHideHandler) {
        _viewDidHideHandler(self.pushChildViewController.view);
    }
}

//- (void)dealloc {
//#if DEBUG
//    NSLog(@"HCPushSettingViewController dealloc");
//#endif
//}

#pragma mark - rotation

- (BOOL)shouldAutorotate {
    if (_pushChildViewController) {
        return [_pushChildViewController shouldAutorotate];
    }
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (_pushChildViewController) {
        return [_pushChildViewController preferredInterfaceOrientationForPresentation];
    }
    //TODO:You can fix this value to set default
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_pushChildViewController) {
        return [_pushChildViewController supportedInterfaceOrientations];
    }
    //TODO:You can fix this value to set default
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

@end
