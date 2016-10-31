//
//  MineTicketNumberCell.m
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "MineTicketNumberCell.h"

@implementation MineTicketNumberCell

- (void)awakeFromNib {
    // Initialization code
    _ticketImageView.layer.masksToBounds = YES;
    _ticketImageView.layer.cornerRadius  = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfoWithTicketType:(NSInteger)ticketType
                     andTicketNumber:(int)ticketNumber
{
    switch (ticketType)
    {
        case 0:
        {
            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_carWash"]];
            _ticketNameLabel.text = @"洗车券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 1:
        {

            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_baoyang"]];
            _ticketNameLabel.text = @"保养券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 2:
        {

            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_huahen"]];
            _ticketNameLabel.text = @"划痕券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 3:
        {

            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_meirong"]];
            _ticketNameLabel.text = @"美容券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 4:
        {
            _ticketImageView.backgroundColor = [UIColor colorWithRed:255/255.0
                                                               green:96/255.0
                                                                blue:115/255.0
                                                               alpha:1.0];
            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_jiuyuan"]];
            _ticketNameLabel.text = @"救援券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 5:
        {
            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_chebaomu"]];
            _ticketNameLabel.text = @"保姆券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 6:
        {
            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_suyuan"]];
            _ticketNameLabel.text = @"速援券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 8:
        {
            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_nianshen"]];
            _ticketNameLabel.text = @"年审券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        case 100:
        {
            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_insurance"]];
            _ticketNameLabel.text = @"保险券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
        default:
        {
            [_ticketImageView setImage:[UIImage imageNamed:@"img_ticket_other"]];
            _ticketNameLabel.text = @"其他券";
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张",ticketNumber];
        }
            break;
    }
}

@end
