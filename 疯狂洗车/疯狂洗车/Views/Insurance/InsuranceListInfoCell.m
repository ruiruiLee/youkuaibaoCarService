//
//  InsuranceListInfoCell.m
//  
//
//  Created by cts on 15/9/16.
//
//

#import "InsuranceListInfoCell.h"
#import "UploadImageModel.h"

@implementation InsuranceListInfoCell

- (void)awakeFromNib {
    // Initialization code

    CGRect topRect = CGRectMake(0, 0, SCREEN_WIDTH - 20, 64);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topRect
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topRect;
    maskLayer.path = maskPath.CGPath;
    _topInfoView.layer.mask = maskLayer;
    
    for (int x = 0; x<30; x++)
    {
        UIImageView *imageView = [self createAImageViewToShow];
        [_imageDisplayView addSubview:imageView];
    }
    
    _shadowTopView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowTopView.layer.shadowRadius = 2;
    _shadowTopView.layer.shadowOffset = CGSizeMake(0, -1);
    _shadowTopView.layer.shadowOpacity = 0.1;
    
    _insuranceTimeLabel.layer.masksToBounds = YES;
    _insuranceTimeLabel.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInsuranceGroupInfo:(InsuranceGroupModel*)model
{
    _insuranceTimeLabel.text = model.edit_time == nil? model.create_time:model.edit_time;
    _insuranceCreateTimeLabel.text = model.create_time;
    _cityLabel.text = model.city_name == nil?@"暂无信息":model.city_name;
    
    _idCardNoLabel.text = model.cid;
    
    _phoneLabel.text    = model.user_phone;
    
    _insuranceIdLabel.text = [NSString stringWithFormat:@"订单号：%@",model.insurance_no == nil?@"":model.insurance_no];
    
    if (model.insur_status.intValue == 4)
    {
        _insruanceStatusLabel.hidden = YES;
        _editButton.hidden = NO;
    }
    else
    {
        _insruanceStatusLabel.hidden = NO;
        if (model.paid_status.intValue < 0)
        {
            _insruanceStatusLabel.text = @"等待报价";
            _editButton.hidden = NO;
        }
        else
        {
            _editButton.hidden = YES;
            if (model.paid_status.intValue == 0)
            {
                _insruanceStatusLabel.text = @"已报价";
                _editButton.hidden = NO;
            }
            else if (model.paid_status.intValue == 1)
            {
                _insruanceStatusLabel.text = @"支付中";
                _editButton.hidden = YES;
            }
            else
            {
                _insruanceStatusLabel.text = @"已下单";
                _editButton.hidden = YES;
            }
        }

    }
    
//    
//    int addCount = 0;
//    int replaceCount = 0;
//    int deleteCount = 0;
//    
//    if (model.imageAddrsArray.count > _imageDisplayView.subviews.count)
//    {
//        replaceCount = (int)_imageDisplayView.subviews.count;
//        addCount = (int)model.imageAddrsArray.count - replaceCount;
//    }
//    else
//    {
//        replaceCount = (int)model.imageAddrsArray.count;
//        deleteCount = (int)_imageDisplayView.subviews.count - replaceCount;
//    }
//    
//    //替换已有的
//    for (int x = 0; x<replaceCount; x++)
//    {
//        UIImageView *imageView = _imageDisplayView.subviews[x];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageAddrsArray[x]]
//                     placeholderImage:[UIImage imageNamed:@"img_insurance_downloading"]
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//         {
//             if (error == nil)
//             {
//                 // [imageView setImage:[Constants imageByScalingAndCroppingForSize:imageView.frame.size withTarget:image]];
//             }
//             else
//             {
//                 [imageView setImage:[UIImage imageNamed:@"img_insurance_failed"]];
//             }
//         }];
//    }
//    
//    //添加新的或删除多余的
//    if (addCount > 0)
//    {
//        for (int x = 0; x<addCount; x++)
//        {
//            UIImageView *imageView = [self createAImageViewToShow];
//            [_imageDisplayView addSubview:imageView];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageAddrsArray[x+replaceCount]]
//                         placeholderImage:[UIImage imageNamed:@"img_insurance_downloading"]
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//             {
//                 if (error == nil)
//                 {
//                     // [imageView setImage:[Constants imageByScalingAndCroppingForSize:imageView.frame.size withTarget:image]];
//                 }
//                 else
//                 {
//                     [imageView setImage:[UIImage imageNamed:@"img_insurance_failed"]];
//                 }
//             }];
//        }
//    }
//    else
//    {
//        for (int x = replaceCount; x<_imageDisplayView.subviews.count; x++)
//        {
//            UIImageView *imageView = _imageDisplayView.subviews[x];
//            [imageView removeFromSuperview];
//        }
//    }
//    
    if (model.img_list.count > 0)
    {
        for (int x = 0; x<_imageDisplayView.subviews.count; x++)
        {
            UIImageView *imageView = _imageDisplayView.subviews[x];
            if (x<model.img_list.count)
            {
                imageView.hidden = NO;
                //model.imageAddrsArray[x]
//                
//                NSString *string1 = @"http://www.wisdudu.com/icon/爸爸.png";
//                NSString* string2 = [string1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                UploadImageModel *imgModel = model.img_list[x];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imgModel.img_url]
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
                imageView.image = nil;
                imageView.hidden = YES;
            }
            // [imageView removeFromSuperview];
            
        }
    }
    else
    {
        for (int x = 0; x<_imageDisplayView.subviews.count; x++)
        {
            UIImageView *imageView = _imageDisplayView.subviews[x];
            imageView.image = nil;
            imageView.hidden = YES;
        }
    }
}

- (UIImageView*)createAImageViewToShow
{
    float itemWidth = (SCREEN_WIDTH - 44)/3.0;
    float itemHeight = itemWidth;
    
    NSInteger subIndex = _imageDisplayView.subviews.count;
    int cloum = (int)subIndex/3;
    int row = (int)subIndex%3;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(row*(2+itemWidth), cloum * (2+itemHeight), itemWidth, itemHeight)];
    //[imageView sd_setImageWithURL:[NSURL URLWithString:model.imageAddrsArray[x]] placeholderImage:[UIImage imageNamed:@"car_wash_list_default_image"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5;
    imageView.tag = subIndex;
    imageView.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = imageView.bounds;
    [imageView addSubview:button];
    button.tag = subIndex;
    [button addTarget:self
               action:@selector(didImageItemTouch:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return imageView;
}

- (IBAction)didEditButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didEditButtonTouched:)])
    {
        [self.delegate didEditButtonTouched:self.indexPath];
    }
}

- (void)didImageItemTouch:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(didImageItemTouched:andImageIndex:)])
    {
        [self.delegate didImageItemTouched:self.indexPath
                             andImageIndex:sender.tag];
    }
}

@end
