//
//  PastOrder.m
//  Lapanzo
//
//  Created by PTG on 04/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "PastOrder.h"


/*
 
 "rid": 1
 "rname": "Grofers"
 "date": "14/08/2015"
 "status": "new"
 "billno": 176
 "orderno": "30"
 "amt": 557.96
 "ack": "SBPC2015081459632319"
 */

@implementation PastOrder

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid parameter." format:@"This method should not be called if parameter is nil or not an NSDictionary"];
    }
    //remove for nulls in future if appears
    if (self = [super init]) {
        
        self.orderId = dictionary [@"rid"];
        self.rName = dictionary [@"rname"];
        self.date = dictionary [@"date"];
        self.status = dictionary [@"status"];
        self.billeNo = dictionary [@"billno"];
        self.orderNo = dictionary [@"orderno"];
        self.amount = dictionary [@"amt"];
        self.acknowledgement = dictionary [@"ack"];
    }
    return self;
}

@end
