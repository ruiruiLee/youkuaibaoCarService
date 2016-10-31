//
//  CarBrandSelectViewController.m
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarBrandSelectViewController.h"
#import "CarBrandCell.h"
#import "CarSeriesModel.h"
#import "CarKindModel.h"
#import "POAPinyin.h"
#import "NSString+Pinyin.h"
#import "DBManager.h"
#import "MBProgressHUD+Add.h"
#import "WebServiceHelper.h"


@interface CarBrandSelectViewController ()

@end

@implementation CarBrandSelectViewController

static NSString *cellIdentifier1 = @"CarBrandCell";

static NSString *cellIdentifier2 = @"CarModelCell";

static NSString *cellIdentifier3 = @"CarSubModelCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _carBrandArray = [NSMutableArray array];
    _carModelArray = [NSMutableArray array];
    _carSubModelArray = [NSMutableArray array];
    
    [self setTitle:@"选择车型号"];
    
    [_carBrandTableView registerNib:[UINib nibWithNibName:cellIdentifier1
                                                   bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:cellIdentifier1];
    
    _carBrandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _carModelView.layer.shadowPath =[UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds].CGPath;
    _carModelView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    _carModelView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _carModelView.layer.shadowOpacity = 0.8;//不透明度
    _carModelView.layer.shadowRadius = 2.0;//半径
    
    _carSubModelView.layer.shadowPath =[UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds].CGPath;
    _carSubModelView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    _carSubModelView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _carSubModelView.layer.shadowOpacity = 0.8;//不透明度
    _carSubModelView.layer.shadowRadius = 2.0;//半径

    if ([[NSUserDefaults standardUserDefaults] boolForKey:kCarBrandNeedUpdate])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self updateDBBrand];//更新本地数据库车品牌数据
    }
    else  if ([[NSUserDefaults standardUserDefaults] boolForKey:kCarSeriesNeedUpdate])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self updateDBSeries];//更新本地数据库车系列数据
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:kCarKindNeedUpdate])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self updateDBKind];//更新本地数据库车型号数据
    }
    else
    {
        [self loadAllBrandData];
    }

    
    _carModelView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    _carModelView.hidden = YES;
    _carSubModelView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    _carSubModelView.hidden = YES;
    
    UIPanGestureRecognizer *modelPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnModelView:)];
    [_carModelView addGestureRecognizer:modelPanGestureRecognizer];

    UIPanGestureRecognizer *subModelPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnSubModelView:)];
    [_carSubModelView addGestureRecognizer:subModelPanGestureRecognizer];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAllBrandData
{
    NSArray *brandNameArray = [DBManager getAllCarBrands];
    
    if (brandNameArray .count > 0)
    {
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (int x = 0; x<brandNameArray.count; x++)
        {
            CarBrandModel *model = [[CarBrandModel alloc] initWithDictionary:brandNameArray[x]];
            [tmpArray addObject:model];
        }
        [self sequencingChineseName:tmpArray];
    }
}

