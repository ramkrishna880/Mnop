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
    self.title = @"Products";
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
        _tabs.selectionIndicatorHeight = 4.0f;
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
    
    if (self.vendorType == kVendorTypeGeneral) {
        Subcategory *sbCat = _subCategories[_index];
        return sbCat.items.count;
    } else {
        return  _others.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.vendorType == kVendorTypeHOmeServices) {
        HomeservicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeservicesCellIdentifier"];
        if (!cell) {
            cell = [[HomeservicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeservicesCellIdentifier"];
        }
        
        Item *crntItem;
        if (self.searchController.active && _searchController.searchBar.text.length) {
            crntItem = _searchedItems [indexPath.row];
        } else {
            crntItem = _others [indexPath.row];
        }
        //        Item *crntItem = _others [indexPath.row];
        NSArray *checkedItems = [self checkForSelectedFromCartOfItems:crntItem.itemId];
        if (checkedItems.count) {
            [cell.radioButton setSelected:YES];
        } else {
            [cell.radioButton setSelected:NO];
        }
        cell.currentItem = crntItem;
        return cell;
    } else if (self.vendorType == kVendorTypeWater) {
        StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STORES_TABLECELLID];
        if (!cell) {
            cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STORES_TABLECELLID];
        }
        
        Item *crntItem;
        if (self.searchController.active && _searchController.searchBar.text.length) {
            crntItem = _searchedItems [indexPath.row];
        } else {
            crntItem = _others [indexPath.row];
        }
        
        //Item *crntItem = _others [indexPath.row];
        NSArray *checkedItems = [self checkForSelectedFromCartOfItems:crntItem.itemId];
        if (checkedItems.count) {
            cell.currentItem = checkedItems[0];
        } else {
            cell.currentItem = crntItem;
        }
        cell.delegate = self;
        return cell;
    } else {
        StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STORES_TABLECELLID];
        if (!cell) {
            cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STORES_TABLECELLID];
        }
        
        Item *crntItem;
        if (self.searchController.active && _searchController.searchBar.text.length) {
            crntItem = _searchedItems [indexPath.row];
        } else {
            Subcategory *sbCat = _subCategories [_index];
            crntItem =  sbCat.items [indexPath.row];
        }
        
        //        Subcategory *sbCat = _subCategories [_index];
        //        Item *crntItem =  sbCat.items [indexPath.row];
        NSArray *checkedItems = [self checkForSelectedFromCartOfItems:crntItem.itemId];
        NSLog(@"inside cell :%lu",(unsigned long)checkedItems.count);
        if (!checkedItems.count) {
            cell.currentItem = crntItem;
        } else {
            cell.currentItem = checkedItems[0];
        }
        
        cell.delegate = self;
        return cell;
    }
    
    //http://stackoverflow.com/questions/31063571/getting-indexpath-from-switch-on-uitableview
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
    Item *item;
    if (self.searchController.active && _searchController.searchBar.text.length) {
        item = _searchedItems[indexPath.row];
    } else {
        item = _others[indexPath.row];
    }
    
    NSArray *checkedItems = [self checkForSelectedFromCartOfItems:item.itemId];
    if (checkedItems.count) {
        cell.selectedItem = checkedItems[0];
        [cell setTitleForAddbutton:YES];
    } else {
        cell.selectedItem = item;
        [cell setTitleForAddbutton:NO];
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
    //    3
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=subcatogory&storeId=%@",_storeId];
    //NSString *urlStr = @"portal?a=subcatogory&storeId=1";
    [_client performOperationWithUrl:urlStr andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *subCategories = responseObject[@"list"];
        
        if (subCategories.count) {
            
            if (self.vendorType == kVendorTypeGeneral) {
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
                [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tempArr addObject:[[Subcategory alloc] initWithSubcatogarywithDictionary:obj andStoreId:self.storeId andCategoryId:_maincategoryId]];
                }];
                self.subCategories = [[NSMutableArray alloc] initWithArray:tempArr copyItems:NO];
                [self.tabs reloadData];
                [self.tableView reloadData];
            } else {
                NSDictionary *type = subCategories [0];
                NSArray *subItems = [type valueForKey:@"list"];
                NSMutableArray *otherThanGenTypes = [[NSMutableArray alloc] initWithCapacity:subItems.count];
                [subItems enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Item *item = [[Item alloc] initWithDictionary:obj];
                    item.subcategoryId = [type valueForKey:@"id"];
                    item.subcategaryName = [type valueForKey:@"name"];
                    item.storeId = self.storeId;
                    item.categoryId = self.maincategoryId;
                    [otherThanGenTypes addObject:item];
                }];
                _others = [[NSMutableArray alloc]initWithArray:otherThanGenTypes copyItems:NO];
                
                if (self.vendorType == kVendorTypeFlower) {
                    [_collectionView reloadData];
                } else {
                    [self.tableView reloadData];
                }
            }
        }else {
            [self showAlert:nil message:@"No List Found"];
        }
        
        //        if (subCategories.count) {
        //            if (self.vendorType == kVendorTypeFlower) {
        //                NSMutableArray *flowers = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        //                [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                    Item *item = [[Item alloc] initWithDictionary:obj];
        //                    [flowers addObject:item];
        //                }];
        //                _others = [[NSMutableArray alloc]initWithArray:flowers copyItems:NO];
        //                [_collectionView reloadData];
        //            } else if (self.vendorType == kVendorTypeWater) {
        //                NSMutableArray *flowers = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        //                [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                    Item *item = [[Item alloc] initWithDictionary:obj];
        //                    [flowers addObject:item];
        //                }];
        //                _others = [[NSMutableArray alloc]initWithArray:flowers copyItems:NO];
        //                [_tableView reloadData];
        //            } else if (self.vendorType == kVendorTypeHOmeServices) {
        //                NSMutableArray *flowers = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        //                [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                    Item *item = [[Item alloc] initWithDictionary:obj];
        //                    [flowers addObject:item];
        //                }];
        //                _others = [[NSMutableArray alloc]initWithArray:flowers copyItems:NO];
        //                [_tableView reloadData];
        //            } else {
        //                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        //                [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                    [tempArr addObject:[[Subcategory alloc] initWithSubcatogarywithDictionary:obj]];
        //                }];
        //                self.subCategories = [[NSMutableArray alloc] initWithArray:tempArr copyItems:NO];
        //                [self.tabs reloadData];
        //                [self.tableView reloadData];
        //
        //            }
        //        }else {
        //            [self showAlert:nil message:@"No List Found"];
        //        }
        
        //        if (subCategories.count) {
        //            NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        //            [subCategories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                [tempArr addObject:[[Subcategory alloc] initWithSubcatogarywithDictionary:obj]];
        //            }];
        //            self.subCategories = [[NSMutableArray alloc] initWithArray:tempArr copyItems:NO];
        //            [self.tabs reloadData];
        //            [self.tableView reloadData];
        //        } else {
        //            [self showAlert:nil message:@"No Subcategories Found"];
        //        }
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
    
    if (self.vendorType == kVendorTypeGeneral) {
        NSMutableArray *tempSearchItems = [[NSMutableArray alloc] init];
        for (Subcategory *subCat in self.subCategories) {
            [tempSearchItems addObjectsFromArray:subCat.items];
        }
        self.searchedItems = [NSMutableArray arrayWithArray: [tempSearchItems filteredArrayUsingPredicate:resultPredicate]];
    } else {
        self.searchedItems = [NSMutableArray arrayWithArray: [self.others filteredArrayUsingPredicate:resultPredicate]];
    }
    
    //self.searchedItems = [NSMutableArray arrayWithArray: [self.subCategories filteredArrayUsingPredicate:resultPredicate]]; // passed wrong array here change in future
    if (self.vendorType == kVendorTypeFlower) {
        [self.collectionView reloadData];
    } else {
        [self.tableView reloadData];
    }
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    [self filterContentForSearchText:searchBar.text scope:@"All"];
}

