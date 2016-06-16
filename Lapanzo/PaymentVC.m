//
//  PaymentVC.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "PaymentVC.h"
#import "Constants.h"
#import "UIApplication+Paths.h"
#import <INTULocationManager.h>
//#import "Lapanzo-Swift.h"
#import "Item.h"
#import "UIViewController+Helpers.h"


@interface PaymentVC () <UITextFieldDelegate>
@property (nonatomic) Lapanzo_Client *client;
@property (nonatomic) IBOutlet UILabel *amountLabel;


@property (nonatomic, weak) IBOutlet UITableView *tableView;
//@property (nonatomic, weak) IBOutlet UIView *locationView;
@property (nonatomic, weak) IBOutlet UIView *enterAddressView;
@property (nonatomic, weak) IBOutlet UILabel *locationValLbl;
@property (nonatomic, weak) IBOutlet UITextField *deliverTime;

@property (nonatomic, weak) IBOutlet UITextField *addressline1;
@property (nonatomic, weak) IBOutlet UITextField *addressline2;
@property (nonatomic, weak) IBOutlet UITextField *addressCity;
@property (nonatomic, weak) IBOutlet UITextField *addressState;
@property (nonatomic, weak) IBOutlet UITextField *addressPincode;
@property (nonatomic, weak) IBOutlet UITextField *addressCountry;
@property (nonatomic, weak) IBOutlet UISegmentedControl *delivaryTypeSgCntrl;

@property (nonatomic) NSMutableArray *pickups;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (nonatomic , strong) NSString *addressString;
//@property (nonatomic) PopDatePicker *popDatePicker;
@end



typedef enum : NSUInteger {
    kAddressTypeAttach,
    kAddressTypeEnter,
    kAddressTypeHistory,
} kAddressType;

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialAllElements];
}

- (void)setupInitialAllElements {
    [self homeButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBarButtonView]];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_locationValLbl.layer setBorderWidth:1.0f];
    [_locationValLbl.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    //    [_addressTxtView.layer setBorderWidth:1.0f];
    //    [_addressTxtView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
//    _popDatePicker = [[PopDatePicker alloc] initForTextField:_deliverTime];
    _amountLabel.text = _totalPrice;
}



#pragma mark UItableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pickups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYMENTHIS_TABLECELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PAYMENTHIS_TABLECELLID];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = _pickups [indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark Ui Actions

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    NSUInteger tag = sender.selectedSegmentIndex;
    switch (tag) {
        case kAddressTypeAttach:
        {
            [self fetchCurrentLocation];
        }
            break;
        case kAddressTypeEnter:
        {
            [self clearAllFields];
        }
            break;
        default:
            break;
    }
}

- (IBAction)pickUpSegmentAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.tableView setHidden:YES];
        [self.enterAddressView setHidden:NO];
    } else {
        [self.tableView setHidden:NO];
        [self.enterAddressView setHidden:YES];
        [self fetchPickUpLocations];
        [self showAlert:@"Order" message:@"Home services ,Water and other services doesn't come under pickup service"];
    }
}


- (IBAction)sendOrderTapped:(id)sender {
    [self sendOrder];
}

- (NSArray *)getItesmsForStoreId:(NSNumber *)storeId {
    //    NSPredicate *pradicate = [NSPredicate ];
    NSPredicate *pradicate = [NSPredicate predicateWithFormat:@"storeId == %@",storeId];
    NSArray *results = [_cartItems filteredArrayUsingPredicate:pradicate];
    return results;
}

- (IBAction)maincategoryTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backToStoreTapped:(id)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

#pragma mark others
//
//- (void)fetchAddressesFromDirectory {
//    NSString *addressArrayPath = [self addressPath];
//    [_addresses removeAllObjects];
//    if ([self ispathExists:addressArrayPath]) {
//        [_addresses addObjectsFromArray:[NSArray arrayWithContentsOfFile:addressArrayPath]];
//    }
//    [_adderssTableView reloadData];
//}
//
//
//- (void)saveArrayTodocumentsDirectory {
//    NSString *addressArrayPath = [self addressPath];
//    if ([self ispathExists:addressArrayPath]) {
//        [_addresses addObjectsFromArray:[NSArray arrayWithContentsOfFile:addressArrayPath]];
//        [self removePath:addressArrayPath];
//    }
//    if (_addresses.count == 5) {
//        [_addresses removeLastObject];
//    }
//    //    [_addresses insertObject:_addressTxtView.text atIndex:0];
//
//    //#warning insert address to file path to save
//
//    NSString *address = [NSString stringWithFormat:@"%@, %@, %@ ,%@ ,%@",_addressline1,_addressline2,_addressCity,_addressState,_addressPincode];
//    [_addresses insertObject:address atIndex:0];
//    [_addresses writeToFile:addressArrayPath atomically:YES];
//}
//
//- (NSString *)documetPath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    return paths[0];
//}
//
//- (NSString *)addressPath {
//    return [[self documetPath] stringByAppendingPathComponent:@"array.out"];
//}
//
//- (BOOL)ispathExists:(NSString *)path {
//    NSFileManager *manager  = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:path]) {
//        return YES;
//    } else {
//        return NO;
//    }
//}
//
//- (void)removePath:(NSString *)path {
//    NSFileManager *manager  = [NSFileManager defaultManager];
//    BOOL isRemoved = [manager removeItemAtPath:path error:nil];
//    if (!isRemoved) {
//        NSLog(@"failed To remove");
//    }
//}

