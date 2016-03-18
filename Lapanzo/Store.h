//
//  Store.h
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject
//@property (nonatomic) NSString *storeName;
//@property (nonatomic) NSString *storeYears;

//New
@property (nonatomic) NSNumber *storeId;
@property (nonatomic) NSString *storeName;
@property (nonatomic) NSString *storeTitle;
@property (nonatomic) NSString *storeSubTitle;
@property (nonatomic) NSString *imgUrl;

- (instancetype)initStorewithDictionary:(NSDictionary *)dictionary;
@end
