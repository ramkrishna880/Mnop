//
//  CategoryCollectionViewCell.h
//  Lapanzo
//
//  Created by PTG on 02/03/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"s


@interface CategoryCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *yearbl;
@property (nonatomic, weak) IBOutlet UILabel *placeLbl;

@property (nonatomic) Store *currentStore;
@end
