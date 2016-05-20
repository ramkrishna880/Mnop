//
//  StoresVC.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "StoresVC.h"
#import "Constants.h"
#import "StoresTableViewCell.h"
#import "CategoryCollectionViewCell.h"
#import "Constants.h"
#import "Lapanzo_Client+DataAccess.h"
#import "NSDictionary+Response.h"
#import "UIColor+Helpers.h"
//#import "UIViewController+Helpers.h"
#import "SWRevealViewController.h"
#import "Store.h"
#import "StoreDetailVC.h"


@interface StoresVC () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) UISearchController *searchController;
@property (nonatomic, weak) IBOutlet UIView *searchHolder;

@property (nonatomic) Lapanzo_Client *client;

@property (nonatomic) NSMutableArray *stores;
@property (nonatomic) NSMutableArray *searchedStores;
@end

@implementation StoresVC

#pragma mark View lifecycle & like

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialUIElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpInitialUIElements {
    _client = [Lapanzo_Client sharedClient];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBarButtonView]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftBarbuttonView]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:STORE_COLLCCELLID];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(150, 120)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];//top/left/bottem/right
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 10.0f;
    [_collectionView setCollectionViewLayout:flowLayout];
    
    [self fetchStoresforUrlString:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cartLabel.text = @(_client.cartItemsCount).stringValue;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        self.definesPresentationContext = true;
        _searchController.dimsBackgroundDuringPresentation = false;
        [self.searchController.searchBar setPlaceholder:@"Do you have any store in mind"];
        [self.searchController.searchBar setBarTintColor:[UIColor blackColor]];
        [self.searchController.searchBar setTintColor:[UIColor navigationBarTintColor]];
        [self.searchController.searchBar sizeToFit];
        _searchController.searchBar.frame = _searchHolder.bounds;
        [self.searchHolder addSubview:_searchController.searchBar];
    }
}

- (void)dealloc {
    [_searchController.view removeFromSuperview];
}

#pragma mark CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.searchController.active && _searchController.searchBar.text.length) {
        return _searchedStores.count;
    } else {
        return _stores.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    CategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:STORE_COLLCCELLID forIndexPath:indexPath];
    if (self.searchController.active && _searchController.searchBar.text.length) {
        cell.currentStore = _searchedStores[indexPath.row];
    } else {
        cell.currentStore = _stores[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active && _searchController.searchBar.text.length) {
        [self performSegueWithIdentifier:STOREDETAIL_SEGUEID sender:_searchedStores[indexPath.row]];
    } else {
        [self performSegueWithIdentifier:STOREDETAIL_SEGUEID sender:_stores[indexPath.row]];
    }
}

#pragma mark SearchController delegate

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [self.searchedStores removeAllObjects];
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"storeName  contains [c] %@", searchText];//LIKE
    self.searchedStores = [NSMutableArray arrayWithArray: [self.stores filteredArrayUsingPredicate:resultPredicate]];
    [self.collectionView reloadData];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    [self filterContentForSearchText:searchBar.text scope:@"All"];
}


#pragma mark WebOperations


- (void)fetchStoresforUrlString:(BOOL)useCurrentLocation {
    
//    if (!useCurrentLocation) {
//        NSDictionary *dic = _client.manualLocation;
//        NSString *url = [NSString stringWithFormat:@"portal?a=search&area=%@&city=%@&vtype=%@",dic[CITYKEY],dic[AREAKEY],_vendorId];
//    } else {
//        NSDictionary *dic = _client.locationDetails;
//        NSString *url = [NSString stringWithFormat:@"portal?a=showNear&lat=%@&lan=%@&vtype=%@",dic[LATITUDEKEY],dic[LOGITUDEKEY],_vendorId];
//    }
    
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=search&area=Madhapur&city=Hyderabad&vtype=%@",_vendorId]; //
    [self showHUD];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *vendors = responseObject[@"result"];
        if (vendors.count) {
            NSMutableArray *tempStores = [[NSMutableArray alloc] init];
            [vendors enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempStores addObject:[[Store alloc] initStorewithDictionary:obj]];
            }];
            _stores = [[NSMutableArray alloc] initWithArray:tempStores copyItems:NO];
            [self.collectionView reloadData];
        } else {
            [self showAlert:nil message:@"No Stores Found"];
        }
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}



#pragma mark Others

- (UIView *)leftBarbuttonView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [homeButton setFrame:CGRectMake(5, 5, 30, 30)];
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [homeButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:homeButton];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setFrame:CGRectMake(45, 5, 30, 30)];
    [back addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:back];
    return v;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Store *)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:STOREDETAIL_SEGUEID]) {
        StoreDetailVC *storeDetail = (StoreDetailVC *)segue.destinationViewController;
        storeDetail.storeId = sender.storeId;
        storeDetail.vendorType = [self findTypeOfVendor];
        //        storeDetail.storeId = _vendorId;
    }
}


- (kVendorType)findTypeOfVendor {
    NSUInteger vendorId = _vendorId.integerValue;
    kVendorType vendorType;
    if (vendorId == 3) {
        vendorType = kVendorTypeWater;
    } else if (vendorId == 4) {
        vendorType = kVendorTypeFlower;
    } else if (vendorId == 9) {
        vendorType = kVendorTypeHOmeServices;
    } else {
        vendorType = kVendorTypeGeneral;
    }
    return vendorType;
}

//@@// old one
//- (void)fetchCategories {
//    //@"portal?a=maincatogory&storeId=1
//    [self showHUD];
//    NSString *urlStr = [NSString stringWithFormat:@"portal?a=maincatogory&storeId=%@",_vendorId];
//    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
//        [self hideHud];
//        NSArray *vendors = responseObject[@"list"];
//        if (vendors.count) {
//            NSMutableArray *tempStores = [[NSMutableArray alloc] init];
//            [vendors enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [tempStores addObject:[[Store alloc] initStorewithDictionary:obj]];
//            }];
//            _stores = [[NSMutableArray alloc] initWithArray:tempStores copyItems:NO];
//            [self.collectionView reloadData];
//        } else {
//            [self showAlert:nil message:@"No Stores Found"];
//        }
//    } failure:^(NSError *connectionError) {
//        [self hideHud];
//        [self showAlert:nil message:connectionError.localizedDescription];
//    }];
//}
//@@//
@end
