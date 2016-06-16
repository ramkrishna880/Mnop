//
//  StoreDetailVC.h
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericViewController.h"


typedef enum : NSUInteger {
    kVendorTypeGeneral = 0,
    kVendorTypeFlower,
    kVendorTypeWater,
    kVendorTypeHOmeServices,
} kVendorType;


@interface StoreDetailVC : GenericViewController
@property (nonatomic) NSNumber *storeId;
@property (nonatomic) NSNumber *maincategoryId;
@property (nonatomic) kVendorType vendorType;
@end
