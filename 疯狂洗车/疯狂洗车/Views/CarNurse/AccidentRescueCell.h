//
//  AccidentRescueCell.h
//  疯狂洗车
//
//  Created by cts on 15/11/23.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"

@protocol AccidentRescueCellDelegate <NSObject>

- (void)didPhoneCallButtonTouched;



@end

@interface AccidentRescueCell : UITableViewCell
{
    
    IBOutlet UILabel *_phoneLabel;
    
    IBOutlet UILabel *_accidentRescueDesLabel;
    
    IBOutlet UIImageView *_imageView;
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model;

@property (assign, nonatomic) id <AccidentRescueCellDelegate> delegate;

@end