#pragma mark - UITableViewDelegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _carBrandTableView)
    {
        return _carBrandArray.count;
    }
    else if (tableView == _carModelTableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _carBrandTableView)
    {
        return 20;
    }
    else if (tableView == _carModelTableView)
    {
        return 0;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _carBrandTableView)
    {
        NSDictionary *englishDic = [_carBrandArray objectAtIndex:section];
        

        return [NSString stringWithFormat:@"%@",[englishDic objectForKey:@"initial"]];
    }
    else if (tableView == _carModelTableView)
    {
        return nil;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _carBrandTableView)
    {
        NSDictionary *englishDic = [_carBrandArray objectAtIndex:section];
        NSArray *tmpArray = [englishDic objectForKey:@"brands"];
        if ([tmpArray count] == 0)
        {
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }
        else
        {
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
        return [tmpArray count];
    }
    else if (tableView == _carModelTableView)
    {
        return _carModelArray.count;
    }
    else
    {
        return _carSubModelArray.count;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if (tableView == _carBrandTableView)
    {
        return  @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    }
    else if (tableView == _carModelTableView)
    {
        return nil;
    }
    else
    {
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = -1;
    for (int x = 0; x<_carBrandArray.count; x++)
    {
        NSDictionary *englishDic = [_carBrandArray objectAtIndex:x];
        if ([title isEqualToString:[englishDic objectForKey:@"initial"]])
        {
            count = x;
        }
    }
    
    return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _carBrandTableView)
    {
        NSDictionary *englishDic = [_carBrandArray objectAtIndex:indexPath.section];
        NSArray *tmpArray = [englishDic objectForKey:@"brands"];
        CarBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        if (cell == nil)
        {
            cell = [[CarBrandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        }
        
        CarBrandModel *model = tmpArray[indexPath.row];
        
        [cell setDisplayInfo:model];
        
        return cell;
    }
    else if (tableView == _carModelTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        }
        
        CarSeriesModel *model = _carModelArray[indexPath.row];
        [cell.textLabel setText:model.NAME];
        cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;
        
        
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        }
        
        CarKindModel *model = _carSubModelArray[indexPath.row];
        [cell.textLabel setText:model.NAME];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _carBrandTableView)
    {
       // [self showOrHideModelView:NO];
        [self showOrHideSubModelView:NO];
        NSDictionary *englishDic = [_carBrandArray objectAtIndex:indexPath.section];
        NSArray *tmpArray = [englishDic objectForKey:@"brands"];

        CarBrandModel *model = tmpArray[indexPath.row];
        _carBrandLabel.text = model.NAME;
        if (_carModelArray.count > 0)
        {
            [_carModelArray removeAllObjects];
        }
        NSArray *seriesArray = [DBManager getCarSeriesByBrandID:model.BRAND_ID];
        if (seriesArray.count > 0)
        {
            for (int x = 0; x<seriesArray.count; x++)
            {
                CarSeriesModel *model = [[CarSeriesModel alloc] initWithDictionary:seriesArray[x]];
                [_carModelArray addObject:model];
            }
        }
        [self showOrHideModelView:YES];
        [_carModelTableView reloadData];
        
    }
    else if (tableView == _carModelTableView)
    {
      //  [self showOrHideSubModelView:NO];
        CarSeriesModel *model = _carModelArray[indexPath.row];
        
        
        if ([self.delegate respondsToSelector:@selector(didFinishCarBrandSelect:andBrandId:andKuanshi:andXilie:andSeriesId:)])
        {
            NSDictionary *englishDic = [_carBrandArray objectAtIndex:_carBrandTableView.indexPathForSelectedRow.section];
            NSArray *tmpArray = [englishDic objectForKey:@"brands"];
            
            CarBrandModel *brandModel = tmpArray[_carBrandTableView.indexPathForSelectedRow.row];
            

            [self.delegate didFinishCarBrandSelect:brandModel.NAME andBrandId:brandModel.BRAND_ID andKuanshi:model.NAME andXilie:nil andSeriesId:model.SERIES_ID];

            [self.navigationController popViewControllerAnimated:YES];
        }        
        return;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didFinishCarBrandSelect:andBrandId:andKuanshi:andXilie:andSeriesId:)])
        {
            NSDictionary *englishDic = [_carBrandArray objectAtIndex:_carBrandTableView.indexPathForSelectedRow.section];
            NSArray *tmpArray = [englishDic objectForKey:@"brands"];
            
            CarBrandModel *brandModel = tmpArray[_carBrandTableView.indexPathForSelectedRow.row];
            
            CarSeriesModel *subModel = _carModelArray[_carModelTableView.indexPathForSelectedRow.row];
            CarKindModel *model = _carSubModelArray[indexPath.row];

            [self.delegate didFinishCarBrandSelect:brandModel.NAME andBrandId:brandModel.BRAND_ID andKuanshi:subModel.NAME andXilie:model.NAME andSeriesId:subModel.SERIES_ID];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)showOrHideModelView:(BOOL)isShow
{
    if (isShow)
    {
        _carModelView.hidden = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _carModelView.transform = CGAffineTransformIdentity;
                             
                             _carModelView.userInteractionEnabled = NO;
        }
                         completion:^(BOOL finished)
        {
            if (finished)
            {
                _carModelView.userInteractionEnabled = YES;
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             _carModelView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
                             _carModelView.userInteractionEnabled = NO;
                         }
                         completion:^(BOOL finished)
         {
             if (finished)
             {
                 _carModelView.userInteractionEnabled = YES;
                 _carModelView.hidden = YES;
             }
         }];
    }
}

