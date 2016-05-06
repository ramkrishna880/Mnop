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
#import "Constants.h"

@interface RearVC () <UITableViewDelegate, UITableViewDataSource>
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
    self.rows = @[@"My Account",@"Home",@"My Activities",@"Order History",@"My Cart",@"Favorities",@"Location",@"Notifications",@"Logout"];
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
    switch (indexPath.row) {
        case 0:
            storyBoardName = @"";
            break;
        case 1:
            storyBoardName = @""; //there Home
            break;
        case 2:
            storyBoardName = @"";
            break;
        case 3:
            storyBoardName = @"HistoryVC"; //der History
            break;
        case 4:
            storyBoardName = @"CartVC"; //der Cart
            break;
        case 5:
            storyBoardName = @"";
            break;
        case 6:
            storyBoardName = @"";
            break;
        case 7:
            storyBoardName = @"";
            break;
        case 8:
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
