//
//  NSDictionary+Response.h
//  Lapanzo
//
//  Created by PTG on 14/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Response)

//Login
- (NSString *)status;
- (NSString *)message;
- (NSString *)userId;

//vendor
- (NSNumber *)vendorId;
- (NSString *)vendor;

//user details
- (NSString *)userName;
- (NSString *)userEmail;
- (NSNumber *)mobileNo;
- (NSString *)mobilenOverifiedStatus;
- (NSString *)walletBalance;
- (NSString *)referringcode;
- (NSString *)profileimage;
@end
