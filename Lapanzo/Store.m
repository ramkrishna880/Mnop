//
//  Store.m
//  Lapanzo
//
//  Created by PTG on 03/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "Store.h"

@implementation Store


/*
 
 "id": 1
 "name": "Saman Basket"
 "plot": "413"
 "street": "Vth Phase"
 "area": "Banjarahills"
 "landmark": "Miyapur"
 "city": "Hyderabad"
 "state": "Telangana"
 "country": "India"
 "tagline": "Buy online"
 "businesstype": ""
 "cuisinetype": ""
 "services": ""
 "facility": ""
 "rating": "NaN"
 "rateMax": "5"
 "restaurantStatus": "open"
 "start": "12:00 AM"
 "end": "12:00 AM"
 "minOrder": 200
 "comment": ""
 "lat": 17.5252
 "lan": 58.1245
 
 */

- (instancetype)initStorewithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid parameter." format:@"This method should not be called if parameter is nil or not an NSDictionary"];
    }
    //remove nulls if in future appears
    if (self == [super init]) {
        self.storeId = dictionary[@"id"];
        self.storeName = dictionary[@"name"];
        self.plot = dictionary[@"plot"];
        self.street = dictionary[@"street"];
        self.area = dictionary[@"area"];
        self.landmark = dictionary [@"landmark"];
        self.city = dictionary [@"city"];
        self.state = dictionary[@"state"];
        self.country = dictionary [@"country"];
        self.tagLine = dictionary [@"tagline"];
        self.businessType = dictionary [@"businesstype"];
        self.cuisineType = dictionary [@"cuisinetype"];
        self.services = dictionary [@"services"];
        self.facility = dictionary [@"facility"];
        self.rating = dictionary [@"rating"];
        self.rateMax = dictionary [@"rateMax"];
        self.status = dictionary [@"restaurantStatus"];
        self.startTime = dictionary [@"start"];
        self.endTime = dictionary [@"end"];
        self.minOrder = dictionary [@"minOrder"];
        self.comment = dictionary [@"comment"];
        self.latitude = ((NSString *)dictionary [@"lat"]).doubleValue;
        self.logitude = ((NSString *)dictionary [@"lan"]).doubleValue;
        
//        self.storeTitle = dictionary[@"title"];
//        self.storeSubTitle = dictionary[@"subtitle"];
//        self.imgUrl = dictionary[@"img"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_storeId forKey:@"storeId"];
    [coder encodeObject:_storeName forKey:@"name"];
//    [coder encodeObject:_storeTitle forKey:@"title"];
//    [coder encodeObject:_storeSubTitle forKey:@"subtitle"];
//    [coder encodeObject:_imgUrl forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.storeId = [coder decodeObjectForKey:@"storeId"];
        self.storeName = [coder decodeObjectForKey:@"name"];
//        self.storeTitle = [coder decodeObjectForKey:@"title"];
//        self.storeSubTitle = [coder decodeObjectForKey:@"subtitle"];
//        self.imgUrl = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
