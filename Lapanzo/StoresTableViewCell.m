//
//  StoresTableViewCell.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "StoresTableViewCell.h"

@implementation StoresTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.stepper.value = 1.0;
    self.stepper.minimumValue = 1;
    self.stepper.maximumValue = 50;
    self.stepper.editableManually = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