- (void)showOrHideSubModelView:(BOOL)isShow
{
    if (isShow)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             _carSubModelView.hidden = NO;
                             _carSubModelView.transform = CGAffineTransformIdentity;
                             _carSubModelView.userInteractionEnabled = NO;
                         }
                         completion:^(BOOL finished)
         {
             if (finished)
             {
                 _carSubModelView.userInteractionEnabled = YES;
                 _carModelView.userInteractionEnabled = NO;
             }
         }];
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             _carSubModelView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
                             _carSubModelView.userInteractionEnabled = NO;

                         }
                         completion:^(BOOL finished)
         {
             if (finished)
             {
                 _carSubModelView.userInteractionEnabled = YES;
                 _carModelView.userInteractionEnabled = YES;
                 _carSubModelView.hidden = YES;

             }
         }];
    }
}

- (void)didPanOnModelView:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        float transX = [recognizer translationInView:_carModelView].x;
        if (transX > 0)
        {
            _carModelView.transform = CGAffineTransformMakeTranslation(transX, 0);
        }
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        float transX = [recognizer translationInView:_carModelView].x;
        NSLog(@"end %f",transX);
        if (transX > 60)
        {
            [self showOrHideModelView:NO];
        }
        else
        {
            [self showOrHideModelView:YES];
        }
    }
}

- (void)didPanOnSubModelView:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        float transX = [recognizer translationInView:_carModelView].x;
        if (transX > 0)
        {
            _carSubModelView.transform = CGAffineTransformMakeTranslation(transX, 0);
        }
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        float transX = [recognizer translationInView:_carSubModelView].x;
        NSLog(@"end %f",transX);
        if (transX > 60)
        {
            [self showOrHideSubModelView:NO];
        }
        else
        {
            [self showOrHideSubModelView:YES];
        }
    }
}

- (void)sequencingChineseName:(NSArray*)target
{
    NSLog(@"start:%ld",time(NULL));
    NSMutableSet *tmpSet = [NSMutableSet set];
    for (CarBrandModel *model in target)
    {
        [tmpSet addObject:[[POAPinyin quickConvert:model.NAME] substringToIndex:1]];
        
    }
    
    NSArray *initialArray =[[tmpSet allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                            {
                                
                                return [obj1 compare:obj2 options:NSNumericSearch];
                            }];
    
    //    NSLog(@"block1:%ld",time(NULL));
    NSLog(@"得到拼音 %@",initialArray);
    //    NSLog(@"block2:%ld",time(NULL));
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int x=0; x<initialArray.count; x++)
    {
        NSMutableArray *brands = [NSMutableArray array];
        NSString *stringUseForCompare = initialArray[x];
        for (CarBrandModel *model in target)
        {
            if ([[[POAPinyin quickConvert:model.NAME]substringToIndex:1] isEqualToString:stringUseForCompare])
            {
                [brands addObject:model];
            }
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:stringUseForCompare forKey:@"initial"];
        [dict setValue:brands forKey:@"brands"];
        [resultArray addObject:dict];
        //        [resultArray addObject:@{@"initial":stringUseForCompare,
        //                                 @"contacters":contacters}];
    }
    
    //     NSLog(@"block5:%ld",time(NULL));
    
    for (NSMutableDictionary *dict in resultArray)
    {
        NSArray *brandsArray = [dict valueForKey:@"brands"];
        NSArray *newArray = [self sortWithArray:brandsArray];
        [dict setValue:newArray forKey:@"brands"];
    }
    
    _carBrandArray = resultArray;
    [POAPinyin clearCache];
    
    [_carBrandTableView reloadData];
    _carBrandTableView.userInteractionEnabled = YES;
}


