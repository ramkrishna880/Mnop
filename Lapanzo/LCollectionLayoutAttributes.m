//
//  LCollectionLayoutAttributes.m
//  Lapanzo
//
//  Created by PTG on 06/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "LCollectionLayoutAttributes.h"

@implementation LCollectionLayoutAttributes

- (instancetype)copyWithZone:(NSZone *)zone {
    LCollectionLayoutAttributes *copy = [super copyWithZone:zone];
    copy.backgroundColor = self.backgroundColor;
    return copy;
}

@end
