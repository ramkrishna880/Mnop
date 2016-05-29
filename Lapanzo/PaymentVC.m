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
#import "Lapanzo-Swift.h"
#import "UIViewController+Helpers.h"


@interface PaymentVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>\
@property (nonatomic) Lapanzo_Client *client;
@property (nonatomic) IBOutlet UILabel *amountLabel;


@property (nonatomic, weak) IBOutlet UITableView *adderssTableView;
@property (nonatomic, weak) IBOutlet UIView *locationView;
@property (nonatomic, weak) IBOutlet UIView *enterAddressView;
@property (nonatomic, weak) IBOutlet UILabel *locationValLbl;
//@property (nonatomic, weak) IBOutlet UITextView *addressTxtView;
@property (nonatomic, weak) IBOutlet UITextField *deliverTime;

@property (nonatomic, weak) IBOutlet UITextField *addressline1;
@property (nonatomic, weak) IBOutlet UITextField *addressline2;
@property (nonatomic, weak) IBOutlet UITextField *addressCity;
@property (nonatomic, weak) IBOutlet UITextField *addressState;
@property (nonatomic, weak) IBOutlet UITextField *addressPincode;


@property (nonatomic) NSMutableArray *addresses;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (nonatomic , strong) NSString *addressString;
@property (nonatomic) PopDatePicker *popDatePicker;
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
    self.adderssTableView.estimatedRowHeight = 70;
    self.adderssTableView.rowHeight = UITableViewAutomaticDimension;
    _addresses = [[NSMutableArray alloc] init];
    
    [_locationValLbl.layer setBorderWidth:1.0f];
    [_locationValLbl.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
//    [_addressTxtView.layer setBorderWidth:1.0f];
//    [_addressTxtView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    _popDatePicker = [[PopDatePicker alloc] initForTextField:_deliverTime];
    _amountLabel.text = _totalPrice;
}



#pragma mark UItableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_addresses.count) {
        return 1;
    } else {
        return _addresses.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYMENTHIS_TABLECELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PAYMENTHIS_TABLECELLID];
    }
    cell.textLabel.numberOfLines = 0;
    
    if (!_addresses.count) {
        cell.textLabel.text = @"No Addresses Found";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.textLabel.text = _addresses[indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showAlert:@"You have Picked" message:_addresses[indexPath.row]];
}


#pragma mark Ui Actions

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    NSUInteger tag = sender.selectedSegmentIndex;
    switch (tag) {
        case kAddressTypeAttach:
        {
            [_locationView setHidden:NO];
            [_enterAddressView setHidden:YES];
            [_adderssTableView setHidden:YES];
        }
            break;
            
        case kAddressTypeEnter:
        {
            [_locationView setHidden:YES];
            [_enterAddressView setHidden:NO];
            [_adderssTableView setHidden:YES];
        }
            break;
        case kAddressTypeHistory:
        {
            [_locationView setHidden:YES];
            [_enterAddressView setHidden:YES];
            [_adderssTableView setHidden:NO];
            [self fetchAddressesFromDirectory];
        }
            break;
            
        default:
            break;
            
    }
}

- (IBAction)attachLocationTapped:(id)sender {
    [self fetchCurrentLocation];
}


- (IBAction)sendOrderTapped:(id)sender {
    
}


- (IBAction)maincategoryTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backToStoreTapped:(id)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

#pragma mark others

- (void)fetchAddressesFromDirectory {
    NSString *addressArrayPath = [self addressPath];
    [_addresses removeAllObjects];
    if ([self ispathExists:addressArrayPath]) {
        [_addresses addObjectsFromArray:[NSArray arrayWithContentsOfFile:addressArrayPath]];
    }
    [_adderssTableView reloadData];
}


- (void)saveArrayTodocumentsDirectory {
    NSString *addressArrayPath = [self addressPath];
    if ([self ispathExists:addressArrayPath]) {
        [_addresses addObjectsFromArray:[NSArray arrayWithContentsOfFile:addressArrayPath]];
        [self removePath:addressArrayPath];
    }
    if (_addresses.count == 5) {
        [_addresses removeLastObject];
    }
//    [_addresses insertObject:_addressTxtView.text atIndex:0];
    
//#warning insert address to file path to save
    
    NSString *address = [NSString stringWithFormat:@"%@, %@, %@ ,%@ ,%@",_addressline1,_addressline2,_addressCity,_addressState,_addressPincode];
    [_addresses insertObject:address atIndex:0];
    [_addresses writeToFile:addressArrayPath atomically:YES];
}

