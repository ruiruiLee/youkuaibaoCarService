//
//  HotCityCell.h
//  
//
//  Created by cts on 15/9/21.
//
//

#import <UIKit/UIKit.h>
#import "OpenCityModel.h"

@protocol HotCityCellDelegate <NSObject>

- (void)didSelectedHotCityAtIndex:(NSInteger)cityIndex;

@end


@interface HotCityCell : UITableViewCell
{
    IBOutlet UIView *_hotCityView;
}

@property (assign, nonatomic) id <HotCityCellDelegate> delegate;

- (void)setDisplayHotCitys:(NSArray*)hotCityArray;


@end
