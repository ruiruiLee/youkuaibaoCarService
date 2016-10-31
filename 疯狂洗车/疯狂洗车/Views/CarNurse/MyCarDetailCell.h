//
//  MyCarCell.h
//  优快保
//
//  Created by cts on 15/3/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfos.h"

@protocol MyCarDetailCellDelegate <NSObject>

- (void)didMyCarButtonSelectButtonTouched:(NSIndexPath*)indexPath;

@end

@interface MyCarDetailCell : UITableViewCell
{
    
    IBOutlet UILabel *_carDetailLabel;
    
    IBOutlet UILabel *_carBrandLabel;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) id <MyCarDetailCellDelegate> delegate;

- (void)setDisplayInfo:(CarInfos*)carsModel;


@end
