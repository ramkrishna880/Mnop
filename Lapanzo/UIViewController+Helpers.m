//
//  UIViewController+Helpers.m
//  Lapanzo
//
//  Created by PTG on 05/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "UIViewController+Helpers.h"
#import "SWRevealViewController.h"

@implementation UIViewController (Helpers)

- (void)homeButton {
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}

- (void)setNavigationBarTintColor:(UIColor *)tintColor {
    self.navigationController.navigationBar.barTintColor = tintColor;
}

@end
