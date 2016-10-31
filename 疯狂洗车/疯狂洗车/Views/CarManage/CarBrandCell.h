//
//  CarBrandCell.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBrandModel.h"

@interface CarBrandCell : UITableViewCell
{
    
    IBOutlet UIImageView *_brandIcon;
    
    IBOutlet UILabel     *_brandNameLabel;
        
}

- (void)setDisplayInfo:(CarBrandModel*)brandModel;

@end
