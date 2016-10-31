//
//  LocationCityCell.h
//  
//
//  Created by cts on 15/9/21.
//
//

#import <UIKit/UIKit.h>

@protocol LocationCityCellDelegate <NSObject>

- (void)didLocationCityButtonTouched;

@end

@interface LocationCityCell : UITableViewCell
{
    
    IBOutlet UILabel  *_locationRunningLabel;
    
    UIButton *_locationCityButton;
    
    IBOutlet UIView *_displayView;
    
}

@property (assign, nonatomic) id <LocationCityCellDelegate> delegate;

- (void)setLocationCityName:(NSString*)cityName;

@end
