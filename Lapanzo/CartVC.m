//
//  CartVC.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "CartVC.h"
#import "Constants.h"
#import "StoresTableViewCell.h"
#import "Lapanzo_Client+DataAccess.h"

@interface CartVC () <UITableViewDelegate, UITableViewDataSource, StoreTableCellDelegate>
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Lapanzo_Client *client;

//@property (nonatomic) NSMutableArray *cartItems;
@end

@implementation CartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialUiElements];
}

- (void)setupInitialUiElements {
    _cartItems = [[NSMutableArray alloc] initWithArray:_client.cartItems copyItems:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STORES_TABLECELLID];
    if (!cell) {
        cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STORES_TABLECELLID];
    }
    cell.currentItem = _cartItems[indexPath.row];
    
    cell.delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}


#pragma mark Actions

- (IBAction)mainCatogoryAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)storesButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkOutTapped:(id)sender {
    [self performSegueWithIdentifier:PAYMENT_SEGUEID sender:nil];
}

#pragma mark storecell Delegate

- (void)changedQuantityForCell:(StoresTableViewCell *)cell andValue:(NSUInteger)changedNumber {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Item *item = _cartItems[indexPath.row];
    item.noOfItems = @(changedNumber).stringValue;
    [_client setCartItems:_cartItems];
}


- (void)didDeleteClickedForCell:(StoresTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [_cartItems removeObjectAtIndex:indexPath.row];
    [_client setCartItems:_cartItems];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
