//
//  SearchViewController.h
//  Lapanzo
//
//  Created by PTG on 07/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericViewController.h"

@protocol ManualSelectionControllerDelegate <NSObject>
@optional
- (void)selectedCity:(NSString *)city andArea:(NSString *)area;
- (void)didManualLocationSelected:(BOOL)isManual;
@end

@interface SearchViewController : GenericViewController
@property (nonatomic, weak) id <ManualSelectionControllerDelegate> selectionDelegate;
@end
