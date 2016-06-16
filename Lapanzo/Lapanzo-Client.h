//
//  Lapanzo-Client.h
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface Lapanzo_Client : AFHTTPSessionManager
//@property (nonatomic) NSUserDefaults *defaults;
+ (Lapanzo_Client *)sharedClient;

//Methods
- (void)loginWithUrl:(NSString *)urlString andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError *connectionError))failure;
- (void)registrationWithUrl:(NSString *)urlString andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError *connectionError))failure;

- (void)performOperationWithUrl:(NSString *)urlString andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError *connectionError))failure;

//- (void)performPostOperationWithUrl:(NSString *)urlString andParams:(id)params andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError* __nullable connectionError))failure;
@end
