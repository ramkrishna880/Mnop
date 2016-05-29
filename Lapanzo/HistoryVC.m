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
    _tblView.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
    
//#warning pasatordersummary pending 
//    //@@// a – pastOrderSummary
//    //billno - 18
//    //@@//
    
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
            [self showAlert:nil message:@"No Past orders"];
            return;
        }
        
        [_tblView reloadData];
        
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}



/*
 
 {
 "a": "pastOrders",
 "list": [
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 177,
 "orderno": "31",
 "amt": 557.96,
 "ack": "SBPC2015081459632742"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 176,
 "orderno": "30",
 "amt": 557.96,
 "ack": "SBPC2015081459632319"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 175,
 "orderno": "29",
 "amt": 557.96,
 "ack": "SBPC2015081459631774"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 174,
 "orderno": "28",
 "amt": 557.96,
 "ack": "SBPC2015081459631134"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 173,
 "orderno": "27",
 "amt": 557.96,
 "ack": "SBPC2015081459630528"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 172,
 "orderno": "26",
 "amt": 557.96,
 "ack": "SBPC2015081459629806"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "initiated",
 "billno": 171,
 "orderno": "25",
 "amt": 557.96,
 "ack": "SBPC2015081459619016"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "initiated",
 "billno": 170,
 "orderno": "24",
 "amt": 557.96,
 "ack": "SBPC2015081459617880"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "initiated",
 "billno": 169,
 "orderno": "23",
 "amt": 557.96,
 "ack": "SBPC2015081459575145"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 168,
 "orderno": "22",
 "amt": 557.96,
 "ack": "SBPC2015081459517629"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 167,
 "orderno": "21",
 "amt": 557.96,
 "ack": "SBPC2015081459402242"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 166,
 "orderno": "20",
 "amt": 557.96,
 "ack": "SBPC2015081459304681"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 165,
 "orderno": "19",
 "amt": 557.96,
 "ack": "SBPC2015081459044927"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "initiated",
 "billno": 164,
 "orderno": "18",
 "amt": 557.96,
 "ack": "SBPC2015081458014760"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "fail",
 "billno": 163,
 "orderno": "17",
 "amt": 557.96,
 "ack": "SBPC2015081457989794"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 162,
 "orderno": "16",
 "amt": 557.96,
 "ack": "SBPC2015081457848328"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 161,
 "orderno": "15",
 "amt": 557.96,
 "ack": "SBPC2015081457785470"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "14/08/2015",
 "status": "new",
 "billno": 160,
 "orderno": "14",
 "amt": 557.96,
 "ack": "SBPC2015081457590412"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "05/07/2015",
 "status": "new",
 "billno": 157,
 "orderno": "5",
 "amt": 560,
 "ack": "SBPC2015070570321328"
 },
 {
 "rid": 1,
 "rname": "Grofers",
 "date": "05/07/2015",
 "status": "new",
 "billno": 156,
 "orderno": "4",
 "amt": 815,
 "ack": "FZPC2015070570080858"
 }
 ]
 }
 
 */



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
