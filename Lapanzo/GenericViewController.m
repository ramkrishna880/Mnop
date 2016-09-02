//
//  GenericViewController.m
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "GenericViewController.h"
#import "SSKeychain.h"
#import "UIColor+Helpers.h"
#include <ifaddrs.h>
#include <arpa/inet.h>


@interface GenericViewController ()
@property (nonatomic) IBOutlet UIView *cartView;
@end

@implementation GenericViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view addSubview:_cartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)rightBarButtonView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width-100, 0, 100, self.navigationController.navigationBar.frame.size.height)];
    [view setBackgroundColor:[UIColor grayColor]];
    [_cartView setFrame:CGRectMake(15, 4, 60, 40)];
    UIImageView *cartImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 8, 35, 35)];
    [cartImg setImage:[UIImage imageNamed:@"cart"]];
    [view addSubview:cartImg];
    
    _cartLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 2, 25, 25)];
    [_cartLabel setBackgroundColor:[UIColor colorFromRGBforRed:28.0 blue:153.0 green:126.0]];
    [_cartLabel setTextColor:[UIColor whiteColor]];
    [_cartLabel.layer setCornerRadius:12.5f];
    [_cartLabel setTextAlignment:NSTextAlignmentCenter];
    [_cartLabel setText:@"0"];
    [_cartLabel setFont:[UIFont systemFontOfSize:12.0f]];
    _cartLabel.clipsToBounds =  YES;
    [view addSubview:_cartLabel];
    
    _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cartBtn setFrame:view.bounds];
    [_cartBtn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_cartBtn];
    
    return view;
}

#pragma mark Others

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSString *)uniqueDeviceId {
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil) {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
    }
    return strApplicationUUID;
}

- (NSString *)iPAddress {
    
    /* can use this url to get ip address from response
     
     http://ipof.in/
     
     */
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}


- (void)fetchUserDetails {
    Lapanzo_Client *client = [Lapanzo_Client sharedClient];
    [self showHUD];
    [client performOperationWithUrl:[NSString stringWithFormat:@"portal?a=userdetails&userid=%@",client.userId] andCompletionHandler:^(NSDictionary *responseObject) {
        if ([responseObject.status isEqualToString:@"success"]) {
            [self hideHud];
            [client setUserDetails:responseObject];
            //[[NSNotificationCenter defaultCenter] postNotificationName:USERDETAILSFETCHEDNOTIFICATION object:self userInfo:nil];
        }
    } failure:^(NSError *connectionError) {
        [self hideHud];
        NSLog(@"%@",connectionError.localizedDescription);
    }];
}


- (void)animateConstraintsForDuration:(NSTimeInterval)animationDuration {
    if (!animationDuration) {
        animationDuration = 0.2;
    }
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideHud {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


//status": "success"
//"userid": 43
//"username": "Ramki"
//"em": "rkram880@gmail.com"
//"mobile": "9492608032"
//"mobileverified": "pending"
//"walletbalance": 50
//"referringcode": "TRFOLD"
//"profileimage": "nulldefault.png"

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
