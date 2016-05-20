//
//  FlowersCollectionViewCell.m
//  Lapanzo
//
//  Created by sampath kumar rao on 09/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "FlowersCollectionViewCell.h"

@implementation FlowersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (IBAction)addButtonClicked:(UIButton *)sender {
    
    BOOL shouldAdd;
    if ([sender.titleLabel.text isEqualToString:@"ADD+"]) {
        [sender setTitle:@"Remove -" forState:UIControlStateNormal];
        shouldAdd = YES;
    } else {
        [sender setTitle:@"ADD+" forState:UIControlStateNormal];
        shouldAdd = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didItemAddOrRemoveFlowerFromCartForCell:didAddOrRemove:)]) {
        [self.delegate didItemAddOrRemoveFlowerFromCartForCell:self didAddOrRemove:shouldAdd];
    }
}

- (void)setTitleForAddbutton:(BOOL)isAdd {
    if (isAdd) {
        [_addButton setTitle:@"Remove -" forState:UIControlStateNormal];
    } else {
        [_addButton setTitle:@"ADD+" forState:UIControlStateNormal];
    }
}

- (void)setSelectedItem:(Item *)selectedItem {
    if (selectedItem) {
        self.name.text = selectedItem.name;
        self.priceLbl.text = selectedItem.priceAfterDiscount;
    }
}
@end
