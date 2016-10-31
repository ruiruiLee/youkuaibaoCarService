//
//  CityHeaderView.h
//  
//
//  Created by cts on 15/9/24.
//
//

#import <UIKit/UIKit.h>

@interface CityHeaderView : UIView
{
    
    IBOutlet UILabel *_headerTitleLabel;
}


- (void)setCityHeaderTitle:(NSString*)titleString;

@end
