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
#import "FlowersCollectionViewCell.h"
#import "HomeservicesCell.h"
#import "CartVC.h"
#import "UIColor+Helpers.h"
#import "UIViewController+Helpers.h"

@interface StoreDetailVC () <UITableViewDataSource, UITableViewDelegate,HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, StoreTableCellDelegate, UIPopoverControllerDelegate, FlowerCollectionCellDelegate, HomeservicesCellDelegate> {
    UIDatePicker *datepicker;
    UIPopoverController *popOverForDatePicker;
}
@property (nonatomic) UISearchController *searchController;
//@property (nonatomic) IBOutlet UIImageView *storeImage;
@property (nonatomic) IBOutlet UIView *tabsPlaceHolder;
@property (nonatomic) IBOutlet UIView *searchPlaceHolder;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) Lapanzo_Client *client;

@property (nonatomic) HTHorizontalSelectionList *tabs;
@property (nonatomic) NSArray *subCategories;
@property (nonatomic) NSMutableArray *others;
@property (nonatomic) NSMutableArray *searchedItems;
@property (nonatomic) NSMutableArray *cartItems;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic) IBOutlet NSLayoutConstraint *tabsViewHeightConstraint;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBarButtonView]];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self homeButton];
    UISwipeGestureRecognizer *tableSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedOntableView:)];
    tableSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:tableSwipeGesture];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.cartItems = [[NSMutableArray alloc] initWithArray:_client.cartItems copyItems:NO];
    [self setViewsBasedOnVendorType];
    [self fetchStoreSubcategories];
}

- (void)dealloc {
    [_searchController.view removeFromSuperview];
}
- (void)setViewsBasedOnVendorType {
    
    switch (_vendorType) {
        case kVendorTypeGeneral:
        {
            
        }
            
            break;
        case kVendorTypeWater:
        {
            self.tabsViewHeightConstraint.constant = 0;
            [self.tabsViewHeightConstraint.firstItem setHidden:YES];
        }
            
            break;
        case kVendorTypeFlower:
        {
            self.tabsViewHeightConstraint.constant = 0;
            [self.tabsViewHeightConstraint.firstItem setHidden:YES];
            [self.tableView setHidden:YES];
            [self.collectionView setHidden:NO];
            [self.collectionView registerNib:[UINib nibWithNibName:@"FlowersCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:FLOWERS_COLLCCELLID];
        }
            
            break;
        case kVendorTypeHOmeServices:
        {
            self.tabsViewHeightConstraint.constant = 0;
            [self.tabsViewHeightConstraint.firstItem setHidden:YES];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.tabs && self.vendorType == kVendorTypeGeneral) {
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
        _searchController.delegate = self;
        self.definesPresentationContext = true;
        _searchController.dimsBackgroundDuringPresentation = false;
        [self.searchController.searchBar setPlaceholder:@"Are you looking for any product ?"];
        [self.searchController.searchBar sizeToFit];
        _searchController.searchBar.frame = _searchPlaceHolder.bounds;
        [self.searchPlaceHolder addSubview:_searchController.searchBar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cartLabel.text = @(_client.cartItemsCount).stringValue;
    [_tableView reloadData];
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
        //        cell.delegate = self;
    }
    Subcategory *sbCat = _subCategories [_index];
    Item *crntItem =  sbCat.items [indexPath.row];
    NSArray *checkedItems = [self checkForSelectedFromCartOfItems:crntItem.itemId];
    NSLog(@"inside cell :%lu",checkedItems.count);
    if (!checkedItems.count) {
        cell.currentItem = crntItem;
    } else {
        cell.currentItem = checkedItems[0];
    }
    
    //http://stackoverflow.com/questions/31063571/getting-indexpath-from-switch-on-uitableview
    cell.delegate = self;
    return cell;
}


#pragma mark CollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.searchController.active && _searchController.searchBar.text.length) {
        return _others.count;
    } else {
        return _searchedItems.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    FlowersCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FLOWERS_COLLCCELLID forIndexPath:indexPath];
    if (self.searchController.active && _searchController.searchBar.text.length) {
        cell.selectedItem = _searchedItems[indexPath.row];
    } else {
        cell.selectedItem = _others[indexPath.row];
    }
    
    return cell;
}



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
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)storesButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)goToCartClicked:(id)sender {
    if (!_cartItems.count) {
        [self showAlert:@"Cart" message:@"Please add few items to cart before you proceed"];
        return;
    }
    
    [self performSegueWithIdentifier:CART_SEGUEID sender:nil];  // future sender may not be nil
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
    
#warning sort out for water services
    //    3
    
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=subcatogory&storeId=%@",_storeId];
    //NSString *urlStr = @"portal?a=subcatogory&storeId=1";
    [_client performOperationWithUrl:urlStr andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *subCategories = responseObject[@"list"];
        
        //        if (self.vendorType == kVendorTypeFlower) {
        //            NSMutableArray *flowers = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        //            [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                Item *item = [[Item alloc] initWithDictionary:obj];
        //                [flowers addObject:item];
        //            }];
        //            _others = [[NSMutableArray alloc]initWithArray:flowers copyItems:NO];
        //            [_collectionView reloadData];
        //        } else if (self.vendorType == kVendorTypeWater) {
        //
        //        } else if (self.vendorType == kVendorTypeHOmeServices) {
        //            NSMutableArray *flowers = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        //            [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                Item *item = [[Item alloc] initWithDictionary:obj];
        //                [flowers addObject:item];
        //            }];
        //            _others = [[NSMutableArray alloc]initWithArray:flowers copyItems:NO];
        //            [_tableView reloadData];
        //        } else {
        //
        //        }
        
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

# warning implement proper search implementation

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"search activated");
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"search dismissed");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText");
    if (searchText.length == 0) {
        NSLog(@"No searchText");
    }
}

