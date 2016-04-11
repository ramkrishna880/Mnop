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



- (IBAction)addButtonClicked:(id)sender {
    
}

- (void)setSelectedItem:(Item *)selectedItem {
    if (selectedItem) {
        self.name.text = selectedItem.name;
        self.priceLbl.text = selectedItem.priceAfterDiscount;
    }
}
@end
