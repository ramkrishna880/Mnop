//
//  ForgotPwdVC.m
//  Lapanzo
//
//  Created by PTG on 01/06/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "ForgotPwdVC.h"
#import "Lapanzo_Client+DataAccess.h"

@interface ForgotPwdVC () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *emailTxtField;
@property (nonatomic) Lapanzo_Client *client;
@end

@implementation ForgotPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //ForgotPwdSegueId
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}





- (IBAction)generateButtonTapped:(id)sender {
    if (!_emailTxtField.text.length) {
        [self showAlert:nil message:@"Please Enter Email"];
    } else if ([_emailTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
        [self showAlert:nil message:@"Enter a Valid Email"];
    } else {
        
    }
}

- (IBAction)backTosignIn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark WebOp

- (void)forGotPasswordForEmail:(NSString *)email {
    NSString *urlString = [NSString stringWithFormat:@"portal?a=resetpwd&em=%@",email];
    NSLog(@"%@",urlString);
    //@"portal?a=resetpwd&em=mails2mrk@gmail.com"
    [_client performOperationWithUrl:urlString andCompletionHandler:^(NSDictionary *responseObject) {
        NSLog(@"%@, : %@",responseObject,responseObject[@"msg"]);
        if ([responseObject.status isEqualToString:@"fail"]) {
            [self showAlert:@"Login" message:responseObject.message];
        } else {
            NSLog(@"%@",responseObject.userId);
            [self showAlert:@"Login" message:responseObject.message];
        }
    } failure:^(NSError *connectionError) {
        NSLog(@"%@",connectionError.localizedDescription);
        [self showAlert:@"Error" message:connectionError.localizedDescription];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