- (void)fetchCurrentLocation {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 if (self.geocoder == nil) {
                                                     self.geocoder = [[CLGeocoder alloc] init];
                                                 }
                                                 if([self.geocoder isGeocoding]) {
                                                     [self.geocoder cancelGeocode];
                                                 }
                                                 [self.geocoder reverseGeocodeLocation: currentLocation completionHandler: ^(NSArray* placemarks, NSError* error)
                                                  {
                                                      if([placemarks count] > 0)
                                                      {
                                                          CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
                                                          self.addressline1.text     = [NSString stringWithFormat:@"%@,%@",foundPlacemark.name,foundPlacemark.thoroughfare];
                                                          self.addressline2.text     = foundPlacemark.subLocality;
                                                          self.addressCity.text      = foundPlacemark.locality;
                                                          self.addressState.text     = foundPlacemark.administrativeArea;
                                                          self.addressPincode.text   = foundPlacemark.postalCode;
                                                          self.addressCountry.text   = foundPlacemark.country;
                                                      }
                                                  }];
                                             }
                                         }];
}


#pragma mark weboperations


- (void)sendOrder {
    NSMutableArray *storeIds = [[NSMutableArray alloc] initWithArray:[self getStoreIdsFromCartItems]];
    
    /* reference
     [{\"storeId\":4,\"list\":[{\"product\":9,\"quantity\":1},{\"product\":10,\"quantity\":1}]},{\"storeId\":13,\"list\":[{\"product\":18,\"quantity\":1}]}]
     */
    
    NSMutableArray *productArray = [NSMutableArray new];
    for (NSNumber *storeId in storeIds) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:storeId forKey:@"storeId"];
        NSArray *items = [self getItesmsForStoreId:storeId];
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:items.count];
        for (Item *item in items) {
            NSDictionary *product = [[NSDictionary alloc] initWithObjectsAndKeys:item.itemId,@"product",item.noOfItems,@"quantity",nil];
            [list addObject:product];
        }
        [dic setObject:items forKey:@"list"];
        [productArray addObject:dic];
    }
    
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:productArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *productJsonString = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    //    NSString *urlStr = [NSString stringWithFormat:@"http://ec2-52-26-37-114.us-west-2.compute.amazonaws.com/Lapanzo/portal?a=order&storeId=1&userId=14&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet&deliveryDate=2016-05-11&deliveryTime=10:55&orderList=%@",jsonString];
    //    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"hh:mm"];
    NSString *timeStr = [formatter stringFromDate:currentDate];
    NSString *urlStr = [NSString stringWithFormat:@"http://ec2-52-26-37-114.us-west-2.compute.amazonaws.com/Lapanzo/portal?a=order&userId=%@&orderList=%@&paymentType=1&deliveryType=%@&contactName=%@&addr1=%@&addr2=%@&area=%@&landmark=%@&deliveryDate=%@&deliveryTime=%@",_client.userId,productJsonString,[NSString stringWithFormat:@"%ld",self.delivaryTypeSgCntrl.selectedSegmentIndex+1],_client.userDetails.userName,_addressline1.text,_addressline2.text,_addressCity.text,[NSString stringWithFormat:@"%@,%@,%@",_addressState.text,_addressCountry.text,_addressPincode.text],dateStr,timeStr];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSString *str = @"http://ec2-52-26-37-114.us-west-2.compute.amazonaws.com/Lapanzo/portal?a=order&userId=14&orderList=[{\"storeId\":4,\"list\":[{\"product\":9,\"quantity\":1},{\"product\":10,\"quantity\":1}]},{\"storeId\":13,\"list\":[{\"product\":18,\"quantity\":1}]}]&paymentType=1&deliveryType=2&contactName=&addr1=&addr2=&area=&landmark=&deliveryDate=2016-06-04&deliveryTime=10:00";
    
    //str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self showHUD];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [self hideHud];
        if (!connectionError) {
            if (!data) {
                NSLog(@"no data");
            } else {
                NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",res);
                if ([[res valueForKey:@"status"] isEqualToString:@"fail"]) {
                    [self showAlert:@"Order" message:[res valueForKey:@"message"]];
                } else {
                    [self showAlert:@"Order" message:@"Your Order has been posted Successfully"];
                    [self performSegueWithIdentifier:@"historySegueId" sender:nil];
                }
            }
        }
    }];
}


