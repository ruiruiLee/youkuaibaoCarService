//
//  CarServiceDetailCell.h
//  疯狂洗车
//
//  Created by cts on 15/11/11.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"
#import "CarInfos.h"
#import "CarNurseServiceModel.h"

@interface CarServiceDetailCell : UITableViewCell
{
    IBOutlet UILabel *_carNurseNameLabel;

    IBOutlet UILabel *_serviceCarLabel;
    
    IBOutlet UILabel *_serviceTypeAndWayLabel;

    IBOutlet UILabel *_serviceContextLabel;
    
    IBOutlet UILabel *_servicePartsLabel;
}

- (void)setDisplayCarServiceDetailInfoWithCarNurse:(CarNurseModel*)carNurseModel
                                        andCarInfo:(CarInfos*)serviceCar
                                andCarNurseService:(CarNurseServiceModel*)serviceModel;
@end
