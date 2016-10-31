//
//  ServiceWayCell.h
//  优快保
//
//  Created by cts on 15/4/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceWayCellDelegate <NSObject>

- (void)didServiceWayIntroduceButtonTouched:(NSInteger)cellIndex;

@end

@interface ServiceWayCell : UITableViewCell

@property (assign, nonatomic) id <ServiceWayCellDelegate> delegate;

@property (assign, nonatomic) NSInteger cellIndex;

@property (strong, nonatomic) IBOutlet UIImageView *selectIconImageView;

@property (strong, nonatomic) IBOutlet UILabel *serviceWayNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *servicePriceLabel;

@property (strong, nonatomic) IBOutlet UIButton *serviceIntroduceButton;

@end
