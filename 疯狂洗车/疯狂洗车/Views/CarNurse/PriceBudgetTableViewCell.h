//
//  PriceBudgetTableViewCell.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/16.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceBudgetTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UIView *sepLine;
@property (nonatomic, strong) IBOutlet UIImageView *shutImgV;
@property (nonatomic, strong) IBOutlet UILabel *lbContent;

@end
