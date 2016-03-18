//
//  Store.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "Store.h"

@implementation Store


- (instancetype)initStorewithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid parameter." format:@"This method should not be called if parameter is nil or not an NSDictionary"];
    }
    //remove nulls if in future appears
    if (self == [super init]) {
        self.storeId = dictionary[@"id"];
        self.storeName = dictionary[@"name"];
        self.storeTitle = dictionary[@"title"];
        self.storeSubTitle = dictionary[@"subtitle"];
        self.imgUrl = dictionary[@"img"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_storeId forKey:@"storeId"];
    [coder encodeObject:_storeName forKey:@"name"];
    [coder encodeObject:_storeTitle forKey:@"title"];
    [coder encodeObject:_storeSubTitle forKey:@"subtitle"];
    [coder encodeObject:_imgUrl forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.storeId = [coder decodeObjectForKey:@"storeId"];
        self.storeName = [coder decodeObjectForKey:@"name"];
        self.storeTitle = [coder decodeObjectForKey:@"title"];
        self.storeSubTitle = [coder decodeObjectForKey:@"subtitle"];
        self.imgUrl = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
