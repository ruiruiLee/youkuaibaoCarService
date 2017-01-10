//
//  MyTicketCell.m
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MyTicketCell.h"

@implementation MyTicketCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    _ticketNameLabel.adjustsFontSizeToFitWidth  = YES;
    _ticketPriceLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(TicketModel*)model
{
    _ticketNameLabel.text = [model.service_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    _ticketBeginTimeLabel.text = model.begin_time == nil?@"":model.begin_time;
    _ticketEndTimeLabel.text = [NSString stringWithFormat:@"~%@",model.end_time == nil?@"":model.end_time];
    _lbTicketDescribe.text = [NSString stringWithFormat:@"(%@)", model.pack_title];
    _lbMerchantUse.text = model.pack_remark;
    
    NSInteger price = [model.price integerValue];
    if(price == 100000){
        _ticketPriceLabel.text = @"免费";
        _priceTitleLabel.text = @"";
        _lbExplainInfo.text = [model.code_desc stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else if (price >=10000 && price < 100000){
        CGFloat f = price / 10000.0;
        _ticketPriceLabel.text = [NSString stringWithFormat:@"%.1f", f];
        _priceTitleLabel.text = @"折";
        _lbExplainInfo.text = @"";
    }
    else{
        _ticketPriceLabel.text = [NSString stringWithFormat:@"%d",model.price.intValue];
        _priceTitleLabel.text = @"元";
        _lbExplainInfo.text = @"";
    }
    
    if (model.code_status.intValue == 1)
    {
        _ticketStatusImageView.hidden = NO;
        _ticketStatusImageView.highlighted = NO;
        _ticketAbilitySoonIcon.hidden = YES;
        _ticketNameLabel.textColor = [UIColor colorWithRed:96.0/255.0
                                                     green:96.0/255.0
                                                      blue:96.0/255.0
                                                     alpha:1.0];
        _ticketPriceLabel.textColor =
        _priceTitleLabel.textColor = [UIColor colorWithRed:137/255.0
                                                      green:137/255.0
                                                       blue:137/255.0
                                                      alpha:1.0];
    }
    else if (model.code_status.intValue == 2)
    {
        _ticketStatusImageView.hidden = YES;
        _ticketStatusImageView.highlighted = YES;
        _ticketAbilitySoonIcon.hidden = NO;
//        _ticketTimeLabel.textColor = [UIColor colorWithRed:235.0/255.0
//                                                     green:84/255.0
//                                                      blue:1/255.0
//                                                     alpha:1.0];
        _ticketNameLabel.textColor = [UIColor colorWithRed:96.0/255.0
                                                     green:96.0/255.0
                                                      blue:96.0/255.0
                                                     alpha:1.0];
        _ticketPriceLabel.textColor =
        _priceTitleLabel.textColor = [UIColor colorWithRed:137/255.0
                                                      green:137/255.0
                                                       blue:137/255.0
                                                      alpha:1.0];
    }
    else if (model.code_status.intValue == 3)
    {
        _ticketStatusImageView.hidden = NO;
        _ticketStatusImageView.highlighted = YES;
        _ticketAbilitySoonIcon.hidden = YES;
        _ticketNameLabel.textColor = [UIColor colorWithRed:96.0/255.0
                                                     green:96.0/255.0
                                                      blue:96.0/255.0
                                                     alpha:1.0];
        _ticketPriceLabel.textColor =
        _priceTitleLabel.textColor = [UIColor colorWithRed:137/255.0
                                                      green:137/255.0
                                                       blue:137/255.0
                                                      alpha:1.0];
    }
    else
    {
        _ticketStatusImageView.hidden = YES;
        _ticketStatusImageView.highlighted = YES;
        _ticketAbilitySoonIcon.hidden = YES;
        _ticketNameLabel.textColor = [UIColor colorWithRed:235/255.0
                                                     green:84/255.0
                                                      blue:1/255.0
                                                     alpha:1.0];
        _ticketPriceLabel.textColor =
        _priceTitleLabel.textColor = [UIColor colorWithRed:235/255.0
                                                      green:84/255.0
                                                       blue:1/255.0
                                                      alpha:1.0];
    }
    
    if(model.share_status == 1){
        _ticketBgView.image = [UIImage imageNamed:@"bg_myTicket_present"];
    }
    else{
        _ticketBgView.image = [UIImage imageNamed:@"bg_myTicket"];
    }
}




@end