- (NSString *)documetPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return paths[0];
}

- (NSString *)addressPath {
    return [[self documetPath] stringByAppendingPathComponent:@"array.out"];
}

- (BOOL)ispathExists:(NSString *)path {
    NSFileManager *manager  = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)removePath:(NSString *)path {
    NSFileManager *manager  = [NSFileManager defaultManager];
    BOOL isRemoved = [manager removeItemAtPath:path error:nil];
    if (!isRemoved) {
        NSLog(@"failed To remove");
    }
}

- (void)fetchCurrentLocation {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 
                                                 if (self.geocoder == nil)
                                                 {
                                                     self.geocoder = [[CLGeocoder alloc] init];
                                                 }
                                                 
                                                 if([self.geocoder isGeocoding])
                                                 {
                                                     [self.geocoder cancelGeocode];
                                                 }
                                                 
                                                 [self.geocoder reverseGeocodeLocation: currentLocation
                                                                     completionHandler: ^(NSArray* placemarks, NSError* error)
                                                  {
                                                      if([placemarks count] > 0)
                                                      {
                                                          CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
                                                          NSLog(@"%@",foundPlacemark);
                                                          self.locationValLbl.text = @"";  // update info here in future
                                                      }
                                                  }];
                                                 
                                             }
                                         }];
}


#pragma mark weboperations

- (void)performSendOrder {
//    NSString *urlStr = [NSString stringWithFormat:@"portal?a=order&storeId=1&userId=14&list=%@&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet",_cartItems];
    
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=order&storeId=1&userId=14&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet"];
    
    //deliveryType – 1 means HOME DELIVERY, 2 means TAKE AWAY
    //    paymentType – 1 means CASH ON DELIVERY, 2 means ONLINE PAYMENT
    
    [self showHUD];
    
    
    [_client performPostOperationWithUrl:urlStr andParams:_cartItems andCompletionHandler:^(NSDictionary *responseObject) {
        
        [self hideHud];
        if ([responseObject.status isEqualToString:@"fail"]) {
            [self showAlert:@"Proceed" message:responseObject.message];
        } else {
            //"a":"orderAck","status":"success","ack":"SBPC2015072445503994","orderno":"7","branchid":1,"amount":557.96
            NSString *message = [NSString stringWithFormat:@"Order has been suceess. Ack Id : %@ , Amount : %@",responseObject[@"ack"],responseObject[@"amount"]];
            [self showAlert:nil message:message];
            [self performSegueWithIdentifier:@"historySegueId" sender:nil];
        }
        
    } failure:^(NSError * _Nullable connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
    
//    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
//        [self hideHud];
//        if ([responseObject.status isEqualToString:@"fail"]) {
//            [self showAlert:@"Proceed" message:responseObject.message];
//        } else {
//            //"a":"orderAck","status":"success","ack":"SBPC2015072445503994","orderno":"7","branchid":1,"amount":557.96
//            NSString *message = [NSString stringWithFormat:@"Order has been suceess. Ack Id : %@ , Amount : %@",responseObject[@"ack"],responseObject[@"amount"]];
//            [self showAlert:nil message:message];
//            [self performSegueWithIdentifier:@"historySegueId" sender:nil];
//        }
//    } failure:^(NSError *connectionError) {
//        [self hideHud];
//        [self showAlert:nil message:connectionError.localizedDescription];
//    }];
}

#pragma mark TextField Delegate

- (void)resign {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _deliverTime) {
        
        [self resign];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        
        NSDate *initDate = [dateFormatter dateFromString:_deliverTime.text];
        [_popDatePicker pick:self initDate:initDate dataChanged:^(NSDate  *newDate, UITextField  *textField) {
            // here we don't use self (no retain cycle)
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateStyle = NSDateFormatterMediumStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            //return formatter.stringFromDate(self)
            
            self.deliverTime.text = [formatter stringFromDate:newDate];
        }];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
