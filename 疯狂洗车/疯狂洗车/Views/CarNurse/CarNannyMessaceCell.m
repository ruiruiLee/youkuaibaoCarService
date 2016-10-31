//
//  CarNannyMessaceCell.m
//  优快保
//
//  Created by cts on 15/4/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNannyMessaceCell.h"
#import "WebServiceHelper.h"
#import "UIImageView+WebCache.h"

@implementation CarNannyMessaceCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    if (_imageDisplayView.subviews.count <= 0)
    {
        float itemWidth = (SCREEN_WIDTH - 35)/4.0;
        float itemHeight = itemWidth;
        
        for (int x = 0; x<8; x++)
        {
            int cloum = x/4;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+x%4*(5+itemWidth), 10+cloum * (10+itemHeight), itemWidth, itemHeight)];
            //[imageView sd_setImageWithURL:[NSURL URLWithString:model.imageAddrsArray[x]] placeholderImage:[UIImage imageNamed:@"car_wash_list_default_image"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [_imageDisplayView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = imageView.bounds;
            imageButton.tag = x;
            [imageButton addTarget:self
                            action:@selector(didTouchOnImageButton:)
                  forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:imageButton];
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(NannyModel*)model
{
    _contentLabel.text = model.question_content;
    _timeLabel.text    = @"";
    _phoneLabel.text = model.phone;
    if ([model.reply_content isEqualToString:@""] || model.reply_content == nil)
    {
        _replyLabel.text = @"暂无回复";
    }
    else
    {
        _replyLabel.text = model.reply_content;
    }
    _replyTimeLabel.text = model.reply_time;
    _replyNameLabel.text = model.crm_user;
    
    if (model.imageAddrsArray.count > 0)
    {
        if (model.photo_status.intValue > 0)
        {
            if (_imageDisplayView.subviews.count > 0)
            {
                for (int x = 0; x<_imageDisplayView.subviews.count; x++)
                {
                    UIImageView *imageView = _imageDisplayView.subviews[x];
                    if (x<model.imageAddrsArray.count)
                    {
                        imageView.hidden = NO;
 
                        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageAddrsArray[x]]
                                             placeholderImage:[UIImage imageNamed:@"img_imageDowloading"]
                                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                         {
                             if (error == nil)
                             {
                                // [imageView setImage:[Constants imageByScalingAndCroppingForSize:imageView.frame.size withTarget:image]];
                             }
                             else
                             {
                                 [imageView setImage:[UIImage imageNamed:@"img_imageDowloading_error"]];
                             }
                         }];
                    }
                    else
                    {
                        imageView.hidden = YES;
                    }
                    // [imageView removeFromSuperview];
                    
                }
            }
        }
        else if ([model.member_id isEqualToString:_userInfo.member_id])
        {
            if (_imageDisplayView.subviews.count > 0)
            {
                for (int x = 0; x<_imageDisplayView.subviews.count; x++)
                {
                    UIImageView *imageView = _imageDisplayView.subviews[x];
                    if (x<model.imageAddrsArray.count)
                    {
                        imageView.hidden = NO;
                        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageAddrsArray[x]]
                                     placeholderImage:[UIImage imageNamed:@"img_imageDowloading"]
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                         {
                             if (error == nil)
                             {
                               //  [imageView setImage:[Constants imageByScalingAndCroppingForSize:imageView.frame.size withTarget:image]];
                             }
                             else
                             {
                                 [imageView setImage:[UIImage imageNamed:@"img_imageDowloading_error"]];
                             }
                         }];
                    }
                    else
                    {
                        imageView.hidden = YES;
                    }
                    // [imageView removeFromSuperview];
                    
                }
            }
        }
        else
        {
            for (int x = 0; x<_imageDisplayView.subviews.count; x++)
            {
                UIImageView *imageView = _imageDisplayView.subviews[x];
                imageView.hidden = YES;
            }
        }
    }
    else
    {
        for (int x = 0; x<_imageDisplayView.subviews.count; x++)
        {
            UIImageView *imageView = _imageDisplayView.subviews[x];
            imageView.hidden = YES;
        }
    }
    
}

- (void)didTouchOnImageButton:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectAndShowBigImage:andImageIndex:)])
    {
        
        [self.delegate didSelectAndShowBigImage:self.indexPath
                                  andImageIndex:sender.tag];
    }
}

@end
