//
//  AccidentRescueCell.m
//  疯狂洗车
//
//  Created by cts on 15/11/23.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "AccidentRescueCell.h"
#import "UIImageView+WebCache.h"

@implementation AccidentRescueCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model
{
    _phoneLabel.text = [NSString stringWithFormat:@"服务热线：%@",model.phone];
    
    _accidentRescueDesLabel.text = [NSString stringWithFormat:@"%@",model.introduction];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.accident_rescue_img_url]
                  placeholderImage:[UIImage imageNamed:@"img_accidentRescue_logo_default"]];
    
}
- (IBAction)didPhoneCallButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPhoneCallButtonTouched)])
    {
        [self.delegate didPhoneCallButtonTouched];
    }
}

@end
