//
//  VendorCollectionViewCell.m
//  Lapanzo
//
//  Created by PTG on 18/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "VendorCollectionViewCell.h"
#import "NSDictionary+Response.h"
#import "LCollectionLayoutAttributes.h"

@interface VendorCollectionViewCell () {
    NSDictionary *_vendor;
}
@end

@implementation VendorCollectionViewCell

- (void)awakeFromNib {
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
}


- (void)setVendor:(NSDictionary *)vendor {
    if (vendor == _vendor) {
        return;
    }
    _vendor = vendor;
    
    UIImage *img = [UIImage imageNamed:vendor.vendor];
    if (img) {
        self.imgView.image = img;
    } else {
        self.imgView.image = [UIImage imageNamed:@"placeholder"];
    }
    self.vendorName.text = vendor.vendor;
}


- (void)applyLayoutAttributes:(LCollectionLayoutAttributes *)pose {
    [super applyLayoutAttributes:pose];
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] init];
    }
    self.backgroundView.backgroundColor = pose.backgroundColor;
}
@end
