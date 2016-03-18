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

@interface StoreDetailVC () <UITableViewDataSource, UITableViewDelegate,HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate>
@property (nonatomic) IBOutlet UIImageView *storeImage;
@property (nonatomic) IBOutlet UIView *tabsPlaceHolder;
@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) Lapanzo_Client *client;

@property (nonatomic) HTHorizontalSelectionList *tabs;
@property (nonatomic) NSArray *subCategories;
@end

@implementation StoreDetailVC

#pragma mark ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialUIelements];
}


- (void)setUpInitialUIelements {
    _client = [Lapanzo_Client sharedClient];
    
    UISwipeGestureRecognizer *tableSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedOntableView:)];
    tableSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:tableSwipeGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tabs) {
        self.tabs = [[HTHorizontalSelectionList alloc] initWithFrame:self.tabsPlaceHolder.bounds];
        _tabs.delegate = self;
        _tabs.dataSource = self;
        //_selectionList.selectionIndicatorColor = [UIColor navBarTintColor];
        //[_selectionList setTitleColor:[UIColor colorFromRGBforRed:55.0 blue:57.0 green:80.0] forState:UIControlStateNormal];
        //[_selectionList setTitleColor:[UIColor navBarTintColor] forState:UIControlStateHighlighted];
        [_tabs setTitleFont:[UIFont boldSystemFontOfSize:18.0] forState:UIControlStateNormal];
        [self.tabsPlaceHolder addSubview:_tabs];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STORES_TABLECELLID];
    if (!cell) {
        cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STORES_TABLECELLID];
    }
    
    cell.storeTitle.text = [NSString stringWithFormat:@"Store %lu",indexPath.row];
    cell.quantityLbl.text = @"500 gms";
    cell.amountLbl.text = @"50 rs";
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
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
}


#pragma mark Actions
- (IBAction)mainCatogoryAction:(id)sender {
    
}

- (IBAction)storesButtonTapped:(id)sender {
    
}

- (IBAction)goToCartClicked:(id)sender {
    
}

- (void)swipedOntableView:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
    } else {
        
    }
    [self.tabs setSelectedButtonIndex:1 animated:YES];
    [self.tableView reloadData];
}

#pragma mark Web

- (void)fetchStoreSubcategories {
    //    NSString *urlStr = [NSString stringWithFormat:@"portal?a=subcatogory&storeId=%@&maincatogoryid=%@"];
    [_client performOperationWithUrl:@"portal?a=maincatogory&storeId=1&maincatogoryid=4" andCompletionHandler:^(NSDictionary *responseObject) {
        NSArray *subCategories = responseObject[@"list"];
        if (subCategories.count) {
            
        } else {
            [self showAlert:nil message:@"No Categories Found"];
        }
    } failure:^(NSError *connectionError) {
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}


@end
