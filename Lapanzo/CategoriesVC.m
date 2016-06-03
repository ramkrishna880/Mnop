//
//  CategoriesVC.m
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "CategoriesVC.h"
#import "VendorCollectionViewCell.h"
#import "Constants.h"
#import "StoresVC.h"
#import "StoreDetailVC.h"
#import "INTULocationManager.h"
#import "UIColor+Helpers.h"
#import "UIViewController+Helpers.h"
//#import "UIButton+UIButtonExt.h"
//#import <LMAlertView.h>
#import "LCollectionViewFlowLayout.h"
#import "ORNavigationBar.h"
#import "SearchViewController.h"

@interface CategoriesVC ()<UICollectionViewDataSource, UICollectionViewDelegate, ManualSelectionControllerDelegate>

@property (nonatomic) Lapanzo_Client *client;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *categories;

@property (nonatomic, weak) IBOutlet UILabel             *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel             *periodLabel;
@property (nonatomic, weak) IBOutlet UILabel             *temparatureLabel;
@property (nonatomic, weak) IBOutlet UIImageView         *dayOrNightImg;
@property (nonatomic, weak) IBOutlet UILabel             *wishLabel;
@property (nonatomic, weak) IBOutlet UILabel             *nameLabel;

@property (nonatomic, weak) IBOutlet UIButton            *locationBtn;

//@property (nonatomic, weak) IBOutlet UILabel             *quoteLabel;
//@property (nonatomic, weak) IBOutlet UILabel             *locationtypeLbl;
//@property (nonatomic, weak) IBOutlet UISwitch            *locationSwitch;

@property (nonatomic) BOOL                               isManualLoaction;
//@property (nonatomic, weak) IBOutlet UIButton *firstVendor;
//@property (nonatomic, weak) IBOutlet UILabel *firstVendorName;
//@property (nonatomic, weak) IBOutlet UIImageView *firstVendorImg;
@end

@implementation CategoriesVC


#pragma mark ViewlifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpinitialElements];
}

- (void)setUpinitialElements {
    _client = [Lapanzo_Client sharedClient];
    //    [_client setCartItems:nil];
    [self homeButton];
    [self setNavigationBarTintColor:[UIColor navigationBarTintColor]];
    [self.navigationController setValue:[[ORNavigationBar alloc]init]  forKeyPath:@"navigationBar"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBarButtonView]];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    LCollectionViewFlowLayout *flowLayout = [[LCollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)]; //previously 120
    //[flowLayout setSectionInset:UIEdgeInsetsMake(10, 5, 5, 10)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.rowColors = @[[UIColor collectionCellGreen],[UIColor collectionCellGray]];
    [_collectionView setCollectionViewLayout:flowLayout];
    
    
    self.isManualLoaction = NO;
    [self fetchCurrentLOcation];
//    [self fetchCategories];
    [self fetchStoreSubcategories];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cartLabel.text = @(_client.cartItemsCount).stringValue;
    
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    BOOL isManualLocation = [def boolForKey:ISMANUALLOCATION];
}


// Samplept
- (void)fetchStoreSubcategories {
    [self showHUD];
    //    3
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=subcatogory&storeId=%@",@"1"];
    //NSString *urlStr = @"portal?a=subcatogory&storeId=1";
    [_client performOperationWithUrl:urlStr andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *subCategories = responseObject[@"list"];
        
        if (subCategories.count) {
            
            NSDictionary *sampleDic = subCategories[0];
            [self performSendOrder:sampleDic[@"list"]];
        }else {
            [self showAlert:nil message:@"No List Found"];
        }
        
        
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}


- (void)performSendOrder:(NSArray *)items {
    //    NSString *urlStr = [NSString stringWithFormat:@"portal?a=order&storeId=1&userId=14&list=%@&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet",_cartItems];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i<items.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSDictionary *valDic = items[i];
        [dic setObject:valDic [@"id"] forKey:@"product"];
        [dic setObject:@"3" forKey:@"quantity"];
        [array addObject:dic];
        }
    NSString *urlStr = [NSString stringWithFormat:@"http://ec2-52-26-37-114.us-west-2.compute.amazonaws.com/Lapanzo/portal?a=order&storeId=1&userId=14&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet&deliveryDate=2016-05-11&deliveryTime=10:55"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:jsonData forKey:@"list"];
//    [request setval]

//    [request setValue:jsonData forHTTPHeaderField:@"list"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
       
        if (!connectionError) {
             NSLog(@"%@",res);
        } 
    }];
    
////    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:items options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"portal?a=order&storeId=1&userId=14&deliveryType=1&paymentType=1&contactName=ramki&addr1=ameerpet&area=ameerpet&deliveryDate=2016-05-11&deliveryTime=10:55"];
//    //YYYY-MM-dd HH:mm
//    
//    //deliveryType – 1 means HOME DELIVERY, 2 means TAKE AWAY
//    //    paymentType – 1 means CASH ON DELIVERY, 2 means ONLINE PAYMENT
//    
//    [self showHUD];
//    
//    
//    [_client performPostOperationWithUrl:urlStr andParams:array andCompletionHandler:^(NSDictionary *responseObject) {
//        
//        [self hideHud];
//        if ([responseObject.status isEqualToString:@"fail"]) {
//            [self showAlert:@"Proceed" message:responseObject.message];
//        } else {
//            //"a":"orderAck","status":"success","ack":"SBPC2015072445503994","orderno":"7","branchid":1,"amount":557.96
//            NSString *message = [NSString stringWithFormat:@"Order has been suceess. Ack Id : %@ , Amount : %@",responseObject[@"ack"],responseObject[@"amount"]];
//            [self showAlert:nil message:message];
//            //[self performSegueWithIdentifier:@"historySegueId" sender:nil];
//        }
//        
//    } failure:^(NSError * _Nullable connectionError) {
//        [self hideHud];
//        [self showAlert:nil message:connectionError.localizedDescription];
//    }];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAllLableValues];
}

