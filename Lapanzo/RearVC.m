//
//  RearVC.m
//  Lapanzo
//
//  Created by PTG on 05/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "RearVC.h"

@interface RearVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UIImageView *userImgView;
@property (nonatomic, weak) IBOutlet UILabel *userName;
@end

@implementation RearVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPinitialUIElements];
}


- (void)setUPinitialUIElements {
    [self.userImgView.layer setCornerRadius:40.0f];
}

#pragma mark Tableview datasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    return cell;
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