#pragma mark -  姓名排序
// 对数组中联系人 按姓名的中文字母进行排序
// array 存放联系人模型的数组
- (NSArray *)sortWithArray:(NSArray *)array
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++)
    {
        CarBrandModel *sortModel = [array objectAtIndex:i];
        if (0 == i)
        {
            [resultArray addObject:sortModel];
            continue;
        }
        int j = 0;
        for (; j<resultArray.count; j++)
        {
            CarBrandModel *model = [resultArray objectAtIndex:j];
            int comp = [self compCheneseString:model.NAME secondString:sortModel.NAME];
            if (0 == comp)
            {
                continue;
            }
            else if (1 == comp)
            {
                [resultArray insertObject:sortModel atIndex:j];
                break;
            }
            else
            {
                [resultArray insertObject:sortModel atIndex:j];
                break;
            }
        }
        if (j == resultArray.count)
        {
            [resultArray addObject:sortModel];
        }
    }
    return [resultArray copy];
}

// 返回 0 firt < sec
// 1 firt == sec
//  2 firt > sec
- (int)compCheneseString:(NSString *)firtString secondString:(NSString *)secString
{
    int k = 0;
    for (;k < firtString.length; k++)
    {
        NSString *word = [firtString substringWithRange:NSMakeRange(k, 1)];
        if (k + 1 > secString.length)
        {
            return 2;
        }
        NSString *sortWord = [secString substringWithRange:NSMakeRange(k, 1)];
        NSString *wordPin = [POAPinyin quickConvert:word];
        NSString *sortWordPin = [POAPinyin quickConvert:sortWord];
        NSComparisonResult compResult = [wordPin compare:sortWordPin];
        if (compResult == NSOrderedSame)
        {
            continue;
        }
        else if (compResult == NSOrderedAscending)
        {
            return 0;
        }
        else
        {
            return 2;
        }
    }
    if (secString.length > k)
    {
        return 0;
    }
    else if (secString.length == k)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (void)updateDBBrand
{
    NSDictionary *submitdDic = @{@"ver_no":[[NSUserDefaults standardUserDefaults] objectForKey:kCarBrandVerNo],
                                 @"app_type":@"2"};
    [WebService requestJsonOperationWithParam:submitdDic
                                       action:@"system/service/update/brand"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             NSArray *result = data;
             NSLog(@"%@",data);
             NSMutableArray *insertArray = [NSMutableArray array];
             
             for (int x = 0; x<result.count; x++)
             {
                 NSDictionary *tmpDic = result[x];
                 
                 CarBrandModel *model = [[CarBrandModel alloc] init];
                 model.BRAND_ID = [tmpDic objectForKey:@"brand_id"];
                 model.LETTER = [tmpDic objectForKey:@"letter"];
                 model.LOGO = [tmpDic objectForKey:@"logo"];
                 model.NAME = [tmpDic objectForKey:@"name"];
                 model.VER_NO = [tmpDic objectForKey:@"ver_no"];
                 [insertArray addObject:model];
             }
             [DBManager insertDateToDBforTab:0
                                   withArray:insertArray
                                      result:^{
                                          CarBrandModel *model = [insertArray lastObject];
                                          [[NSUserDefaults standardUserDefaults] setObject:model.VER_NO forKey:kCarBrandVerNo];
                                          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kCarBrandNeedUpdate];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          if ([[NSUserDefaults standardUserDefaults] boolForKey:kCarSeriesNeedUpdate])
                                          {
                                              [self updateDBSeries];
                                          }
                                          else
                                          {
                                              [self loadAllBrandData];
                                          }
                                      }
                                       error:^{
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [MBProgressHUD showError:@"更新品牌数据库失败" toView:self.view];
                                           [self loadAllBrandData];
                                       }];
             
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"更新品牌数据库失败" toView:self.view];
             [self loadAllBrandData];
         }
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [MBProgressHUD showError:@"更新品牌数据库失败" toView:self.view];
                                [self loadAllBrandData];
                            }];

}

