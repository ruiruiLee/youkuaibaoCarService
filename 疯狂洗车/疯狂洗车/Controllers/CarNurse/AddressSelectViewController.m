//
//  AddressSelectViewController.m
//  优快保
//
//  Created by cts on 15/4/10.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "AddressSelectViewController.h"
#import "AddressCell.h"

@interface AddressSelectViewController ()<UIGestureRecognizerDelegate>
{
    BOOL _isSearching;
}

@end

@implementation AddressSelectViewController
static NSString *addressCellIdentifier=@"AddressCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"添加服务地址"];
    
    _resultArray = [NSMutableArray array];
    
    [_addressTabelView registerNib:[UINib nibWithNibName:addressCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:addressCellIdentifier];
    
    _searchField.layer.masksToBounds = YES;
    _searchField.layer.cornerRadius = 5;
    _searchField.layer.borderWidth = 1;
    _searchField.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeKeyBoard)];
    tapGesture.delegate = self;
    [_searchDarkView addGestureRecognizer:tapGesture];
    
    NSDictionary *loctionDic = [[NSUserDefaults standardUserDefaults] valueForKey:kLocationKey];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;

    if (loctionDic == nil)
    {
        _userAddress = nil;
    }
    else
    {
        _userAddress = @"定位中";
        NSString *latitudeString = [loctionDic objectForKey:@"latitude"];
        NSString *longitudeString = [loctionDic objectForKey:@"longitude"];

        _userCoordinate = CLLocationCoordinate2DMake(latitudeString.doubleValue, longitudeString.doubleValue);
        
        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        //regeoRequest.searchType = AMapSearchType_ReGeocode;
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:_userCoordinate.latitude longitude:_userCoordinate.longitude];
        regeoRequest.radius = 10000;
        regeoRequest.requireExtension = YES;
        
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeoRequest];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        _userAddress = response.regeocode.formattedAddress;
        [_resultArray addObjectsFromArray:response.regeocode.pois];
        [_addressTabelView reloadData];
        
    }
}


#pragma mark - UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return _resultArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (_userAddress == nil)
        {
            return 70;
        }
        else
        {
            CGSize messageSize = CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT);
            CGSize contentSize =[_userAddress boundingRectWithSize:messageSize
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                     context:nil].size;

            return 52+contentSize.height;
        }

    }
    else
    {
        AMapPOI *poi = _resultArray[indexPath.row];
        CGSize messageSize = CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT);
        CGSize contentSize =[poi.address boundingRectWithSize:messageSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                       context:nil].size;
        
        return 52+contentSize.height;
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addressCellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        if (_userAddress == nil)
        {
            cell.addressLabel.text = @"定位失败";
            cell.nameLabel.text = @"";
        }
        else
        {
            cell.addressLabel.text = _userAddress;
            cell.nameLabel.text = @"当前位置:";
        }
    }
    else
    {
        AMapPOI *poi = _resultArray[indexPath.row];
        cell.nameLabel.text = poi.name;
        cell.addressLabel.text = poi.address;
        NSLog(@"%ld",(long)poi.distance);

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_userAddress isEqualToString:@"定位中"] || _userAddress == nil)
    {
        return;
    }
    LocationModel *model = [[LocationModel alloc] init];
    if (indexPath.section == 0)
    {
        model.addressString = _userAddress;
        model.locationCoordinate = _userCoordinate;
    }
    else
    {
        AMapPOI *poi = _resultArray[indexPath.row];
        model.addressString = [NSString stringWithFormat:@"%@-%@",poi.name,poi.address];
        model.locationCoordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishAddressSelect:)])
    {
        [self.delegate didFinishAddressSelect:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _searchDarkView.hidden = NO;
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeKeyBoard];
    return YES;
}



- (IBAction)didSearchButtonTouch:(id)sender
{
    
    if (_searchField.text == nil||[_searchField.text isEqualToString:@""])
    {
        [Constants showMessage:@"请输入您的服务地址"];
        return;
    }
    [self closeKeyBoard];
    LocationModel *model = [[LocationModel alloc] init];
    model.addressString = _searchField.text;
    model.locationCoordinate = _publicUserCoordinate;
    if ([self.delegate respondsToSelector:@selector(didFinishAddressSelect:)])
    {
        [self.delegate didFinishAddressSelect:model];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)searchTargetAddress:(NSString*)targetString
{
    _isSearching = YES;
    
    AMapPOIAroundSearchRequest *poiRequest = [[AMapPOIAroundSearchRequest alloc] init];
    poiRequest.keywords = targetString;
    poiRequest.requireExtension = YES;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:_userCoordinate.latitude longitude:_userCoordinate.longitude];
    
    //发起POI搜索
    [_search AMapPOIAroundSearch:poiRequest];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    
    NSLog(@"%@",response.suggestion.keywords);
    
    if (_resultArray.count > 0)
    {
        [_resultArray removeAllObjects];
        [_addressTabelView reloadData];
    }
    [_resultArray addObjectsFromArray:response.pois];
    [_addressTabelView reloadData];

}




#pragma mark UIGestureRecognizer Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]] ||
        [touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark - closeKeyBoard

- (void)closeKeyBoard
{
    _searchDarkView.hidden = YES;
    [[self findFirstResponder:self.view]resignFirstResponder];
}

- (UIView *)findFirstResponder:(UIView*)view
{
    for ( UIView *childView in view.subviews )
    {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder])
        {
            return childView;
        }
        UIView *result = [self findFirstResponder:childView];
        if (result) return result;
    }
    return nil;
}



#pragma mark - AMapSearchDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
