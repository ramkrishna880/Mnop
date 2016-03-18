//
//  LZLabel.m
//  Lapanzo
//
//  Created by PTG on 11/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "LZLabel.h"

@implementation LZLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
