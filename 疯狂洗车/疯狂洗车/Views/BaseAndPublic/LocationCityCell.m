//
//  LocationCityCell.m
//  
//
//  Created by cts on 15/9/21.
//
//

#import "LocationCityCell.h"


@implementation LocationCityCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)didLocationCityButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didLocationCityButtonTouched)])
    {
        [self.delegate didLocationCityButtonTouched];
    }
}

- (void)setLocationCityName:(NSString *)cityName
{
    if (cityName == nil)
    {
        _locationRunningLabel.hidden = NO;
        _locationCityButton.hidden = YES;
    }
    else
    {
        if (_locationCityButton == nil)
        {
            _locationCityButton = [self createHotCityItemToDisplayWithTitle:cityName];
            [_displayView addSubview:_locationCityButton];
        }
        _locationRunningLabel.hidden = YES;
        _locationCityButton.hidden = NO;
        [_locationCityButton setTitle:cityName
                             forState:UIControlStateNormal];
    }
}

- (UIButton*)createHotCityItemToDisplayWithTitle:(NSString*)titleString
{
    float itemWidth = (SCREEN_WIDTH - 60)/3.0;
    float itemHeight = 35;
    
    NSInteger subIndex = _displayView.subviews.count;
    int cloum = (int)subIndex/3;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 15+cloum * (10+itemHeight), itemWidth, itemHeight);
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
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:204/255.0
                                                            green:204/255.0
                                                             blue:204/255.0
                                                            alpha:1.0].CGColor;
    [button addTarget:self
               action:@selector(didLocationCityButtonTouch:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}



@end
