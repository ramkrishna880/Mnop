//
//  StoresTableViewCell.h
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAStepper.h"
#import "Item.h"

@protocol StoreTableCellDelegate;
@interface StoresTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *storeTitle;
@property (nonatomic) IBOutlet UILabel *quantityLbl;
@property (nonatomic) IBOutlet UILabel *amountLbl;
@property (nonatomic) IBOutlet PAStepper *stepper;

@property (nonatomic) Item *currentItem;

@property (nonatomic, weak) IBOutlet UILabel *counterLbl;
@property (nonatomic, weak) id <StoreTableCellDelegate> delegate;
- (IBAction)countButtonsPressed:(id)sender;

@end


@protocol StoreTableCellDelegate <NSObject>
@optional
- (void)changedQuantityForCell:(StoresTableViewCell *)cell andValue:(NSUInteger)changedNumber;
- (void)didDeleteClickedForCell:(StoresTableViewCell *)cell;
@end