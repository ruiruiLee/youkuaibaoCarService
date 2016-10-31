//
//  CarNannyMessageViewController.h
//  优快保
//
//  Created by cts on 15/4/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "GCPlaceholderTextView.h"
#import "HeaderFooterTableView.h"

//车大白消息页面
@interface CarNannyMessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    
    IBOutlet UIImageView  *_emptyImageView;
    IBOutlet HeaderFooterTableView  *_messageTableView;
    
    IBOutlet UIView       *_conditionView;
    
    IBOutlet UIScrollView *_conditionItemScrollView;
    
    NSMutableArray        *_itemsArray;
    
    NSMutableArray        *_messageArray;
    

    IBOutlet UISegmentedControl *_typeSegment;
    
    IBOutlet UIButton     *_conditionButton;
    
    IBOutlet UIImageView  *_conditionArrowIcon;
}

@end
