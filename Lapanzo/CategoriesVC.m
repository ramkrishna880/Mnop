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

@interface CategoriesVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) Lapanzo_Client *client;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *categories;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *periodLabel;
@property (nonatomic, weak) IBOutlet UILabel *temparatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *quoteLabel;

@property (nonatomic, weak) IBOutlet UILabel *firstVendorName;
@property (nonatomic, weak) IBOutlet UIImageView *firstVendorImg;
@end

@implementation CategoriesVC


#pragma mark ViewlifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpinitialElements];
}

- (void)setUpinitialElements {
    _client = [Lapanzo_Client sharedClient];
    [self fetchCategories];
}

- (void)setallLableValues {
    NSDate *currrentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
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
        message = [NSString stringWithFormat:@"Good Morning \r %@",user.userName];
    } else if ([timeInHour integerValue] <= 4 && [am_pm isEqualToString:@"PM"]) {
        message = [NSString stringWithFormat:@"Good Afternoon \r %@",user.userName];
    } else if ([timeInHour integerValue] > 4 && [am_pm isEqualToString:@"PM"]) {
        message = [NSString stringWithFormat:@"Good Night \r %@",user.userName];
    }
    _nameLabel.text = message;
    _quoteLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categories.count-1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VendorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VENDOR_COLLECCELLID forIndexPath:indexPath];
    cell.vendor = _categories [indexPath.row+1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:STORE_SEGUE sender:_categories[indexPath.row]]; // Add sender In future
}

#pragma mark Webops

- (void)fetchCategories {
    [_client performOperationWithUrl:@"portal?a=options" andCompletionHandler:^(NSDictionary *responseObject) {
        NSArray *vendors = responseObject[@"venderList"];
        if (vendors.count) {
            self.categories = [[NSMutableArray alloc] initWithArray:vendors];
            [self setFirstVendor];
            [self.collectionView reloadData];
        } else {
            [self showAlert:nil message:@"No vendors Found"];
        }
    } failure:^(NSError *connectionError) {
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}


- (void)setFirstVendor {
    _firstVendorImg.image = [UIImage imageNamed:@""];
    NSDictionary *venDic = _categories[0];
    _firstVendorName.text = venDic.vendor;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:STORE_SEGUE]) {
        StoresVC *storeVc = (StoresVC *)segue.destinationViewController;
        storeVc.vendorId = ((NSDictionary *)sender).vendorId;
    }
}


@end
