//
//  HomeservicesCell.m
//  Lapanzo
//
//  Created by PTG on 10/05/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "HomeservicesCell.h"
#import "Item.h"

@implementation HomeservicesCell {
     Item *_currentItem;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didItemAddorremoveFromCartForCell:didAddOrRemove:)]) {
        [self.delegate didItemAddorremoveFromCartForCell:self didAddOrRemove:sender.selected];
    }
//    if (sender.selected) {
//        
//    } else {
//        
//    }
}

- (void)setCurrentItem:(Item *)currentItem {
    if (currentItem == _currentItem) {
        return;
    }
    _currentItem = currentItem;
    self.storeTitle.text = [NSString stringWithFormat:@"%@ (%@ pc)",currentItem.name,currentItem.itemCount];
    self.quantityLbl.text = currentItem.quantityval;
    self.amountLbl.text = [NSString stringWithFormat:@"₹ %@",currentItem.priceAfterDiscount];
//    self.counterLbl.text = _currentItem.noOfItems;
}

@end
