//
//  CommentsListController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "HeaderFooterTableView.h"
#import "TQStarRatingView.h"

//车场评价列表页面
@interface CommentsListController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIImageView    *_iconView;
    IBOutlet UILabel        *_titleLabel;
    IBOutlet UILabel        *_addressLabel;
    IBOutlet UILabel        *_nowPriceLabel;
    IBOutlet UILabel        *_commentCountLabel;
    IBOutlet HeaderFooterTableView    *_listTable;
    
    IBOutlet TQStarRatingView *_startRatingView;
    
}

@property (nonatomic, strong) CarWashModel *carWashInfo;

@property (assign, nonatomic) NSInteger    commentType;

@property (assign, nonatomic) BOOL         isButler;

@end
