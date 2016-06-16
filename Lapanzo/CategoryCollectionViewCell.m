//
//  CategoryCollectionViewCell.m
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell
{
    //Store *_store;
}
- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)setCurrentStore:(Store *)currentStore {
    if (currentStore) {
        self.titleLbl.text = currentStore.storeName;
        self.placeLbl.text = currentStore.area;
        //self.placeLbl.text = currentStore.storeSubTitle;
    }
}

@end
