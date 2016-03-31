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

@interface StoreDetailVC () <UITableViewDataSource, UITableViewDelegate,HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate, UISearchResultsUpdating, UISearchBarDelegate, StoreTableCellDelegate> {
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
@property (nonatomic) NSMutableArray *searchedItems;
@property (nonatomic) NSMutableArray *cartItems;
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
    
    self.cartItems = [[NSMutableArray alloc] initWithArray:_client.cartItems copyItems:YES];
    
    [self fetchStoreSubcategories];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.tabs) {
        self.tabs = [[HTHorizontalSelectionList alloc] initWithFrame:self.tabsPlaceHolder.bounds];
        _tabs.delegate = self;
        _tabs.dataSource = self;
        _tabs.selectionIndicatorColor = [UIColor whiteColor];
        _tabs.selectionIndicatorHeight = 8.0f;
        [_tabs setTitleColor:[UIColor colorFromRGBforRed:55.0 blue:57.0 green:80.0] forState:UIControlStateNormal];
        [_tabs setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tabs setTitleFont:[UIFont boldSystemFontOfSize:15.0] forState:UIControlStateNormal];
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
        cell.delegate = self;
    }
    Subcategory *sbCat = _subCategories [indexPath.section];
    Item *crntItem =  sbCat.items [indexPath.row];
    NSArray *checkedItems = [self checkForSelectedFromCartOfItems:crntItem.itemId];
    NSLog(@"inside cell :%lu",checkedItems.count);
    if (!checkedItems.count) {
        cell.currentItem = crntItem;
    } else {
        cell.currentItem = checkedItems[0];
    }
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
    [self showHUD];
//    NSString *urlStr = [NSString stringWithFormat:@"portal?a=subcatogory&storeId=%@",_storeId];
    
    NSString *urlStr = @"portal?a=subcatogory&storeId=1";
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
            [self showAlert:nil message:@"No Subcategories Found"];
        }
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}

#pragma mark SearchController delegate

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [self.searchedItems removeAllObjects];
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"storeName  contains [c] %@", searchText];//LIKE
    self.searchedItems = [NSMutableArray arrayWithArray: [self.subCategories filteredArrayUsingPredicate:resultPredicate]]; // passed wrong array here change in future
    [self.tableView reloadData];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    [self filterContentForSearchText:searchBar.text scope:@"All"];
}


#pragma mark StorecellDelegate

- (void)changedQuantityForCell:(StoresTableViewCell *)cell andValue:(NSUInteger)changedNumber {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Subcategory *sbCt = _subCategories[indexPath.section];
    Item *item = sbCt.items[indexPath.row];
    NSArray *items = [self checkForSelectedFromCartOfItems:item.itemId];
    NSLog(@"inside delegate Method :%lu",items.count);

#warning ask what is item count in items

    if (!items.count) {
        item.itemCount = @(changedNumber).stringValue;
        [_cartItems addObject:item];
    } else {
        Item *existedItem = items[0];
        existedItem.itemCount = @(changedNumber).stringValue;
    }
}


- (NSArray *)checkForSelectedFromCartOfItems:(NSNumber *)itemId {
    if (!itemId && !_cartItems.count) {
        return nil;
    }
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"itemId contains [c] %@",itemId];
    return  [self.cartItems filteredArrayUsingPredicate:resultPredicate];  
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}


@end
