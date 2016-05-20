//
//  Subcategory.m
//  Lapanzo
//
//  Created by PTG on 17/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "Subcategory.h"
#import "Item.h"


static NSString * const KEY_LISTOFITEMS = @"list";

@implementation Subcategory

- (instancetype)initWithSubcatogarywithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid parameter." format:@"This method should not be called if parameter is nil or not an NSDictionary"];
    }
    //remove nulls if in future appears
    if (self == [super init]) {
        self.subCategoryId = dictionary[@"id"];
        self.subCategoryName = dictionary[@"name"];
        
        NSArray *listofItems = dictionary[KEY_LISTOFITEMS];
        if ([listofItems isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:listofItems.count];
            [listofItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Item *item = [[Item alloc] initWithDictionary:obj];
                item.subcategoryId = self.subCategoryId;
                item.subcategaryName = self.subCategoryName;
                [mutableItems addObject:item];
            }];
            self.items = [[NSArray alloc] initWithArray:mutableItems copyItems:NO];
        }
    }
    return self;
}


@end
