//
//  HistoryVC.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "HistoryVC.h"
#import "HistoryTableViewCell.h"
#import "Constants.h"
#import "UIViewController+Helpers.h"

@interface HistoryVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) Lapanzo_Client *client;
@property (nonatomic, weak) IBOutlet UITableView *tblView;

@property (nonatomic) NSMutableArray *pastOrders;
@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self homeButton];
    
#warning pasatordersummary pending 
    //@@// a – pastOrderSummary
    //billno - 18
    //@@//
}


#pragma mark tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pastOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HISTORY_TABLECELLID];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HISTORY_TABLECELLID];
    }
    cell.pastOrder = _pastOrders [indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


#pragma mark weboperations

- (void)fetchPastOrders {
    
//    NSString *urlStr = [NSString stringWithFormat:@"portal?a=pastOrders&userId=%@",_client.userId];
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=pastOrders&userId=1"];
    [self showHUD];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *history = responseObject [@"list"];
        if (!history.count) {
            [self showAlert:nil message:@"No history"];
            return;
        }
        
        [_tblView reloadData];
        
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
