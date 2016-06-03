//
//  Lapanzo-Client.m
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "Lapanzo-Client.h"
#import "SynthesizeSingleton.h"

#define baseUrl @"http://ec2-52-26-37-114.us-west-2.compute.amazonaws.com/Lapanzo"

@implementation Lapanzo_Client


#pragma mark - Class Methods

+ (Lapanzo_Client *)sharedClient {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
//        return [[self alloc] init];
        return [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    })
}

#pragma mark -
-(id)init {
    if (self = [super init]) {
    }
    return self;
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)loginWithUrl:(NSString *)urlString andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError* __nullable connectionError))failure {
    
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler (responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)registrationWithUrl:(NSString *)urlString andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError *connectionError))failure {
    
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler (responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)performOperationWithUrl:(NSString *)urlString andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError* __nullable connectionError))failure {
    
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler (responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)performPostOperationWithUrl:(NSString *)urlString andParams:(id)params andCompletionHandler:(void (^) (id responseObject))completionHandler  failure:(void (^) (NSError* __nullable connectionError))failure {
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [self.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError * __autoreleasing * error) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:error];
        NSString *argString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return argString;
    }];

    
    [self POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler (responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}





//    if (![AFNetworkReachabilityManager sharedManager].reachable) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Make sure your device is connected to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }

@end
