//
//  InsuranceListSuggestEmptyCell.h
//  疯狂洗车
//
//  Created by cts on 15/11/27.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InsuranceListSuggestEmptyCellDelegate <NSObject>

- (void)didInsuranceSelectButtonTouched:(NSIndexPath*)indexPath;

@end

@interface InsuranceListSuggestEmptyCell : UITableViewCell
{
    
    IBOutlet UIButton *_insuranceSelectButton;
    
    IBOutlet UIView *_infoDisplayView;
}

@property (assign, nonatomic) id <InsuranceListSuggestEmptyCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
