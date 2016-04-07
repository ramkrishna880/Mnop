//
//  UIButton+UIButtonExt.m
//  M-BAS
//
//  Created by PTG on 29/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "UIButton+UIButtonExt.h"

@implementation UIButton (UIButtonExt)


- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)//- imageSize.width
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 25.0f; //6.0
    [self centerImageAndTitle:DEFAULT_SPACING];
}


@end
