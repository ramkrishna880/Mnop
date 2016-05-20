//
//  Subcategory.h
//  Lapanzo
//
//  Created by PTG on 17/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subcategory : NSObject
@property (nonatomic) NSNumber *subCategoryId;
@property (nonatomic) NSString *subCategoryName;
@property (nonatomic) NSArray *items;

@property (nonatomic) NSNumber *storeId;
@property (nonatomic) NSString *storeName;

- (instancetype)initWithSubcatogarywithDictionary:(NSDictionary *)dictionary;
@end

/*
 "id": 1
 "name": "Cleaning"
 
 "id": 5
 "name": "Santoor soap"
 "price": 199
 "afterdiscountprice": 185
 "quantity": 1
 "volume": 150
 "unit": "GM"
 "itemcount": 4
 "desc": "item description"
 "img": "http://192.168.2.77/TomWeb/images/9.png"
 */