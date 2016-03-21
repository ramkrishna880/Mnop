//
//  StoresTableViewCell.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "StoresTableViewCell.h"

@implementation StoresTableViewCell {
    Item *_currentItem;
}

/*
 IBOutlet UILabel *storeTitle;
 et UILabel *quantityLbl;
 et UILabel *amountLbl;
 et PAStepper *stepper;
 */

- (void)awakeFromNib {
    // Initialization code
    
    self.stepper.value = 0.0;
    self.stepper.minimumValue = 0;
    self.stepper.maximumValue = 100;
    self.stepper.editableManually = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurrentItem:(Item *)currentItem {
    if (currentItem == _currentItem) {
        return;
    }
    _currentItem = currentItem;
    self.storeTitle.text = currentItem.name;
    self.quantityLbl.text = currentItem.quantityval;
    self.amountLbl.text = currentItem.price;
    self.stepper.value = 0.0;
}
@end
