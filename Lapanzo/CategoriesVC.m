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
@property (nonatomic, weak) IBOutlet UIImageView *dayOrNightImg;
@property (nonatomic, weak) IBOutlet UILabel *wishLabel;
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
    //Vendor Id
    
}

- (void)setUpinitialElements {
    _client = [Lapanzo_Client sharedClient];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 10, 10, 10)];//top/left/bottem/right
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 10.0f;
    [_collectionView setCollectionViewLayout:flowLayout];
    
    [self fetchCategories];
    //    [self setallLableValues];
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
    _quoteLabel.text = @"Hello this is Random Quote";
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
    [self performSegueWithIdentifier:STORE_SEGUE sender:_categories[indexPath.row+1]]; // Add sender In future
}

#pragma mark Webops

- (void)fetchCategories {
    [self showHUD];
    [_client performOperationWithUrl:@"portal?a=options" andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *vendors = responseObject[@"venderList"];
        if (vendors.count) {
            self.categories = [[NSMutableArray alloc] initWithArray:vendors];
            [self setFirstVendor];
            [self.collectionView reloadData];
        } else {
            [self showAlert:nil message:@"No vendors Found"];
        }
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}


- (void)setFirstVendor {
    //_firstVendorImg.image = [UIImage imageNamed:@""];
    NSDictionary *venDic = _categories[0];
    _firstVendorName.text = venDic.vendor;
}


#pragma mark Actions

- (IBAction)zeroCategorySelected:(id)sender {
    if (_categories.count) {
        [self performSegueWithIdentifier:STORE_SEGUE sender:_categories[0]];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:STORE_SEGUE]) {
        StoresVC *storeVc = (StoresVC *)segue.destinationViewController;
        storeVc.vendorId = ((NSDictionary *)sender).vendorId;
    }
}


@end
