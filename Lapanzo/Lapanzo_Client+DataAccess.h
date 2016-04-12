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

@interface Lapanzo_Client (DataAccess)

#pragma mark Get
- (BOOL)isLogged;
- (NSString *)userId;
- (NSDictionary *)userDetails;
- (NSMutableArray *)cartItems;
- (NSUInteger)cartItemsCount;
- (NSMutableArray *)locationDetails;

#pragma mark Set
- (void)setIsLogged:(BOOL)isloggedIn;
- (void)setUserId:(NSString *)userId;
- (void)setUserDetails:(NSDictionary *)dic;
- (void)setCartItems:(NSMutableArray *)cartItems;
- (void)setLocationLatitude:(double)latitude logitude:(double)longitude;
@end
