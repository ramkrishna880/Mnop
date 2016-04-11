//
//  FlowersCollectionViewCell.h
//  Lapanzo
//
//  Created by sampath kumar rao on 09/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@protocol FlowerCollectionCellDelegate;

@interface FlowersCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *priceLbl;
@property (nonatomic) Item *selectedItem;

@property (nonatomic, weak) id <FlowerCollectionCellDelegate> delegate;
@end


@protocol FlowerCollectionCellDelegate <NSObject>
@optional
- (void)changedFlowerQuantityForCell:(FlowersCollectionViewCell *)cell;
@end