//# warning implement proper search implementation

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"search activated");
    
    if (self.vendorType == kVendorTypeGeneral) {
        self.tabsViewHeightConstraint.constant = 0;
        [self.tabsViewHeightConstraint.firstItem setHidden:YES];
    }
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"search dismissed");
    if (self.vendorType == kVendorTypeGeneral) {
        self.tabsViewHeightConstraint.constant = 0;
        [self.tabsViewHeightConstraint.firstItem setHidden:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText");
    if (searchText.length == 0) {
        NSLog(@"No searchText");
        //        [self.view endEditing:YES];
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
        //#warning remove item if count is 0
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

- (void)didItemAddOrRemoveFlowerFromCartForCell:(FlowersCollectionViewCell *)cell didAddOrRemove:(BOOL)shouldAdd  {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)cell];
    Item *item = _others[indexPath.row];
    //NSArray *items = [self checkForSelectedFromCartOfItems:item.itemId];
    //if (!items.count) {
    if (shouldAdd) {
        [_cartItems addObject:item];
    } else {
        NSUInteger index = [self indexOfItemFromArray:_cartItems foIitemId:item.itemId];
        [_cartItems removeObjectAtIndex:index];
    }
    [self.client setCartItems:_cartItems];
}

#pragma mark Homeservices Delegate

- (void)didItemAddorremoveFromCartForCell:(HomeservicesCell *)cell didAddOrRemove:(BOOL)shouldAdd {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //    Subcategory *sbCt = _subCategories[_index];
    Item *item = _others[indexPath.row];
    //NSArray *items = [self checkForSelectedFromCartOfItems:item.itemId];
    
    if (shouldAdd) {
        [_cartItems addObject:item];
    } else {
        NSUInteger index = [self indexOfItemFromArray:_cartItems foIitemId:item.itemId];
        [_cartItems removeObjectAtIndex:index];
    }
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
