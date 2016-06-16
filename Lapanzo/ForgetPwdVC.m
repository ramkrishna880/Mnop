//
//  ForgetPwdVC.m
//  Lapanzo
//
//  Created by PTG on 13/06/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "ForgetPwdVC.h"
#import "Lapanzo_Client+DataAccess.h"

@interface ForgetPwdVC ()
@property (nonatomic, strong) Lapanzo_Client *client;
@property (nonatomic, weak) IBOutlet UITextField *mobileNoTxtField;
@property (nonatomic, weak) IBOutlet UITextField *otpTxtField;
@property (nonatomic, weak) IBOutlet UITextField *pwdTxtField;
@property (nonatomic, weak) IBOutlet UITextField *reEnterPwdTxtField;
//constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *optViewVerticalCentreConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mobileNoTopConstraint;
@end

@implementation ForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _client = [Lapanzo_Client sharedClient];
}


#pragma mark UIActions

- (IBAction)sendForOtp:(id)sender {
    if (!_mobileNoTxtField.text.length) {
        [self showAlert:@"Forget Password" message:@"please Enter Mobile Number"];
    } else {
        [self doSetOtpPassword];
    }
}

- (IBAction)changePasswordbyOtp:(id)sender {
    if (!_otpTxtField.text.length) {
        [self showAlert:nil message:@"Please Enter Otp"];
    } else if (!_pwdTxtField.text.length || !_reEnterPwdTxtField.text.length) {
        [self showAlert:nil message:@"Please Enter password fields"];
    } else if (![_pwdTxtField.text isEqualToString:_reEnterPwdTxtField.text]) {
        [self showAlert:nil message:@"Password Didn't match"];
    } else {
        [self doRestpasswordWithOtp];
    }
}


- (IBAction)backToLoginTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark WebOps

- (void)doSetOtpPassword {
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=resetpwd&mobile=%@",_mobileNoTxtField.text];
    [self showHUD];
    [_client performOperationWithUrl:urlStr andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"success"]) {
            //TODO navigate to other
            _mobileNoTopConstraint.constant = -1000.0f;
            _optViewVerticalCentreConstraint.constant = 0.0f;
            [self animateConstraints];
            [self showAlert:@"" message:[responseObject valueForKey:@"msg"]];
        } else {
            [self showAlert:@"" message:[responseObject valueForKey:@"msg"]];
        }
        //        status": "success"
        //        "msg": "OTP sent to your Mobile"
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:@"Forget Password" message:connectionError.localizedDescription];
    }];
}


- (void)doRestpasswordWithOtp {
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=changepwdbyotp&mobile=%@&otp=%@&newpwd=%@&repeatpwd=%@",_mobileNoTxtField.text,_otpTxtField.text,_pwdTxtField,_reEnterPwdTxtField];
    [_client performOperationWithUrl:urlStr andCompletionHandler:^(NSDictionary *responseObject) {
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"fail"]) {
            [self showAlert:nil message:[responseObject valueForKey:@"msg"]];
        } else {
            //TODO do navigation from here
            // navigate back to loginScreen
            [self showAlert:@"Forget Password" message:@"Password has been reset successfully. please login here."];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *connectionError) {
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}



#pragma mark Others

- (void)animateConstraints {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}
@end
