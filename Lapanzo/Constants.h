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

static NSString *const LOGIN_SEGUE = @"loginVcSegueId";
static NSString *const CATEGORY_SEGUE = @"categoryVcSegueId";
static NSString *const STORE_SEGUE = @"storesviewSegueId";

static NSString *const CATEGORY_SEGUEID = @"homeViewSegueId";
static NSString *const CATEGORY_REG_SEGUEID = @"homeFromRegisterSegueId";
static NSString *const CATEGORY_NAV_SEGUEID = @"navigationCategorySegueId";

static NSString *const STOREDETAIL_SEGUEID = @"storeDetailSegueId";
static NSString *const CART_SEGUEID = @"cartSegueId";
static NSString *const PAYMENT_SEGUEID = @"paymetsegueId";
static NSString *const SEARCHM_STORYBOARDID = @"searchviewid";
static NSString *const SEARCH_SEGUEID = @"searchlocationSegueId";

//view IDs
static NSString *const POPOVER_VIEWID = @"popoverVcId";
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

//searchlocationSegueId

#pragma mark CellIds

static NSString *const STORE_COLLCCELLID = @"CategoryCollectionViewCellId";
static NSString *const STORES_TABLECELLID = @"StoresTableViewCellId";
static NSString *const VENDOR_COLLECCELLID = @"VendorCollectionViewCellId";
static NSString *const PAYMENTHIS_TABLECELLID = @"paymentAddressHistory";
static NSString *const HISTORY_TABLECELLID = @"paymentAddressHistory";
static NSString *const FLOWERS_COLLCCELLID = @"FlowerCollectionCellId";


#pragma mark dataAccess
static NSString *const ISLOGGED_KEY = @"isLogged";
static NSString *const USERID_KEY = @"userID";
static NSString *const USER_DETAILS = @"userDetails";
static NSString *const CARTITEMS_KEY = @"cartValueskey";
static NSString *const LOCATION_KEY = @"latitudeLogitudeValueskey";
static NSString *const MANUALLOCATION_KEY = @"locationKey";

#pragma mark Others
static NSString *const USERDETAILSFETCHEDNOTIFICATION = @"userDetailsfetched";
#define KeyboardMoveHeightConstant -40.0
#define LogoTopConstant 40.0

static NSString *const ISMANUALLOCATION = @"isManualLoacation";

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define INSTANTIATE(viewController) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:viewController];


#define WEATHERAPIKEY @"8b1a5942ff26021d76c4ec7b6c9930c5"

#endif /* Constants_h */
