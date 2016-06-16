//
//  ViewController.m
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Validations.h"
#import "AppDelegate.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *emailTxtFiled;
@property (nonatomic, weak) IBOutlet UITextField *passwordTxtFiled;
@property (nonatomic) Lapanzo_Client *client;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewVerticalCentrConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLogotopConstraint;

@end

@implementation ViewController

#pragma mark View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _client = [Lapanzo_Client sharedClient];
    [self registerNotifications:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self registerNotifications:NO];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark Actions

- (IBAction)submitClicked:(id)sender {
    if (!_emailTxtFiled.text.length || !_passwordTxtFiled.text.length) {
        [self showAlert:@"Login" message:@"Enter all fields"];
    } else if (![_emailTxtFiled.text isValidEmail]){
        [self showAlert:@"Login" message:@"Enter proper Email"];
    } else {
        [self performLogin];
    }
}

- (IBAction)forGotPasswordClicked:(id)sender {
    [self performSegueWithIdentifier:@"ForgotPwdSegueId" sender:nil];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Forgot Password" message:@"Please enter your registered email" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Email";
//    }];
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        UITextField *alertTxtField = alert.textFields[0];
//        [self forGotPasswordForEmail:alertTxtField.text];
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:cancelAction];
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark web operations

- (void)performLogin {
    NSString *urlString = [NSString stringWithFormat:@"portal?a=login&em=%@&passphrase=%@&ip=%@&useragent=%@&host=%@&deviceid=%@",_emailTxtFiled.text,[_passwordTxtFiled.text MD5String],[self iPAddress],@"ios",@"Lapanzo",[self uniqueDeviceId]];
    NSLog(@"%@",urlString);
    //@"portal?a=login&em=mails2mrk@gmail.com&passphrase=12345"
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_client loginWithUrl:urlString andCompletionHandler:^(NSDictionary *responseObject) {
        NSLog(@"%@, : %@",responseObject,responseObject[@"msg"]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([responseObject.status isEqualToString:@"fail"]) {
            [self showAlert:@"Login" message:responseObject.message];
        } else {
            [_client setIsLogged:YES];
            [_client setUserId:responseObject.userId];
            [self fetchUserDetails];
            [appDelegate performLoginIfNeeded];
            //[self performSegueWithIdentifier:CATEGORY_SEGUEID sender:nil];
        }
    } failure:^(NSError *connectionError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlert:@"Error" message:connectionError.localizedDescription];
    }];
}

//- (void)forGotPasswordForEmail:(NSString *)email {
//    NSString *urlString = [NSString stringWithFormat:@"portal?a=resetpwd&em=%@",email];
//    NSLog(@"%@",urlString);
//    //@"portal?a=resetpwd&em=mails2mrk@gmail.com"
//    [_client performOperationWithUrl:urlString andCompletionHandler:^(NSDictionary *responseObject) {
//        NSLog(@"%@, : %@",responseObject,responseObject[@"msg"]);
//        if ([responseObject.status isEqualToString:@"fail"]) {
//            [self showAlert:@"Login" message:responseObject.message];
//        } else {
//            NSLog(@"%@",responseObject.userId);
//            [self showAlert:@"Login" message:responseObject.message];
//        }
//    } failure:^(NSError *connectionError) {
//        NSLog(@"%@",connectionError.localizedDescription);
//        [self showAlert:@"Error" message:connectionError.localizedDescription];
//    }];
//}


#pragma mark Notifications & KeyBoard

- (void)registerNotifications:(BOOL)shouldRegister {
    if (shouldRegister) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    //CGFloat keyboardHeight = keyboardFrame.size.height;
    _viewVerticalCentrConstraint.constant = KeyboardMoveHeightConstant;
    _topLogotopConstraint.constant = -100;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _viewVerticalCentrConstraint.constant = 0;
    _topLogotopConstraint.constant = LogoTopConstant;
    [self animateConstraintsForDuration:animationDuration];
}

#pragma mark TextFiled delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _emailTxtFiled) {
        [_emailTxtFiled resignFirstResponder];
        [_passwordTxtFiled becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
