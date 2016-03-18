//
//  NSDictionary+Response.m
//  Lapanzo
//
//  Created by PTG on 14/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "NSDictionary+Response.h"

@implementation NSDictionary (Response)


#pragma mark Login

- (NSString *)status {
    return self[@"status"];
}

- (NSString *)message {
    return self[@"msg"];
}

- (NSString *)userId {
    return self[@"userid"];
}


#pragma mark vendors

- (NSNumber *)vendorId {
    NSString *vndrid = self[@"id"];
    NSNumber *vId = @(vndrid.integerValue);
    return vId;
}

- (NSString *)vendor {
    return self[@"ven"];
}

#pragma mark User details 

- (NSString *)userName {
    return self[@"username"];
}
- (NSString *)userEmail {
    return self[@"em"];
}
- (NSNumber *)mobileNo {
    NSString *no = self[@"mobile"];
    NSNumber *mblNo = @(no.integerValue);
    return mblNo;
}
- (NSString *)mobilenOverifiedStatus {
    return self[@"mobileverified"];
}
- (NSString *)walletBalance {
    return self[@"walletbalance"];
}
- (NSString *)referringcode {
    return self[@"referringcode"];
}
- (NSString *)profileimage {
    return self[@"profileimage"];
}

@end
