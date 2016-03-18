//
//  CartVC.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "CartVC.h"
#import "Constants.h"
#import "StoresTableViewCell.h"

@interface CartVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


#pragma mark Actions

- (IBAction)checkOutTapped:(id)sender {
    
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
