//
//  StoresTableViewCell.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "StoresTableViewCell.h"
#import "UIColor+Helpers.h"

@implementation StoresTableViewCell {
    Item *_currentItem;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
//    self.stepper.value = 0.0;
//    self.stepper.minimumValue = 0;
//    self.stepper.maximumValue = 100;
//    self.stepper.editableManually = NO;
    //self.layer.borderColor = [UIColor navigationBarTintColor].CGColor   ;
    //self.layer.borderWidth = 1.0f;
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
    self.storeTitle.text = [NSString stringWithFormat:@"%@ (%@ pc)",currentItem.name,currentItem.itemCount];
    self.quantityLbl.text = currentItem.quantityval;
    self.amountLbl.text = [NSString stringWithFormat:@"₹ %@",currentItem.priceAfterDiscount];
    self.counterLbl.text = _currentItem.noOfItems;
    //self.stepper.value = 0.0;
}


#pragma mark UIActions

- (IBAction)countButtonsPressed:(UIButton *)sender {
    if (sender.tag >1) {
        return;
    }
    CATransition* transition = [CATransition animation];
    NSUInteger val = [self noOfUnitsValue];
    if (sender.tag == 0) {
        if (val == 0) {
            return;
        }
        if (val>0) {
            val--;
        }
        transition.subtype = kCATransitionFromTop;
    } else {
        if (val<100) {
            val++;
        } else {
            return;
        }
        transition.subtype = kCATransitionFromBottom;
    }
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    
    _counterLbl.text = @(val).stringValue;
    [_counterLbl.layer addAnimation:transition forKey:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changedQuantityForCell:andValue:)]) {
        [self.delegate changedQuantityForCell:self andValue:val];
    }
}


- (IBAction)deleteButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteClickedForCell:)]) {
        [self.delegate didDeleteClickedForCell:self];
    }
}

#pragma mark Others

- (NSUInteger)noOfUnitsValue {
    return _counterLbl.text.integerValue;
}

@end
