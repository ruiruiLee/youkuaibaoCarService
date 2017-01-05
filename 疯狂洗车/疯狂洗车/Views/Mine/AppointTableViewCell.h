//
//  AppointTableViewCell.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppointTableViewCellDelegate <NSObject>


- (void)didAppointCanceledButtonTouched:(NSInteger) row;

- (void)didAppointPayButtonTouched:(NSInteger) row;

@end


@interface AppointTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbServiceName;
@property (nonatomic, strong) IBOutlet UILabel *lbCarNo;
@property (nonatomic, strong) IBOutlet UILabel *lbServiceType;
@property (nonatomic, strong) IBOutlet UILabel *lbServiceAdd;
@property (nonatomic, strong) IBOutlet UILabel *lbServiceTime;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIButton *btnPay;
@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UILabel *lbAmount;

@property (assign, nonatomic) id <AppointTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger indexPathRow;

@end
