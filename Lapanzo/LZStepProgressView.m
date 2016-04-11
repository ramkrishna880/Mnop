//
//  LZStepProgressView.m
//  Lapanzo
//
//  Created by PTG on 11/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "LZStepProgressView.h"
#import "UIColor+Helpers.h"

@implementation LZStepProgressView


- (instancetype)init {
    self = [super init];
    if (self) {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = self.bounds;
            [self addSubview:subview];
        }
        [self initilize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = self.bounds;
            [self addSubview:subview];
        }
        [self initilize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = self.bounds;
            [self addSubview:subview];
        }
        [self initilize];
    }
    return self;
}

- (void)initilize {
    UIView *firstPart = self.progressViews[0];
    [self roundCOrnersforView:firstPart corners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)];
    UIView *lastPart = [self.progressViews lastObject];
    [self roundCOrnersforView:lastPart corners:(UIRectCornerTopRight | UIRectCornerBottomRight)];
}

- (void)roundCOrnersforView:(UIView *)forView corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:forView.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    forView.layer.mask = maskLayer;
}


- (void)setProgressWithIndex:(NSUInteger)index {
    if (index > 3) {
        return;
    }
    for (int i = 0; i<=index; i++) {
        UIView *pV = _progressViews[i];
        [pV setBackgroundColor:[UIColor redColor]];
    }
}


@end
