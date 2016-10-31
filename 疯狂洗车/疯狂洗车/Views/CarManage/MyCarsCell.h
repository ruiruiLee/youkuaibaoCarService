//
//  MyCarsCell.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MyCarsCellDelegate;
@interface MyCarsCell : UITableViewCell <UIAlertViewDelegate>
{
    IBOutlet UIView *_whiteBg;
}

@property (nonatomic, strong) IBOutlet UIImageView  *iconView;

@property (nonatomic, strong) IBOutlet UILabel      *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel      *typeLabel;

@property (nonatomic, assign) CarInfos              *carInfo;

@property (nonatomic, assign) id <MyCarsCellDelegate> delegate;

@end


@protocol  MyCarsCellDelegate <NSObject>

- (void)deleteCarWithCarInfo:(CarInfos *)carInfo;

- (void)editCarWithCarInfo:(CarInfos *)carInfo;

@end