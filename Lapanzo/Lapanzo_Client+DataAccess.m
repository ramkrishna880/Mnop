//
//  Lapanzo_Client+DataAccess.m
//  Lapanzo
//
//  Created by PTG on 09/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.


#import "Lapanzo_Client+DataAccess.h"
#import "Constants.h"


@implementation Lapanzo_Client (DataAccess)

#pragma mark get

- (BOOL)isLogged {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGGED_KEY];
}

- (NSString *)userId {
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:USERID_KEY];
    return userId ? userId : nil;
}

- (NSDictionary *)userDetails {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DETAILS];
    return dic ? dic : nil;
}

#pragma mark set

- (void)setIsLogged:(BOOL)isloggedIn {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:isloggedIn forKey:ISLOGGED_KEY];
    [standardUserDefaults synchronize];
}

- (void)setUserId:(NSString *)userId {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (userId) {
        [standardUserDefaults setValue:userId forKey:USERID_KEY];
    } else {
        [standardUserDefaults removeObjectForKey:USERID_KEY];
    }
    [standardUserDefaults synchronize];
}

- (void)setUserDetails:(NSDictionary *)dic {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (dic) {
        [standardUserDefaults setObject:dic forKey:USER_DETAILS];
    } else {
        [standardUserDefaults removeObjectForKey:USER_DETAILS];
    }
    [standardUserDefaults synchronize];
}

@end