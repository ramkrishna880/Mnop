//
//  HistoryTableViewCell.m
//  Lapanzo
//
//  Created by PTG on 04/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "HistoryTableViewCell.h"

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
    }
}

@end
