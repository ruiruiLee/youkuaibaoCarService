//
//  HotCityCell.m
//  
//
//  Created by cts on 15/9/21.
//
//

#import "HotCityCell.h"

@implementation HotCityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayHotCitys:(NSArray*)hotCityArray
{
    int addCount = 0;
    int replaceCount = 0;
    int deleteCount = 0;
    
    if (hotCityArray.count >= _hotCityView.subviews.count)
    {
        replaceCount = (int)_hotCityView.subviews.count;
        addCount = (int)hotCityArray.count - replaceCount;
    }
    else
    {
        replaceCount = (int)hotCityArray.count;
        deleteCount = (int)_hotCityView.subviews.count - replaceCount;
    }
    
    //替换已有的
    for (int x = 0; x<replaceCount; x++)
    {
        UIButton *cityItem = _hotCityView.subviews[x];
        OpenCityModel *cityModel = hotCityArray[x];
        [cityItem setTitle:cityModel.city_name forState:UIControlStateNormal];
    }
    
    //添加新的或删除多余的
    if (addCount >= 0)
    {
        for (int x = 0; x<addCount; x++)
        {
            OpenCityModel *cityModel = hotCityArray[x+replaceCount];
            UIButton *cityItem = [self createHotCityItemToDisplayWithTitle:cityModel.city_name];
            [_hotCityView addSubview:cityItem];
        }
    }
    else
    {
        for (int x = replaceCount; x<deleteCount; x++)
        {
            UIButton *cityItem = _hotCityView.subviews[x];
            [cityItem removeFromSuperview];
        }
    }
}

- (UIButton*)createHotCityItemToDisplayWithTitle:(NSString*)titleString
{
    float itemWidth = (SCREEN_WIDTH - 60)/3.0;
    float itemHeight = 35;
    
    NSInteger subIndex = _hotCityView.subviews.count;
    int cloum = (int)subIndex/3;
    int row = (int)subIndex%3;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(row*(10+itemWidth)+20, 15+cloum * (10+itemHeight), itemWidth, itemHeight);
    button.tag = subIndex;
    [button setTitle:titleString forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:204/255.0
                                               green:204/255.0
                                                blue:204/255.0
                                               alpha:1.0].CGColor;
    [button addTarget:self
               action:@selector(didHotCityItemTouch:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)didHotCityItemTouch:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectedHotCityAtIndex:)])
    {
        [self.delegate didSelectedHotCityAtIndex:sender.tag];
    }
}

@end
