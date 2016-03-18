//
//  StoresTableViewCell.h
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAStepper.h"

@interface StoresTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *storeTitle;
@property (nonatomic) IBOutlet UILabel *quantityLbl;
@property (nonatomic) IBOutlet UILabel *amountLbl;
@property (nonatomic) IBOutlet PAStepper *stepper;
@end
