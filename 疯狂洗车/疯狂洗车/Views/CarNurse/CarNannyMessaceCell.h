//
//  CarNannyMessaceCell.h
//  优快保
//
//  Created by cts on 15/4/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NannyModel.h"

@protocol CarNannyMessaceCellDelegate <NSObject>

- (void)didSelectAndShowBigImage:(NSIndexPath*)indexPath andImageIndex:(NSInteger)imageIndex;

@end

@interface CarNannyMessaceCell : UITableViewCell
{
    
    IBOutlet UILabel *_contentLabel;
    
    IBOutlet UILabel *_timeLabel;
    
    IBOutlet UILabel *_phoneLabel;
    
    IBOutlet UILabel *_replyLabel;
    
    IBOutlet UILabel *_replyTimeLabel;
    
    IBOutlet UILabel *_replyNameLabel;
    
    IBOutlet UIView  *_imageDisplayView;
    
}

- (void)setDisplayInfo:(NannyModel*)model;

@property (assign, nonatomic) id <CarNannyMessaceCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
