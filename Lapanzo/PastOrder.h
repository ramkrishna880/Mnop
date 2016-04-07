//
//  PastOrder.h
//  Lapanzo
//
//  Created by PTG on 04/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PastOrder : NSObject

@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, strong) NSString *rName;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *billeNo;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *acknowledgement;
@end