- (void)updateDBSeries
{
    NSDictionary *submitdDic = @{@"ver_no":[[NSUserDefaults standardUserDefaults] objectForKey:kCarSeriesVerNo],
                                 @"app_type":@"2"};
    [WebService requestJsonOperationWithParam:submitdDic
                                       action:@"system/service/update/series"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             NSArray *result = data;
             NSLog(@"%@",data);
             NSMutableArray *insertArray = [NSMutableArray array];
             
             for (int x = 0; x<result.count; x++)
             {
                 NSDictionary *tmpDic = result[x];
                 
                 CarSeriesModel *model = [[CarSeriesModel alloc] init];
                 model.BRAND_ID = [tmpDic objectForKey:@"brand_id"];
                 model.SERIES_ID = [tmpDic objectForKey:@"series_id"];
                 model.NAME = [tmpDic objectForKey:@"name"];
                 model.VER_NO = [tmpDic objectForKey:@"ver_no"];
                 [insertArray addObject:model];
             }
             [DBManager insertDateToDBforTab:1
                                   withArray:insertArray
                                      result:^{
                                          CarSeriesModel *model = [insertArray lastObject];
                                          [[NSUserDefaults standardUserDefaults] setObject:model.VER_NO forKey:kCarSeriesVerNo];
                                          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kCarSeriesNeedUpdate];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          if ([[NSUserDefaults standardUserDefaults] boolForKey:kCarKindNeedUpdate])
                                          {
                                              [self updateDBKind];
                                          }
                                          else
                                          {
                                              [self loadAllBrandData];
                                          }
                                      }
                                       error:^{
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [MBProgressHUD showError:@"更新车系数据库失败" toView:self.view];
                                           [self loadAllBrandData];
                                       }];
             
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"更新车系数据库失败" toView:self.view];
             [self loadAllBrandData];
         }
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [MBProgressHUD showError:@"更新车系数据库失败" toView:self.view];
                                [self loadAllBrandData];
                            }];
}

- (void)updateDBKind
{
    NSDictionary *submitdDic = @{@"ver_no":[[NSUserDefaults standardUserDefaults] objectForKey:kCarKindVerNo],
                                 @"app_type":@"2"};
    [WebService requestJsonOperationWithParam:submitdDic
                                       action:@"system/service/update/kind"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             NSArray *result = data;
             NSMutableArray *insertArray = [NSMutableArray array];
             
             for (int x = 0; x<result.count; x++)
             {
                 NSDictionary *tmpDic = result[x];
                 
                 CarKindModel *model = [[CarKindModel alloc] init];
                 model.KIND_ID = [tmpDic objectForKey:@"kind_id"];
                 model.SERIES_ID = [tmpDic objectForKey:@"series_id"];
                 model.NAME = [tmpDic objectForKey:@"name"];
                 model.VER_NO = [tmpDic objectForKey:@"ver_no"];
                 [insertArray addObject:model];
             }
             [DBManager insertDateToDBforTab:2
                                   withArray:insertArray
                                      result:^{
                                          CarKindModel *model = [insertArray lastObject];
                                          [[NSUserDefaults standardUserDefaults] setObject:model.VER_NO forKey:kCarKindVerNo];
                                          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kCarKindNeedUpdate];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          [self loadAllBrandData];
                                      }
                                       error:^{
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [MBProgressHUD showError:@"更新车款数据库失败" toView:self.view];
                                           [self loadAllBrandData];
                                       }];
             
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"更新车款数据库失败" toView:self.view];
             [self loadAllBrandData];
         }
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [MBProgressHUD showError:@"更新车款数据库失败" toView:self.view];
                                [self loadAllBrandData];
                            }];
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