- (void)setAllLableValues {
    NSDate *currrentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    self.timeLabel.text = [dateFormatter stringFromDate:currrentDate];
    [dateFormatter setDateFormat:@"a"];
    self.periodLabel.text = [dateFormatter stringFromDate:currrentDate];
    
    NSDictionary *user = _client.userDetails;
    NSString *message;
    [dateFormatter setDateFormat:@"hh a"];
    NSString *str = [dateFormatter stringFromDate:currrentDate];
    NSArray *array = [str componentsSeparatedByString:@" "];
    NSString *timeInHour = array[0];
    NSString *am_pm      = array[1];
    
    if([timeInHour integerValue] < 12 && [am_pm isEqualToString:@"AM"]) {
        message = @"Good Morning";
        [self.dayOrNightImg setImage:[UIImage imageNamed:@"day"]];
    } else if ([timeInHour integerValue] <= 4 && [am_pm isEqualToString:@"PM"]) {
        message = @"Good Afternoon";
        [self.dayOrNightImg setImage:[UIImage imageNamed:@"day"]];
    } else if ([timeInHour integerValue] > 4 && [am_pm isEqualToString:@"PM"]) {
        message = @"Good Night";
        [self.dayOrNightImg setImage:[UIImage imageNamed:@"night"]];
    }
    _wishLabel.text = message;
    _nameLabel.text = user.userName;
    //_quoteLabel.text = @"Hello this is Random Quote";
}


#pragma mark CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categories.count;  //previously _categories.count-1
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VendorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VENDOR_COLLECCELLID forIndexPath:indexPath];
    cell.vendor = _categories [indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:STORE_SEGUE sender:_categories[indexPath.row]]; //prev indexpath.row+1
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (_collectionView.frame.size.width)/3;
    return CGSizeMake(width, width);
}

#pragma mark Webops

- (void)fetchCategories {
    [self showHUD];
    [_client performOperationWithUrl:@"portal?a=options" andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *vendors = responseObject[@"venderList"];
        if (vendors.count) {
            self.categories = [[NSMutableArray alloc] initWithArray:vendors];
            //[self setFirstVendor];
            [self.collectionView reloadData];
        } else {
            [self showAlert:nil message:@"No vendors Found"];
        }
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}


- (void)fetchWeatherDetails:(NSString *)city {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"api.openweathermap.org/data/2.5/weather?q=%@&appid=%@",city,WEATHERAPIKEY]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (!connectionError) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString *temp = [responseDic valueForKeyPath:@"main.temp"];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterNoStyle;
            NSNumber *myNumber = [f numberFromString:temp];
            float fharanHeatValue = myNumber.floatValue;
            fharanHeatValue = (fharanHeatValue - 32)*0.555;
            self.temparatureLabel.text = [NSString stringWithFormat:@"%f",fharanHeatValue];
        }
    }];
}

#pragma mark Actions

- (IBAction)zeroCategorySelected:(id)sender {
    if (_categories.count) {
        [self performSegueWithIdentifier:STORE_SEGUE sender:_categories[0]];
    }
}


//- (IBAction)switchChanged:(UISwitch *)sender {
//    if (sender.on) {
//        [self fetchCurrentLOcation];
//    } else {
//        [self manualLocationTapped:nil];
//    }
//}

- (IBAction)manualLocationTapped:(id)sender {
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SearchViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:SEARCHM_SEGUEID];
//    //svc.view.alpha = 0.5;
//    svc.selectionDelegate = self;
//    svc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:svc animated:NO completion:nil];
    
    [self performSegueWithIdentifier:SEARCH_SEGUEID sender:nil];
}

#pragma mark Others

- (void)fetchCurrentLOcation {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
                                                 [geoCoder reverseGeocodeLocation:currentLocation
                                                                completionHandler:^(NSArray *placemarks, NSError *error) {
                                                                    
                                                                    CLPlacemark *place = placemarks[0];
                                                                    NSString *cityNameCode = [NSString stringWithFormat:@"%@,%@",place.locality,place.ISOcountryCode];
                                                                    [self fetchWeatherDetails:cityNameCode];
                                                                }];
                                                 [_client setLocationLatitude:currentLocation.coordinate.latitude logitude:currentLocation.coordinate.longitude];
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 [self showAlert:nil message:@"Request for location timed out"];
                                             }
                                             else {
                                             }
                                         }];
}


#pragma mark ManualSelectionDelegate

- (void)didManualLocationSelected:(BOOL)isManual {
    
//    if (isManual) {
//        [_locationSwitch setOn:NO];
//        _locationtypeLbl.text = @"Manual Location";
//    } else {
//        [_locationSwitch setOn:YES];
//        _locationtypeLbl.text = @"Current Location";
//    }
//    self.isManualLoaction = isManual;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:STORE_SEGUE]) {
        StoresVC *storeVc = (StoresVC *)segue.destinationViewController;
        storeVc.vendorId = ((NSDictionary *)sender).vendorId;
        storeVc.useCurrentLocation = !_isManualLoaction;
    } else if ([segue.identifier isEqualToString:SEARCH_SEGUEID]) {
        SearchViewController *searchVc = (SearchViewController *)segue.destinationViewController;
        searchVc.selectionDelegate = self;
    }
}


@end
