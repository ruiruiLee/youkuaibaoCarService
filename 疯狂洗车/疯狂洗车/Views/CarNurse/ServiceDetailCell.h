//
//  ServiceDetailCell.h
//  
//
//  Created by cts on 15/10/30.
//
//

#import <UIKit/UIKit.h>
#import "CarReviewModel.h"

@interface ServiceDetailCell : UITableViewCell
{    
    IBOutlet UILabel *_serviceTypeAndWayLabel;
    
    IBOutlet UILabel *_serviceContextLabel;
}

- (void)setDisplayInfo:(CarReviewModel*)model
       withServiceType:(NSString*)serviceContent;
@end