- (void)fetchPickUpLocations {
    NSArray *storeIds = [self getStoreIdsFromCartItems];
    if (!storeIds.count) {
        return;
    }
    NSString *storeIdString = [(NSNumber *)storeIds[0] stringValue];
    for (NSNumber *sId  in storeIds) {
        storeIdString = [NSString stringWithFormat:@",%@",sId];
    }
    NSString *url = [NSString stringWithFormat:@"http://52.26.37.114:8080/Lapanzo/portal?a=pickupLocations&storeIdList=%@",storeIdString];
    [_client performOperationWithUrl:url andCompletionHandler:^(NSDictionary *responseObject) {
        NSArray *pickUpLists = responseObject [@"pickupList"];
        _pickups = [NSMutableArray arrayWithArray:pickUpLists];
        [self.tableView reloadData];
    } failure:^(NSError *connectionError) {
        [self showAlert:@"Pick up" message:connectionError.localizedDescription];
    }];
}

//- (void)performSendOrder {
//    //    NSString *urlStr = [NSString stringWithFormat:@"portal?a=order&storeId=1&userId=14&list=%@&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet",_cartItems];
//
//    NSString *urlStr = [NSString stringWithFormat:@"portal?a=order&storeId=1&userId=14&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet"];
//
//    //deliveryType – 1 means HOME DELIVERY, 2 means TAKE AWAY
//    //    paymentType – 1 means CASH ON DELIVERY, 2 means ONLINE PAYMENT
//
//    [self showHUD];
//
//
//    [_client performPostOperationWithUrl:urlStr andParams:_cartItems andCompletionHandler:^(NSDictionary *responseObject) {
//
//        [self hideHud];
//        if ([responseObject.status isEqualToString:@"fail"]) {
//            [self showAlert:@"Proceed" message:responseObject.message];
//        } else {
//            //"a":"orderAck","status":"success","ack":"SBPC2015072445503994","orderno":"7","branchid":1,"amount":557.96
//            NSString *message = [NSString stringWithFormat:@"Order has been suceess. Ack Id : %@ , Amount : %@",responseObject[@"ack"],responseObject[@"amount"]];
//            [self showAlert:nil message:message];
//            [self performSegueWithIdentifier:@"historySegueId" sender:nil];
//        }
//
//    } failure:^(NSError * _Nullable connectionError) {
//        [self hideHud];
//        [self showAlert:nil message:connectionError.localizedDescription];
//    }];
//
//    //    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
//    //        [self hideHud];
//    //        if ([responseObject.status isEqualToString:@"fail"]) {
//    //            [self showAlert:@"Proceed" message:responseObject.message];
//    //        } else {
//    //            //"a":"orderAck","status":"success","ack":"SBPC2015072445503994","orderno":"7","branchid":1,"amount":557.96
//    //            NSString *message = [NSString stringWithFormat:@"Order has been suceess. Ack Id : %@ , Amount : %@",responseObject[@"ack"],responseObject[@"amount"]];
//    //            [self showAlert:nil message:message];
//    //            [self performSegueWithIdentifier:@"historySegueId" sender:nil];
//    //        }
//    //    } failure:^(NSError *connectionError) {
//    //        [self hideHud];
//    //        [self showAlert:nil message:connectionError.localizedDescription];
//    //    }];
//}

#pragma mark TextField Delegate

- (void)resign {
    [self.view endEditing:YES];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (textField == _deliverTime) {
//        
//        [self resign];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
//        dateFormatter.timeStyle = NSDateFormatterNoStyle;
//        
//        NSDate *initDate = [dateFormatter dateFromString:_deliverTime.text];
//        [_popDatePicker pick:self initDate:initDate dataChanged:^(NSDate  *newDate, UITextField  *textField) {
//            // here we don't use self (no retain cycle)
//            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.dateStyle = NSDateFormatterMediumStyle;
//            formatter.timeStyle = NSDateFormatterNoStyle;
//            //return formatter.stringFromDate(self)
//            
//            self.deliverTime.text = [formatter stringFromDate:newDate];
//        }];
//        return YES;
//    } else {
//        return NO;
//    }
//}

#pragma mark Others

- (NSArray *)getStoreIdsFromCartItems {
    NSMutableArray *storeIds = [[NSMutableArray alloc] init];
    for (Item *itm in _cartItems) {
        [storeIds addObject:itm.storeId];
    }
    NSSet *storeIdSet = [[NSSet alloc] initWithArray:storeIds];
    storeIds = [[NSMutableArray alloc] initWithArray:[storeIdSet allObjects]];
    return storeIds;
}

- (void)clearAllFields {
    self.addressline1.text = @"";
    self.addressline2.text = @"";
    self.addressCity.text  = @"";
    self.addressState.text = @"";
    self.addressCountry.text = @"";
    self.addressPincode.text = @"";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
