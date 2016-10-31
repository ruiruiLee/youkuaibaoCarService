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
    if (SCREEN_WIDTH < 375)
    {
        _componyNameLabel.font = [UIFont systemFontOfSize:11];
        _ticketNameLabel.font = [UIFont systemFontOfSize:15];
        _ticketPriceLabel.font = [UIFont systemFontOfSize:26];
        _ticketTimeLabel.font = [UIFont systemFontOfSize:11];
        _ticketEndTimeLabel.font = [UIFont systemFontOfSize:11];
        _ticketTimeTitle.font = [UIFont systemFontOfSize:11];

        
    }
    else
    {
        _componyNameLabel.font = [UIFont systemFontOfSize:16];
        _ticketNameLabel.font = [UIFont systemFontOfSize:20];
        _ticketPriceLabel.font = [UIFont systemFontOfSize:35];
        _ticketTimeLabel.font = [UIFont systemFontOfSize:11];
        _ticketEndTimeLabel.font = [UIFont systemFontOfSize:11];
        _ticketTimeTitle.font = [UIFont systemFontOfSize:11];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(TicketModel*)model
{
    _componyNameLabel.text = model.comp_name;

    if (model.times_limit.intValue >= 999)
    {
        _ticketPriceLabel.text = @"年卡";
    }
    else
    {
        _ticketPriceLabel.text = [NSString stringWithFormat:@"%d",model.price.intValue];
    }
    
    _ticketNameLabel.text = model.code_name;
    _ticketTimeLabel.text = model.begin_time == nil?@"":model.begin_time;
    _ticketEndTimeLabel.text = [NSString stringWithFormat:@"-%@",model.end_time == nil?@"":model.end_time];
    if ([model.pay_flag isEqualToString:@"1"])
    {
        _payFlagLabel.hidden = YES;
    }
    else
    {
        _payFlagLabel.hidden = NO;
    }
    
    _ticketTimeLabel.textColor = [UIColor colorWithRed:96.0/255.0
                                                 green:96.0/255.0
                                                  blue:96.0/255.0
                                                 alpha:1.0];
    
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
        _ticketTimeLabel.textColor = [UIColor colorWithRed:235.0/255.0
                                                     green:84/255.0
                                                      blue:1/255.0
                                                     alpha:1.0];
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
}




@end
