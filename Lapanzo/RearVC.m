//
//  RearVC.m
//  Lapanzo
//
//  Created by PTG on 05/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "RearVC.h"
#import "UIColor+Helpers.h"
#import "SWRevealViewController.h"
#import "Lapanzo_Client+DataAccess.m"
#import "AppDelegate.h"
#import "CartVC.h"
#import "Constants.h"

@interface RearVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) Lapanzo_Client *client;
@property (nonatomic, weak) IBOutlet UIImageView *userImgView;
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, strong) NSArray *rows;
@end

@implementation RearVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPinitialUIElements];
}


- (void)setUPinitialUIElements {
    [self.userImgView.layer setCornerRadius:40.0f];
    _client = [Lapanzo_Client sharedClient];
    
    //set Image also if avaliable
    _userName.text = _client.userDetails.userName;
    
    //    self.rows = @[@"My Account",@"Home",@"Order History",@"My Cart",@"Favorities",@"Location",@"Notifications",@"Logout"];
    self.rows = @[@"Lapanzo",@"Home",@"History",@"Location",@"Notifications",@"Verify Account",@"Logout"];
}

#pragma mark Tableview datasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rows.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.textLabel.textColor = [UIColor navigationBarTintColor];
    cell.textLabel.text = _rows[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    //    UINavigationController *navigationController = (UINavigationController*)[revealController.frontViewController navigationController];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *storyBoardName;
    
//[@"Lapanzo",@"History",@"Location",@"Notifications",@"Verify Account",@"Logout"]
    
    switch (indexPath.row) {
        case 0:
            storyBoardName = @"";
            break;
        case 1:
            storyBoardName = @"categoryVcSegueId"; //there Home
            break;
            //        case 2:
            //            storyBoardName = @"";
            //            break;
        case 2:
            storyBoardName = @"HistoryVC"; //der History
            break;
        case 3:
            //storyBoardName = @"CartVC"; //der Cart
            storyBoardName = @"searchviewid";
            break;
        case 4:
            storyBoardName = @"";//notifications
            break;
        case 5:
//            storyBoardName = @"searchviewid"; //
            //verify account
            break;
//        case 6:
//            storyBoardName = @"";
//            break;
        case 6:
        {
            Lapanzo_Client *client = [Lapanzo_Client sharedClient];
            [client setIsLogged:NO];
            [appDelegate performLoginIfNeeded];
        }
            break;
        default:
            break;
    }
    
    if (storyBoardName.length == 0) {
        return;
    }
    
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:storyBoardName];
    if (indexPath.row == 3) {
        ((CartVC *)vc).isFrmStore = NO;
    }
    [frontNavigationController setViewControllers:@[vc]];
    [revealController pushFrontViewController:frontNavigationController animated:YES];
    [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
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
