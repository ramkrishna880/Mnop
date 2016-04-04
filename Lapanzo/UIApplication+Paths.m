//
//  UIApplication+Paths.m
//  Lapanzo
//
//  Created by PTG on 04/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "UIApplication+Paths.h"

@implementation UIApplication (Paths)

+ (NSString *)documentsDirectory {
    return [UIApplication createPathIfNeeded:[UIApplication pathToUserDomain:NSDocumentDirectory]];
}

+ (NSString *)pathToUserDomain:(NSSearchPathDirectory)domainID {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(domainID, NSUserDomainMask, YES);
    return [paths count] ? [paths objectAtIndex:0] : nil;
}

+ (NSString *)createPathIfNeeded:(NSString *)path {
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        BOOL dirCreationSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (!dirCreationSuccess) {
            NSLog(@"Could not create needed application directory: %@\n%@", path, error);
        }
    }
    return path;
}
@end
