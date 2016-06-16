//
//  Item.h
//  Lapanzo
//
//  Created by PTG on 17/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Item : NSObject
@property (nonatomic) NSNumber *itemId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *priceAfterDiscount;
@property (nonatomic) NSString *quantity;
@property (nonatomic) NSString *volume;
@property (nonatomic) NSString *unit;
@property (nonatomic) NSString *itemCount;
@property (nonatomic) NSString *itemDescription;
@property (nonatomic) NSString *image;

@property (nonatomic) NSString *noOfItems;

//Optional depends May be in future
@property (nonatomic) NSNumber *subcategoryId;
@property (nonatomic) NSString *subcategaryName;

@property (nonatomic) NSNumber *storeId;
@property (nonatomic) NSNumber *categoryId;

//
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)quantityval;
@end

