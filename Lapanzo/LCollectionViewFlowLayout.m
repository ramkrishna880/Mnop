//
//  LCollectionViewFlowLayout.m
//  Lapanzo
//
//  Created by PTG on 06/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "LCollectionViewFlowLayout.h"
#import "LCollectionLayoutAttributes.h"

@implementation LCollectionViewFlowLayout


+ (Class)layoutAttributesClass {
    return [LCollectionLayoutAttributes class];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *poses = [super layoutAttributesForElementsInRect:rect];
    [self assignBackgroundColorsToPoses:poses];
    return poses;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCollectionLayoutAttributes *pose = (LCollectionLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    [self assignBackgroundColorsToPoses:@[ pose ]];
    return pose;
}

- (void)assignBackgroundColorsToPoses:(NSArray *)poses {
    NSArray *rowColors = self.rowColors;
    int rowColorsCount = (int)rowColors.count;
    if (rowColorsCount == 0)
        return;
    
    UIEdgeInsets insets = self.sectionInset;
    CGFloat lineSpacing = self.minimumLineSpacing;
    CGFloat rowHeight = self.itemSize.height + lineSpacing;
    for (LCollectionLayoutAttributes *pose in poses) {
        CGFloat y = pose.frame.origin.y;
        NSInteger section = pose.indexPath.section;
        y -= section * (insets.top + insets.bottom) + insets.top;
        y += section * lineSpacing; // Fudge: assume each prior section had at least one cell
        int row = floorf(y / rowHeight);
        pose.backgroundColor = rowColors[row % rowColorsCount];
    }
}

@end
