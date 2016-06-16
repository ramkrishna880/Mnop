//
//  HistoryTableViewCell.m
//  Lapanzo
//
//  Created by PTG on 04/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "LZStepProgressView.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setPastOrder:(PastOrder *)pastOrder {
    if (pastOrder) {
        self.orderId.text = pastOrder.orderId.stringValue;
        self.orderDate.text = pastOrder.date;
        self.orderAmount.text = pastOrder.amount;
        //        [self.progressView setProgressWithIndex:0]; //change according to status
        
        //        if ([pastOrder.status isEqualToString:@"new"]) {
        //
        //        } else
        if ([pastOrder.status isEqualToString:@"initiated"]) {
            [self.progressView setProgressWithIndex:0];
        } else if ([pastOrder.status isEqualToString:@"dispatched"]) {
            [self.progressView setProgressWithIndex:1];
        } else if ([pastOrder.status isEqualToString:@"delivered"]) {
            [self.progressView setProgressWithIndex:2];
        } else {
            
        }
    }
}
@end
