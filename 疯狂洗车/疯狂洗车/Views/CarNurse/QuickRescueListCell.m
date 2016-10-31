//
//  QuickRescueListCell.m
//  疯狂洗车
//
//  Created by cts on 15/12/8.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "QuickRescueListCell.h"

@implementation QuickRescueListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDisplayInfo:(CarNurseModel*)model
{
    _titleLabel.text = model.short_name;
    
    [_carNurseImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                          placeholderImage:[UIImage imageNamed:@"img_default_logo"]];
    
    [_addressLabel setText:model.address];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.member_price];
    _oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.original_price];
    _commentLabel.text = [NSString stringWithFormat:@"评分%.1f",model.average_score.floatValue];
    
    double distanceValue = model.distance.doubleValue;
    if (distanceValue >= 1000)
    {
        _distanceLabel.adjustsFontSizeToFitWidth = YES;
        [_distanceLabel  setText:@"大于1000km"];
    }
    else if (distanceValue >= 1)
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%dkm", (int)distanceValue]];
    }
    else
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }

    //NSLog(@"%f",SCREEN_WIDTH-170);
    
    [self setUpLabelItems:model.supportServiceArray];
}

- (void)setUpLabelItems:(NSArray*)array
{
    _LableItemPadding = 4;

    float maxConstansWidth = SCREEN_WIDTH - 170;
    float usedConstansWidth = 0;
    int   itemCount = 0;
    for (int x = 0; x<array.count; x++)
    {
        NSString *titleString = array[x];
        CGSize contentSize =[titleString boundingRectWithSize:CGSizeMake(MAXFLOAT,18)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIDevice currentDevice].systemVersion.floatValue < 9.0?[UIFont systemFontOfSize:15.0]:[UIFont systemFontOfSize:16.0]}
                                                                 context:nil].size;
        if (usedConstansWidth + contentSize.width + _LableItemPadding < maxConstansWidth)//判断是否有足够空间
        {
            if (x<=(int)_labelDisplayView.subviews.count-1)
            {
                UILabel *labelItem = _labelDisplayView.subviews[x];
                labelItem.frame = CGRectMake(usedConstansWidth, labelItem.frame.origin.y, contentSize.width, labelItem.frame.size.height);
                labelItem.text = [NSString stringWithFormat:@"%@",titleString];
                labelItem.hidden = NO;

            }
            else
            {
                UILabel *labelItem = [[UILabel alloc] initWithFrame:CGRectMake(usedConstansWidth, 2, contentSize.width, 18)];
                labelItem.font = [UIFont systemFontOfSize:13];
                labelItem.textAlignment = NSTextAlignmentCenter;
                UIColor *labelColor = [self getLabelItemTextColorByIndex:x];
                labelItem.text = [NSString stringWithFormat:@"%@",titleString];
                labelItem.textColor = labelColor;
                labelItem.layer.masksToBounds = YES;
                labelItem.layer.cornerRadius = 3;
                labelItem.layer.borderWidth = 0.7;
                labelItem.layer.borderColor = labelColor.CGColor;
                labelItem.tag = x;
                [_labelDisplayView addSubview:labelItem];
            }
            usedConstansWidth+= contentSize.width+_LableItemPadding;
            itemCount ++;
            _moreLabelItem.hidden = YES;
        }
        else//无足够空间放置...label
        {
            _moreLabelItem.hidden = NO;
            break;
        }
    }
    _labelDisplayViewWidthConstraint.constant = usedConstansWidth;
    if (itemCount < _labelDisplayView.subviews.count)
    {
        for (int x = itemCount; x<_labelDisplayView.subviews.count; x++)
        {
            UILabel *labelItem = _labelDisplayView.subviews[x];
            labelItem.hidden = YES;
        }
    }
}



- (UILabel*)createLebelItemByTitleString:(NSString*)titleString
{
    UILabel *labelItem = nil;
    
    
    
    return labelItem;
}


- (UIColor*)getLabelItemTextColorByIndex:(int)titleIndex
{
    if (titleIndex == 0||titleIndex == 4)
    {
        return [UIColor colorWithRed:229/255.0
                               green:65/255.0
                                blue:0/255.0
                               alpha:1.0];
    }
    else if (titleIndex == 1||titleIndex == 5)
    {
        return [UIColor colorWithRed:0/255.0
                               green:148/255.0
                                blue:75/255.0
                               alpha:1.0];
    }
    else if (titleIndex == 2||titleIndex == 6)
    {
        return [UIColor colorWithRed:70/255.0
                               green:157/255.0
                                blue:252/255.0
                               alpha:1.0];
    }
    else
    {
        return [UIColor colorWithRed:112/255.0
                               green:103/255.0
                                blue:226/255.0
                               alpha:1.0];
    }

}
@end
