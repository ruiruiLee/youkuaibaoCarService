//
//  ServiceTypeTableViewCell.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/16.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    enumZjiadaodian,
    enumSmenquche,
} ServiceType;

@class ServiceTypeTableViewCell;

@protocol ServiceTypeTableViewCellDelegate <NSObject>

- (void) NotifyServiceTypeChanged:(ServiceTypeTableViewCell *) object type:(ServiceType) type;

@end

@interface ServiceTypeTableViewCell : UITableViewCell
{
    ServiceType _currentType;
}

@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UIView *sepLine;
@property (nonatomic, strong) IBOutlet UIView *btnBg;
@property (nonatomic, strong) IBOutlet UIButton *btnZJDD;
@property (nonatomic, strong) IBOutlet UIButton *btnSMQC;

@property (nonatomic, assign) id<ServiceTypeTableViewCellDelegate> delegate;

- (void) setCurrentServiceType:(ServiceType) type;

- (ServiceType) obtainServiceType;

@end
