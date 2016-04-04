//
//  PaymentVC.h
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericViewController.h"

@interface PaymentVC : GenericViewController

@property (nonatomic) NSNumber *storeId;
//@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSArray *cartItems;
@end
