//
//  VendorCollectionViewCell.h
//  Lapanzo
//
//  Created by PTG on 18/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *vendorName;

@property (nonatomic) NSDictionary *vendor;
@end
