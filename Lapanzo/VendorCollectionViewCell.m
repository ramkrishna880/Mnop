//
//  VendorCollectionViewCell.m
//  Lapanzo
//
//  Created by PTG on 18/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "VendorCollectionViewCell.h"
#import "NSDictionary+Response.h"

@interface VendorCollectionViewCell () {
    NSDictionary *_vendor;
}
@end

@implementation VendorCollectionViewCell

- (void)awakeFromNib {
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


- (void)setVendor:(NSDictionary *)vendor {
    if (vendor == _vendor) {
        return;
    }
    _vendor = vendor;
    self.imgView.image = [UIImage imageNamed:@"placeholder"];
    self.vendorName.text = vendor.vendor;
}

@end
