//
//  PersonOutView.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface PersonOutView : UIView
{
    
    IBOutlet UIImageView *_personImageView;
    
    IBOutlet UILabel     *_nameLabel;
    
    IBOutlet TQStarRatingView *_starRatingView;
}


@end
