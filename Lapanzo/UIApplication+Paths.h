//
//  UIApplication+Paths.h
//  Lapanzo
//
//  Created by PTG on 04/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Paths)

+ (NSString *)documentsDirectory;
+ (NSString *)pathToUserDomain:(NSSearchPathDirectory)domainID;
+ (NSString *)createPathIfNeeded:(NSString *)path;
@end
