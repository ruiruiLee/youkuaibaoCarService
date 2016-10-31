//
//  MyCarsCell.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MyCarsCell.h"

@implementation MyCarsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[_whiteBg layer] setMasksToBounds:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)deleteSelf:(id)sender
{
    [Constants showMessage:@"确认删除此条车辆信息吗？"
                  delegate:self
                       tag:0
              buttonTitles:@"取消", @"确认", nil];
}

- (IBAction)editSelf:(id)sender
{
    [Constants showMessage:@"确认修改此条车辆信息吗？"
                  delegate:self
                       tag:1
              buttonTitles:@"取消", @"确认", nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 0:
        {
            switch (buttonIndex)
            {
                case 0:
                    
                    break;
                case 1:
                {
                    if ([self.delegate respondsToSelector:@selector(deleteCarWithCarInfo:)])
                    {
                        [self.delegate deleteCarWithCarInfo:_carInfo];
                    }
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case 1:
        {
            switch (buttonIndex)
            {
                case 0:
                    
                    break;
                case 1:
                {
                    if ([self.delegate respondsToSelector:@selector(editCarWithCarInfo:)])
                    {
                        [self.delegate editCarWithCarInfo:_carInfo];
                    }
                }
                    break;
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
    }

@end
