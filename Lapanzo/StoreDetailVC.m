//
//  StoreDetailVC.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "StoreDetailVC.h"
#import "Constants.h"
#import "StoresTableViewCell.h"
#import "HTHorizontalSelectionList.h"
#import "Lapanzo_Client+DataAccess.h"
#import "Subcategory.h"
#import "UIColor+Helpers.h"

@interface StoreDetailVC () <UITableViewDataSource, UITableViewDelegate,HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate, UISearchResultsUpdating, UISearchBarDelegate> {
    //NSUInteger currentSubcategory;
}
@property (nonatomic) UISearchController *searchController;
@property (nonatomic) IBOutlet UIImageView *storeImage;
@property (nonatomic) IBOutlet UIView *tabsPlaceHolder;
@property (nonatomic) IBOutlet UIView *searchPlaceHolder;
@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) Lapanzo_Client *client;

@property (nonatomic) HTHorizontalSelectionList *tabs;
@property (nonatomic) NSArray *subCategories;

@property (nonatomic, assign) NSUInteger index;
@end

@implementation StoreDetailVC

#pragma mark ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    [self setUpInitialUIelements];
}


- (void)setUpInitialUIelements {
    _client = [Lapanzo_Client sharedClient];
    
    UISwipeGestureRecognizer *tableSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedOntableView:)];
    tableSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:tableSwipeGesture];
    
    [self fetchStoreSubcategories];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.tabs) {
        self.tabs = [[HTHorizontalSelectionList alloc] initWithFrame:self.tabsPlaceHolder.bounds];
        _tabs.delegate = self;
        _tabs.dataSource = self;
        //_selectionList.selectionIndicatorColor = [UIColor navBarTintColor];
        [_tabs setTitleColor:[UIColor colorFromRGBforRed:55.0 blue:57.0 green:80.0] forState:UIControlStateNormal];
        //[_selectionList setTitleColor:[UIColor navBarTintColor] forState:UIControlStateHighlighted];
        [_tabs setTitleFont:[UIFont boldSystemFontOfSize:18.0] forState:UIControlStateNormal];
        [self.tabsPlaceHolder addSubview:_tabs];
    }
    
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        self.definesPresentationContext = true;
        _searchController.dimsBackgroundDuringPresentation = false;
        [self.searchController.searchBar setPlaceholder:@"Are you looking for any product ?"];
        //[self.searchController.searchBar setBarTintColor:[UIColor cellSelectColor]];
        [self.searchController.searchBar sizeToFit];
        _searchController.searchBar.frame = _searchPlaceHolder.bounds;
        [self.searchPlaceHolder addSubview:_searchController.searchBar];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Subcategory *sbCat = _subCategories[_index];
    return sbCat.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STORES_TABLECELLID];
    if (!cell) {
        cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STORES_TABLECELLID];
    }
    Subcategory *sbCat = _subCategories [indexPath.section];
    Item *crntItem =  sbCat.items [indexPath.row];
    cell.currentItem = crntItem;
    
    //http://stackoverflow.com/questions/31063571/getting-indexpath-from-switch-on-uitableview
    
    return cell;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleNone;
//}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.subCategories.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    Subcategory *sc = self.subCategories[index];
    return sc.subCategoryName;
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    // update the view for corresponding index
    _index = index;
    [self.tableView reloadData];
}


#pragma mark Actions
- (IBAction)mainCatogoryAction:(id)sender {
    
}

- (IBAction)storesButtonTapped:(id)sender {
    
}

- (IBAction)goToCartClicked:(id)sender {
    
}

- (void)swipedOntableView:(UISwipeGestureRecognizer *)gesture {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_index<_subCategories.count) {
            _index++;
        }
        transition.subtype = kCATransitionFromRight;
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_index>0) {
            _index--;
        }
        transition.subtype = kCATransitionFromLeft;
    } else {
        return;
    }
    [self.tableView.layer addAnimation:transition forKey:nil];
    [self.tabs setSelectedButtonIndex:_index animated:YES];
    [self.tableView reloadData];
}

#pragma mark Web

- (void)fetchStoreSubcategories {
    //@"portal?a=maincatogory&storeId=1&maincatogoryid=4"
    [self showHUD];
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=subcatogory&storeId=%@&maincatogoryid=%@",_storeId,_maincategoryId];
    [_client performOperationWithUrl:urlStr andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *subCategories = responseObject[@"list"];
        if (subCategories.count) {
            NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
            [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempArr addObject:[[Subcategory alloc] initWithSubcatogarywithDictionary:obj]];
            }];
            self.subCategories = [[NSMutableArray alloc] initWithArray:tempArr copyItems:NO];
            [self.tabs reloadData];
            [self.tableView reloadData];
        } else {
            [self showAlert:nil message:@"No Categories Found"];
        }
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}

#pragma mark SearchController delegate

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
//    [self.searchedStores removeAllObjects];
//    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"storeName  contains [c] %@", searchText];//LIKE
//    self.searchedStores = [NSMutableArray arrayWithArray: [self.stores filteredArrayUsingPredicate:resultPredicate]];
//    [self.collectionView reloadData];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    [self filterContentForSearchText:searchBar.text scope:@"All"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}


@end
