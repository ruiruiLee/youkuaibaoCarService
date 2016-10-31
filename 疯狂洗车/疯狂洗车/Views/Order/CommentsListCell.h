//
//  CommentsListCell.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TQStarRatingView;
@interface CommentsListCell : UITableViewCell
{
    
}

@property (nonatomic, strong) IBOutlet TQStarRatingView *scoreView;
@property (nonatomic, strong) IBOutlet UILabel          *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel          *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel          *commentsLabel;


@end
