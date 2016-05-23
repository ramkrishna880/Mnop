//
//  CartVC.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "CartVC.h"
#import "Constants.h"
#import "PaymentVC.h"
#import "StoresTableViewCell.h"
#import "Lapanzo_Client+DataAccess.h"
#import "UIViewController+Helpers.h"


@interface CartVC () <UITableViewDelegate, UITableViewDataSource, StoreTableCellDelegate>
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Lapanzo_Client *client;

@property (nonatomic, weak) IBOutlet UIButton *mainCatButton;
//@property (nonatomic, weak) IBOutlet UIButton *backStoreButton;
@property (nonatomic, weak) IBOutlet UILabel  *multipleStoreStatLabel;
@property (nonatomic, weak) IBOutlet UILabel  *totalAmountLabel;

@end

@implementation CartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cart";
    [self setupInitialUiElements];
}

- (void)setupInitialUiElements {
    [self homeButton];
    _client = [Lapanzo_Client sharedClient];
    if (!_isFrmStore) {
        [_mainCatButton setHidden:YES];
//        [_backStoreButton setHidden:YES];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBarButtonView]];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    _cartItems = [[NSMutableArray alloc] initWithArray:_client.cartItems copyItems:NO];
    
    NSMutableArray *storeIds = [[NSMutableArray alloc] init];
    for (Item *itm in _cartItems) {
        [storeIds addObject:itm.storeId];
    }
    NSSet *storeIdSet = [[NSSet alloc] initWithArray:storeIds];
    if (storeIdSet.count >1) {
//        [_backStoreButton setHidden:YES];
        _multipleStoreStatLabel.text = @"You Have selected Multiple Stores";
    }
    _totalAmountLabel.text = [self totalPrice];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cartLabel.text = @(_client.cartItemsCount).stringValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_cartItems.count == 0) {
        return 1;
    } else{
        return _cartItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cartItems.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCellIdentifier"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        cell.textLabel.text = @"No Items Found in Cart";
        return cell;
    } else {
        StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STORES_TABLECELLID];
        if (!cell) {
            cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STORES_TABLECELLID];
        }
        cell.currentItem = _cartItems[indexPath.row];
        
        cell.delegate = self;
        return cell;
    }
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

#pragma mark Webopereations
- (void)proceedWebOp {
    
    //    NSString *url = [NSString stringWithFormat:@"portal?a=proceed&storeId=%@&userId=%@&deviceId=%@",_storeId,_client.userId,[self uniqueDeviceId]];
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=proceed&storeId=1&userId=1&deviceId=APadfasdjfhkasf-dskfjasdfjsadf-askfjklasfjasf"];
    [self showHUD];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        if ([responseObject.status isEqualToString:@"fail"]) {
            [self showAlert:@"Proceed" message:responseObject.message];
        } else {
            
        }
        
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}


#pragma mark Others

- (NSString *)totalPrice {
    CGFloat totalVal = 0.0;
    for (Item *item in _cartItems) {
        CGFloat val = item.priceAfterDiscount.floatValue;
        totalVal = totalVal+val;
    }
    return @(totalVal).stringValue;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PAYMENT_SEGUEID]) {
        PaymentVC *paymentVc = (PaymentVC *)segue.destinationViewController;
        paymentVc.totalPrice = [self totalPrice];
        paymentVc.storeId = _storeId;
    }
}


/* @@@@  sample Response *********
 
 {
 "a": "proceed"
 "status": "success"
 "servicetax": 0
 "vat": 0
 "deliverycharge": 50
 "servicefee": 0
 "onlinepayment": 1
 "cod": 1
 "takeaway": 1
 "homedelivery": 1
 "walletbalance": 123
 "minorder": 200
 "homedeliveryslots": [7]
 0:  {
 "id": 6
 "start": "16:00"
 "end": "18:00"
 "act": 1
 }-
 1:  {
 "id": 5
 "start": "14:00"
 "end": "16:00"
 "act": 1
 }-
 2:  {
 "id": 7
 "start": "18:00"
 "end": "20:00"
 "act": 1
 }-
 3:  {
 "id": 2
 "start": "08:00"
 "end": "10:00"
 "act": 1
 }-
 4:  {
 "id": 1
 "start": "06:00"
 "end": "08:00"
 "act": 0
 }-
 5:  {
 "id": 3
 "start": "10:00"
 "end": "12:00"
 "act": 1
 }-
 6:  {
 "id": 4
 "start": "12:00"
 "end": "14:00"
 "act": 1
 }-
 -
 "storeStatus": "open"
 }
 
 */

@end
