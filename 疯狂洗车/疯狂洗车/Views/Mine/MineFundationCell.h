//
//  MineFundationCell.h
//  疯狂洗车
//
//  Created by cts on 15/12/7.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineFundationCell : UITableViewCell
{
    
    IBOutlet UILabel *_messageLabel;
}


- (void)showMessageCount:(int)count;


@end
