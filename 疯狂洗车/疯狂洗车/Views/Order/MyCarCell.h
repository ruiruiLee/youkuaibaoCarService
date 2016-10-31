//
//  MyCarCell.h
//  优快保
//
//  Created by cts on 15/3/20.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCarCellDelegate <NSObject>

- (void)didMyCarButtonSelectButtonTouched:(NSIndexPath*)indexPath;

@end

@interface MyCarCell : UITableViewCell
{
    IBOutlet UILabel *_carTypeLabel;
    
    
    
    IBOutlet UILabel *_newPriceLabel;
    
    IBOutlet UILabel *_oldPriceLabel;
}
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) id <MyCarCellDelegate> delegate;

- (void)setDisplayInfo:(NSString*)title
           andNewPrice:(NSString*)newPriceString
           andOldPrice:(NSString*)oldPriceString;

@end
