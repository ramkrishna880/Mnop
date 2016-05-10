//
//  HomeservicesCell.m
//  Lapanzo
//
//  Created by PTG on 10/05/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "HomeservicesCell.h"

@implementation HomeservicesCell

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

@end
