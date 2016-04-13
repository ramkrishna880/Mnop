//
//  Lapanzo_Client+DataAccess.h
//  Lapanzo
//
//  Created by PTG on 09/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "Lapanzo-Client.h"

#define LATITUDEKEY  @"Latitude"
#define LOGITUDEKEY @"Logitude"

#define CITYKEY  @"city"
#define AREAKEY @"area"

@interface Lapanzo_Client (DataAccess)

#pragma mark Get
- (BOOL)isLogged;
- (NSString *)userId;
- (NSDictionary *)userDetails;
- (NSMutableArray *)cartItems;
- (NSUInteger)cartItemsCount;
- (NSDictionary *)locationDetails;
- (NSDictionary *)manualLocation;

#pragma mark Set
- (void)setIsLogged:(BOOL)isloggedIn;
- (void)setUserId:(NSString *)userId;
- (void)setUserDetails:(NSDictionary *)dic;
- (void)setCartItems:(NSMutableArray *)cartItems;
- (void)setLocationLatitude:(double)latitude logitude:(double)longitude;
- (void)setLastLocationCity:(NSString *)city area:(NSString *)area;
@end
