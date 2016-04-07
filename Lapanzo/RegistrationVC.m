//
//  RegistrationVC.m
//  Lapanzo
//
//  Created by PTG on 04/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "RegistrationVC.h"
#import "NSString+Validations.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface RegistrationVC () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *userNameTxtFiled;
@property (nonatomic, weak) IBOutlet UITextField *emailTxtFiled;
@property (nonatomic, weak) IBOutlet UITextField *mobileNoTxtFiled;
@property (nonatomic, weak) IBOutlet UITextField *passwordTxtFiled;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewVerticalCentrConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLogotopConstraint;

@property (nonatomic) Lapanzo_Client *client;
@end

@implementation RegistrationVC

#pragma mark ViewLife Cycle & like

- (void)viewDidLoad {
    [super viewDidLoad];
    _client = [Lapanzo_Client sharedClient];
//    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDownAcion:)];
//    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.view addGestureRecognizer:swipeDown];
    [self registerNotifications:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self registerNotifications:NO];
}

- (void)viewDidUnload {
    [self registerNotifications:NO];
}
#pragma mark Actions

- (IBAction)registerButtonClicked:(id)sender {
    if (_userNameTxtFiled.text.length == 0 || _emailTxtFiled.text.length==0 || _mobileNoTxtFiled.text.length==0 || _passwordTxtFiled.text.length==0) {
        [self showAlert:nil message:@"Please enter all fields"];
    } else if (!([[_emailTxtFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isValidEmail])){
        [self showAlert:nil message:@"Please enter a valid mail"];
    } else if (![[NSString stringWithFormat:@"+%@",_mobileNoTxtFiled.text] isValidPhoneNumber]) {
        [self showAlert:nil message:@"please enter a valid mobile number"];
    } else {
        [self doRegistration];
    }
}


- (IBAction)tapGestureTapped:(UITapGestureRecognizer *)sender {
    if (sender.numberOfTapsRequired == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark Weboperations

- (void)doRegistration {
    
    //TODO add ip address , host - (Lapnzo) , device ID
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"portal?a=register&em=%@&passphrase=%@&mobile=%@&username=%@&ip=%@&useragent=%@&host=%@&deviceid=%@",_emailTxtFiled.text,[_passwordTxtFiled.text MD5String],_mobileNoTxtFiled.text,_userNameTxtFiled.text,[self iPAddress],@"ios",@"Lapanzo",[self uniqueDeviceId]];
    
    //@"portal?a=register&em=ramkrishna@gmail.com&passphrase=123456&mobile=1234567890&username=ramki"
    [_client registrationWithUrl:urlString andCompletionHandler:^(NSDictionary *responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@, : %@",responseObject,responseObject[@"msg"]);
        if ([responseObject.status isEqualToString:@"fail"]) {
            [self showAlert:@"Login" message:responseObject.message];
        } else {
            [_client setUserId:responseObject.userId];
            [_client setIsLogged:YES];
            [self fetchUserDetails];
            [appDelegate performLoginIfNeeded];
            //[self performSegueWithIdentifier:CATEGORY_REG_SEGUEID sender:nil];
        }
    } failure:^(NSError *connectionError) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",connectionError.localizedDescription);
        [self showAlert:@"Error" message:connectionError.localizedDescription];
    }];
}

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


#pragma mark Tableview Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _userNameTxtFiled) {
        [_userNameTxtFiled resignFirstResponder];
        [_emailTxtFiled becomeFirstResponder];
    } else if (textField == _emailTxtFiled) {
        [_emailTxtFiled resignFirstResponder];
        [_mobileNoTxtFiled becomeFirstResponder];
    } else if (textField ==_mobileNoTxtFiled) {
        [_mobileNoTxtFiled resignFirstResponder];
        [_passwordTxtFiled becomeFirstResponder];
    }else {
        [textField becomeFirstResponder];
    }
    return YES;
}


#pragma mark Others
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//- (void)animateConstraintsForDuration:(NSTimeInterval)animationDuration {
//    if (!animationDuration) {
//        animationDuration = 0.2;
//    }
//    [UIView animateWithDuration:animationDuration animations:^{
//        [self.view layoutIfNeeded];
//    }];
//}
/*
 
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
