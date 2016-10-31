//
//  ServiceTypeHeaderView.h
//  优快保
//
//  Created by cts on 15/4/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceTypeHeaderDelegate <NSObject>

- (void)didServiceTypeSelect:(NSInteger)section;

- (void)didMoreServiceButtonTouched;

@end

@interface ServiceTypeHeaderView : UITableViewHeaderFooterView
{
    
    IBOutlet UIView *_contextView;
}

@property (assign, nonatomic) id <ServiceTypeHeaderDelegate> delegate;

@property (assign, nonatomic) NSInteger sectionIndex;

@property (strong, nonatomic) IBOutlet UIImageView *selectIconImageView;

@property (strong, nonatomic) IBOutlet UILabel *serviceTypeNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *servicePriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *serviceOldPriceLabel;

@property (strong, nonatomic) IBOutlet UIButton *serviceSelectButton;

@end
