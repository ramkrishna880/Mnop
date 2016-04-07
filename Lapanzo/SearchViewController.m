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
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    
    _cityButton.layer.borderColor = [UIColor navigationBarTintColor].CGColor;
    _cityButton.layer.borderWidth = 1.0f;
    
    _localityButton.layer.borderColor = [UIColor navigationBarTintColor].CGColor;
    _localityButton.layer.borderWidth = 1.0f;
}

- (IBAction)dropdownButtonClicked:(id)sender {
    
    [self showDropDownForButton:sender adContents:@[@"Two wrongs don't make a right.",@"No man is an island.",@"Aplhabetic sorting",@"Fortune favors the bold.",@"If it ain't broke, don't fix it.",@"If you can't beat 'em, join 'em.",@"One man's trash is another man's treasure.",@"You can lead a horse to water, but you can't make him drink."] multipleSelection:YES];
    
    //    /[_dropdown reloadDropdownWithContents:self.countries keyPath:@"name" selectedItems:@[_myButton.titleLabel.text]];
}

-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection
{
    
    [_dropdown setDrodownAnimation:rand()%2];
    
    [_dropdown setAllowMultipleSelection:multipleSelection];
    
    [_dropdown setupDropdownForView:sender];
    
    [_dropdown setSeparatorColor:sender.titleLabel.textColor];
    
    if (_dropdown.allowMultipleSelection)
    {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[[sender titleForState:UIControlStateNormal] componentsSeparatedByString:@";"]];
        
    }
    else
    {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:@[[sender titleForState:UIControlStateNormal]]];
        
    }
    
}

#pragma mark - VSDropdown Delegate methods.
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1)
    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
        
    }
    else
    {
        allSelectedItems = [dropDown.selectedItems firstObject];
        
    }
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    UIButton *btn = (UIButton *)dropdown.dropDownView;
    
    return btn.titleLabel.textColor;
    
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 2.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}


#pragma mark webOperations

- (void)fetchCityList {
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=cityList&country=%@",@"india"];
    [self showHUD];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *history = responseObject [@"list"];
        if (!history.count) {
            [self showAlert:nil message:@"No history"];
            return;
        }
        
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}

- (void)fetchAreaList:(NSString *)city {
    NSString *urlStr = [NSString stringWithFormat:@"portal?a=areaList&city=%@",@"Hyderabad"];
    [self showHUD];
    [_client performOperationWithUrl:urlStr  andCompletionHandler:^(NSDictionary *responseObject) {
        [self hideHud];
        NSArray *history = responseObject [@"list"];
        if (!history.count) {
            [self showAlert:nil message:@"No history"];
            return;
        }
        
    } failure:^(NSError *connectionError) {
        [self hideHud];
        [self showAlert:nil message:connectionError.localizedDescription];
    }];
}
@end
