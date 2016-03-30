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
@property (nonatomic) NSString *plot;
@property (nonatomic) NSString *street;
@property (nonatomic) NSString *area;
@property (nonatomic) NSString *landmark;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *country;
@property (nonatomic) NSString *tagLine;
@property (nonatomic) NSString *businessType;
@property (nonatomic) NSString *cuisineType;
@property (nonatomic) NSString *services;
@property (nonatomic) NSString *facility;
@property (nonatomic) NSString *rating;
@property (nonatomic) NSString *rateMax;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *startTime;
@property (nonatomic) NSString *endTime;
@property (nonatomic) NSString *minOrder;
@property (nonatomic) NSString *comment;
@property (nonatomic) double latitude;
@property (nonatomic, assign) double logitude;


//@property (nonatomic) NSString *storeTitle;
//@property (nonatomic) NSString *storeSubTitle;
//@property (nonatomic) NSString *imgUrl;

- (instancetype)initStorewithDictionary:(NSDictionary *)dictionary;
@end


