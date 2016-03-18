//
//  Constants.h
//  BIGEO
//
//  Created by PTG on 11/02/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//Seagues

//static NSString *const HOMEVIEW_SEGUE = @"loginVcSegueId";
//static NSString *const INDICATORDETAIL_SEGUE = @"indicatorDetailSugueId";
static NSString *const LOGIN_SEGUE = @"loginVcSegueId";
static NSString *const CATEGORY_SEGUE = @"categoryVcSegueId";
static NSString *const STORE_SEGUE = @"storesviewSegueId";

static NSString *const CATEGORY_SEGUEID = @"homeViewSegueId";
static NSString *const CATEGORY_REG_SEGUEID = @"homeFromRegisterSegueId";

//
//view IDs
static NSString *const POPOVER_VIEWID = @"popoverVcId";
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

#pragma mark CellIds

static NSString *const STORE_COLLCCELLID = @"CategoryCollectionViewCellId";
static NSString *const STORES_TABLECELLID = @"StoresTableViewCellId";
static NSString *const VENDOR_COLLECCELLID = @"VendorCollectionViewCellId";


#pragma mark dataAccess
static NSString *const ISLOGGED_KEY = @"isLogged";
static NSString *const USERID_KEY = @"userID";
static NSString *const USER_DETAILS = @"userDetails";


#pragma mark Others

#define KeyboardMoveHeightConstant -40.0
#define LogoTopConstant 40.0

#endif /* Constants_h */
