//
//  AppDelegate.h
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;


- (void)performLoginIfNeeded;
@end