#pragma mark StorecellDelegate

- (void)changedQuantityForCell:(StoresTableViewCell *)cell andValue:(NSUInteger)changedNumber {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Subcategory *sbCt = _subCategories[_index];
    Item *item = sbCt.items[indexPath.row];
    NSArray *items = [self checkForSelectedFromCartOfItems:item.itemId];
    
    if (!items.count) {
        item.noOfItems = @(changedNumber).stringValue;
        [_cartItems addObject:item];
    } else {
#warning remove item if count is 0
        Item *existedItem = items[0];
        if (changedNumber == 0) {
            NSUInteger index = [self indexOfItemFromArray:_cartItems foIitemId:existedItem.itemId];
            [_cartItems removeObjectAtIndex:index];
        } else {
            Item *itemFrmCart = _cartItems [[self indexOfItemFromArray:_cartItems foIitemId:existedItem.itemId]];
            itemFrmCart.noOfItems = @(changedNumber).stringValue;
        }
    }
    self.cartLabel.text = @(_cartItems.count).stringValue;
    [self.client setCartItems:_cartItems];
}


- (NSArray *)checkForSelectedFromCartOfItems:(NSNumber *)itemId {
    if (!itemId || !_cartItems.count) {
        return nil;
    }
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"itemId == %@",itemId];  //itemId contains [c] %@
    return  [self.cartItems filteredArrayUsingPredicate:resultPredicate];
}

- (NSUInteger)indexOfItemFromArray:(NSArray *)array foIitemId:(NSNumber *)itemId {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"itemId == %@",itemId];
    NSUInteger index = [array  indexOfObjectPassingTest:^(Item *obj, NSUInteger idx, BOOL *stop) {
        return [resultPredicate evaluateWithObject:obj];
    }];
    return index;
}

#pragma mark flowercell Delegate

- (void)changedFlowerQuantityForCell:(FlowersCollectionViewCell *)cell  {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Item *item = _others[indexPath.row];
    NSArray *items = [self checkForSelectedFromCartOfItems:item.itemId];
    if (!items.count) {
        [_cartItems addObject:item];
    } else {
        Item *existedItem = items[0];
        Item *itemFrmCart = _cartItems [[self indexOfItemFromArray:_cartItems foIitemId:existedItem.itemId]];
    }
    [self.client setCartItems:_cartItems];
}


- (void)didItemAddorremoveFromCartForCell:(HomeservicesCell *)cell didAddOrRemove:(BOOL)shouldAdd {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Subcategory *sbCt = _subCategories[_index];
    Item *item = sbCt.items[indexPath.row];
    //NSArray *items = [self checkForSelectedFromCartOfItems:item.itemId];
    
#warning change logic for flowers and homes servces etc like array passed
    
    // if (!items.count) {
    if (shouldAdd) {
        [_cartItems addObject:item];
    } else {
        NSUInteger index = [self indexOfItemFromArray:_cartItems foIitemId:item.itemId];
        [_cartItems removeObjectAtIndex:index];
    }
    // }
    [self.client setCartItems:_cartItems];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CART_SEGUEID]) {
        CartVC *cart =  segue.destinationViewController;
        cart.storeId = self.storeId;
    }
}


@end
