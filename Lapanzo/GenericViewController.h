//
//  GenericViewController.h
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Lapanzo_Client+DataAccess.h"
#import "NSDictionary+Response.h"
#import "MBProgressHUD.h"

@interface GenericViewController : UIViewController
@property (nonatomic) UILabel *cartLabel;
@property (nonatomic) UIButton *cartBtn;
//Methods
- (void)showAlert:(NSString *)title message:(NSString *)message;
- (void)fetchUserDetails;
- (void)animateConstraintsForDuration:(NSTimeInterval)animationDuration;

-(NSString *)uniqueDeviceId;
- (NSString *)iPAddress;

- (void)showHUD;
- (void)hideHud;

- (UIView *)rightBarButtonView;
@end
