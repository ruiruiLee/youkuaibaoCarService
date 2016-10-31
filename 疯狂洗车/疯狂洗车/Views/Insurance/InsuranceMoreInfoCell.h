//
//  InsuranceMoreInfoCell.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsuranceMoreInfoCell : UITableViewCell
{
    
    IBOutlet UIImageView *_cellIconImageView;
    
    IBOutlet UITextField *_cellContentField;
}

- (void)setDisplayMoreInfo:(NSString*)conetnt
              withCellType:(NSInteger)cellType
        andPlaceHolderText:(NSString*)placeHolderText;

@end
