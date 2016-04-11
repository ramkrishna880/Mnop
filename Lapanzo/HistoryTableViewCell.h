//
//  HistoryTableViewCell.h
//  Lapanzo
//
//  Created by PTG on 04/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PastOrder.h"

@class LZStepProgressView;

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *orderId;
@property (nonatomic, weak) IBOutlet UILabel *orderDate;
@property (nonatomic, weak) IBOutlet UILabel *orderAmount;
@property (nonatomic, weak) IBOutlet LZStepProgressView *progressView;
@property (nonatomic, strong) PastOrder *pastOrder;

@end
