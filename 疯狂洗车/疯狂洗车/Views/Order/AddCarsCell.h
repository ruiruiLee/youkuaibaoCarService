//
//  AddCarsCell.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCarsCellDelegate <NSObject>

- (void)didAddCarButtonTouched;

@end

@interface AddCarsCell : UITableViewCell
{
    
}

@property (assign, nonatomic) id <AddCarsCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *opreationTitle;

@end
