//
//  InsuranceInfoCell.m
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceInfoCell.h"

@implementation InsuranceInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    if (SCREEN_WIDTH < 375)
    {
        _insuranceStatusLabel.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        _insuranceStatusLabel.font = [UIFont systemFontOfSize:16];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didEditButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didEditButtonTouched:)])
    {
        [self.delegate didEditButtonTouched:self.indexPath];
    }
}

- (void)setDisplayInsuranceGroupInfo:(InsuranceGroupModel*)model
{
    _insuranceIdLabel.text = [NSString stringWithFormat:@"订单号：%@",model.insurance_no == nil?@"":model.insurance_no];
    _carNoLabel.text = model.car_no;
    _customerNameLabel.text = model.member_name;
    _recIDLabel.text = model.sb_no;
    _engineIdLabel.text = model.fdj_no;
    _idCardNoLabel.text = model.cid == nil?@"暂无数据":model.cid;
    _phoneLabel.text = model.user_phone;
    _insuranceStatusLabel.text = model.suggest_num.intValue > 0 ?[NSString stringWithFormat:@"现在有%d个保险经纪人报价",model.suggest_num.intValue]:@"正在为您匹配最优的保单报价信息，请稍等...";
//    if (model.isBought)
//    {
//        _editButton.hidden = YES;
//        _isBoughtImageView.hidden = NO;
//    }
//    else
//    {
//        _editButton.hidden = NO;
//        _isBoughtImageView.hidden = YES;
//    }
}
@end
