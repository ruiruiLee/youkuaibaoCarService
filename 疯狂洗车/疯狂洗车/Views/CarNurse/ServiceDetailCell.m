//
//  ServiceDetailCell.m
//  
//
//  Created by cts on 15/10/30.
//
//

#import "ServiceDetailCell.h"

@implementation ServiceDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(CarReviewModel*)model
       withServiceType:(NSString*)serviceContent
{
    _serviceContextLabel.text = model.service_city;
    
    _serviceTypeAndWayLabel.text = serviceContent;
}

@end
