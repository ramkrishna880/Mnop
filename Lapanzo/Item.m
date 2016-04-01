//
//  Item.m
//  Lapanzo
//
//  Created by PTG on 17/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "Item.h"

@implementation Item

//add subcategory info if needed in future ** append paramaters in method
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid parameter." format:@"This method should not be called if parameter is nil or not an NSDictionary"];
    }
    if (self = [super init]) {
        //remove for nulls in future if appears
        self.itemId = dictionary[@"id"];
        self.name = dictionary [@"name"];
        self.price = [NSString stringWithFormat:@"%@",dictionary [@"price"]];
        self.priceAfterDiscount = [NSString stringWithFormat:@"%@",dictionary[@"afterdiscountprice"]];
        self.quantity = [NSString stringWithFormat:@"%@",dictionary[@"quantity"]];
        self.volume = [NSString stringWithFormat:@"%@",dictionary[@"volume"]];
        self.unit = dictionary[@"unit"];
        self.itemCount = [NSString stringWithFormat:@"%@",dictionary [@"itemcount"]];
        self.itemDescription = dictionary [@"desc"];
        self.image = dictionary[@"img"];
        
        self.noOfItems = @(0).stringValue;
        
        //add subcategory info if needed in future
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_itemId forKey:@"itemId"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_name forKey:@"price"];
    [coder encodeObject:_name forKey:@"priceAfterDiscount"];
    [coder encodeObject:_name forKey:@"quantity"];
    [coder encodeObject:_name forKey:@"volume"];
    [coder encodeObject:_name forKey:@"unit"];
    [coder encodeObject:_name forKey:@"itemCount"];
    [coder encodeObject:_name forKey:@"itemDes"];
    [coder encodeObject:_name forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.itemId = [coder decodeObjectForKey:@"itemId"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.price = [coder decodeObjectForKey:@"price"];
        self.priceAfterDiscount = [coder decodeObjectForKey:@"priceAfterDiscount"];
        self.quantity = [coder decodeObjectForKey:@"quantity"];
        self.volume = [coder decodeObjectForKey:@"volume"];
        self.unit = [coder decodeObjectForKey:@"unit"];
        self.itemCount = [coder decodeObjectForKey:@"itemCount"];
        self.itemDescription = [coder decodeObjectForKey:@"itemDes"];
        self.image = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

- (NSString *)quantityval {
    return [NSString stringWithFormat:@"%@ %@",_volume,_unit];
}


/*
 NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
 NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"savedArray"];
 if (dataRepresentingSavedArray != nil)
 {
 NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
 if (oldSavedArray != nil)
 objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
 else
 objectArray = [[NSMutableArray alloc] init];
 }
 
 
 [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:objectArray] forKey:@"savedArray"];
 
 */

@end
//
// "id": 1
// "name": "Cleaning"
//
// "id": 5
// "name": "Santoor soap"
// "price": 199
// "afterdiscountprice": 185
// "quantity": 1
// "volume": 150
// "unit": "GM"
// "itemcount": 4
// "desc": "item description"
// "img": "http:192.168.2.77/TomWeb/images/9.png"
