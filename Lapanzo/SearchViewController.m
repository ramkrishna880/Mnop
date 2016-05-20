//
//  SearchViewController.m
//  Lapanzo
//
//  Created by PTG on 07/04/16.
//  Copyright © 2016 People Tech Group. All rights reserved.
//

#import "SearchViewController.h"
#import "VSDropdown.h"
#import "UIColor+Helpers.h"
#import "Lapanzo_Client+DataAccess.h"


@interface SearchViewController () <VSDropdownDelegate> {
    VSDropdown *_dropdown;
}
@property (nonatomic) VSDropdown *dropdown;
@property (nonatomic, weak) IBOutlet UIButton *cityButton;
@property (nonatomic, weak) IBOutlet UIButton *localityButton;

@property (nonatomic) Lapanzo_Client *client;

@property (nonatomic) NSArray *cityList;
@property (nonatomic) NSArray *areaList;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _client = [Lapanzo_Client sharedClient];
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    _dropdown.backgroundColor = [UIColor lightGrayColor];
    [_dropdown setAdoptParentTheme:NO];
    [_dropdown setShouldSortItems:YES];
    
    _cityButton.layer.borderColor = [UIColor navigationBarTintColor].CGColor;
    _cityButton.layer.borderWidth = 1.0f;
    
    _localityButton.layer.borderColor = [UIColor navigationBarTintColor].CGColor;
    _localityButton.layer.borderWidth = 1.0f;
    
    [self fetchCityList];
}

- (IBAction)dropdownButtonClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag > 1) {
        return;
    }
    if (btn.tag == 0) {
        [self showDropDownForButton:sender adContents:_cityList multipleSelection:NO];
    } else {
        [self showDropDownForButton:sender adContents:_areaList multipleSelection:NO];
    }
    
    //[self showDropDownForButton:sender adContents:@[@"Two wrongs don't make a right.",@"No man is an island.",@"Aplhabetic sorting",@"Fortune favors the bold.",@"If it ain't broke, don't fix it.",@"If you can't beat 'em, join 'em.",@"One man's trash is another man's treasure.",@"You can lead a horse to water, but you can't make him drink."] multipleSelection:NO];
    //    /[_dropdown reloadDropdownWithContents:self.countries keyPath:@"name" selectedItems:@[_myButton.titleLabel.text]];
}

- (IBAction)submitActionClicked:(id)sender {
    
    if ([_cityButton.titleLabel.text isEqualToString:@"Select"] || [_localityButton.titleLabel.text isEqualToString:@"Select"]) {
        [self showAlert:nil message:@"plse select all fileds."];
        return;
    }
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setBool:YES forKey:ISMANUALLOCATION];
    
    if (self.selectionDelegate && [self.selectionDelegate respondsToSelector:@selector(didManualLocationSelected:)]) {
        [self.selectionDelegate didManualLocationSelected:YES];
    }
    
    [_client setLastLocationCity:_cityButton.titleLabel.text area:_localityButton.titleLabel.text];
    [self showAlert:nil message:@"Your location has been set now."];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelTapped:(id)sender {
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setBool:NO forKey:ISMANUALLOCATION];
    if (self.selectionDelegate && [self.selectionDelegate respondsToSelector:@selector(didManualLocationSelected:)]) {
        [self.selectionDelegate didManualLocationSelected:NO];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    [_dropdown setDrodownAnimation:rand()%2];
    [_dropdown setAllowMultipleSelection:multipleSelection];
    [_dropdown setupDropdownForView:sender];
    [_dropdown setSeparatorColor:sender.titleLabel.textColor];
    if (_dropdown.allowMultipleSelection) {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[[sender titleForState:UIControlStateNormal] componentsSeparatedByString:@";"]];
    } else {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:@[[sender titleForState:UIControlStateNormal]]];
    }
}

#pragma mark - VSDropdown Delegate methods.
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1) {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    }
    else {
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
    if (btn.tag == 0) {
        [self fetchAreaList:allSelectedItems];
    }
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown {
    UIButton *btn = (UIButton *)dropdown.dropDownView;
    return btn.titleLabel.textColor;
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown {
    return 1.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown {
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown {
    return -2.0;
}


#pragma mark webOperations

- (void)fetchCityList {
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=cityList&country=%@",@"India"];
    [self showHUD];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *citylst = responseObject [@"cities"];
        if (!citylst.count) {
            [self showAlert:nil message:@"No cities found"];
            return;
        }
        _cityList = [[NSArray alloc] initWithArray:citylst];
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}

- (void)fetchAreaList:(NSString *)city {
//    NSString *urlStr = [NSString stringWithFormat:@"portal?a=areaList&city=%@",@"Hyderabad"];
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=areaList&city=%@",city];
    [self showHUD];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *areas = responseObject [@"results"];
        if (!areas.count) {
            [self showAlert:nil message:@"No Areas Found"];
            return;
        }
        _areaList = [[NSArray alloc] initWithArray:areas];
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}
@end
