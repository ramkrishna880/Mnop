//
//  ORNavigationBar.m
//  BIGEO
//
//  Created by PTG on 08/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "ORNavigationBar.h"
#import "UIColor+Helpers.h"

const CGFloat VFSNavigationBarHeightIncrease = 38.f;
#define NAVIGATION_BTN_MARGIN 5

@implementation ORNavigationBar


//- (CGSize)sizeThatFits:(CGSize)size {
//    
//    CGSize amendedSize = [super sizeThatFits:size];
//    amendedSize.height += VFSNavigationBarHeightIncrease;
//    return amendedSize;
//}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
    
    
    UINavigationItem *navigationItem = [self topItem];
    
    UIView *subview = [[navigationItem rightBarButtonItem] customView];
    
    if (subview) {
        CGRect subviewFrame = subview.frame;
        subviewFrame.origin.x = self.frame.size.width - subviewFrame.size.width;
        
        [subview setFrame:subviewFrame];
    }
    
    
//    for (UIView *view in [self subviews]) {
//        
//        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
//            
//            CGRect bounds = [self bounds];
//            CGRect frame = [view frame];
//            frame.origin.y = bounds.origin.y + VFSNavigationBarHeightIncrease - 20.f;
//            frame.size.height = bounds.size.height + 20.f;
//            
//            [view setFrame:frame];
//        }
//    }
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.barTintColor = [UIColor navigationBarTintColor];
    //[self setTransform:CGAffineTransformMakeTranslation(0, -(VFSNavigationBarHeightIncrease))];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
