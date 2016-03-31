//
//  NSString+Validations.h
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validations)

- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;
- (NSString *)urlencode;
@end


@interface NSString (Formats)
- (NSString *)MD5String;
@end