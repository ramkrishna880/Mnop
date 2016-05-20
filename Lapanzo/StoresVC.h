//
//  StoresVC.h
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericViewController.h"

@interface StoresVC : GenericViewController
@property (nonatomic) NSNumber *vendorId;
@property (nonatomic) BOOL useCurrentLocation;
@end
