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
#import "Store.h"

@import MapKit;

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:STORE_COLLCCELLID];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 10, 10, 10)];//top/left/bottem/right
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 10.0f;
    [_collectionView setCollectionViewLayout:flowLayout];
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
        //[self.searchController.searchBar setBarTintColor:[UIColor cellSelectColor]];
        [self.searchController.searchBar sizeToFit];
        _searchController.searchBar.frame = _searchHolder.bounds;
        [self.searchHolder addSubview:_searchController.searchBar];
    }
}

#pragma mark CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    CategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:STORE_COLLCCELLID forIndexPath:indexPath];
    return cell;
}

#pragma mark SearchController delegate

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [self.searchedStores removeAllObjects];
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"countryName  contains [c] %@", searchText];//LIKE
    self.searchedStores = [NSMutableArray arrayWithArray: [self.stores filteredArrayUsingPredicate:resultPredicate]];
    [self.collectionView reloadData];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    [self filterContentForSearchText:searchBar.text scope:@"All"];
}


#pragma mark WebOperations

- (void)fetchCategories {
    //@"portal?a=maincatogory&storeId=1
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=maincatogory&storeId=%@",_vendorId];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        NSArray *vendors = responseObject[@"list"];
        if (vendors.count) {
            NSMutableArray *tempStores = [[NSMutableArray alloc] init];
            [vendors enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempStores addObject:[[Store alloc] initStorewithDictionary:obj]];
            }];
            _stores = [[NSMutableArray alloc] initWithArray:tempStores copyItems:NO];
            [self.collectionView reloadData];
        } else {
            [self showAlert:nil message:@"No vendors Found"];
        }
    } failure:^(NSError *connectionError) {
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
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