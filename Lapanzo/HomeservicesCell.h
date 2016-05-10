//
//  HomeservicesCell.h
//  Lapanzo
//
//  Created by PTG on 10/05/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeservicesCellDelegate;

@interface HomeservicesCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *storeTitle;
@property (nonatomic) IBOutlet UILabel *quantityLbl;
@property (nonatomic) IBOutlet UILabel *amountLbl;

@property (nonatomic, weak) id <HomeservicesCellDelegate> delegate;
@end


@protocol HomeservicesCellDelegate <NSObject>
@optional
//- (void)changedQuantityForCell:(HomeservicesCell *)cell andValue:(NSUInteger)changedNumber;
- (void)didItemAddorremoveFromCartForCell:(HomeservicesCell *)cell didAddOrRemove:(BOOL)shouldAdd;
//- (void)didDeleteClickedForCell:(HomeservicesCell *)cell;
@end