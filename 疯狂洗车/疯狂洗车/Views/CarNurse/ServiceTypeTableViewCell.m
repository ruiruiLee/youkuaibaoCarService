//
//  ServiceTypeTableViewCell.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/16.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "ServiceTypeTableViewCell.h"
#import "define.h"

@implementation ServiceTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btnBg.layer.borderWidth = 1;
    self.btnBg.layer.cornerRadius = 4;
    self.btnBg.layer.borderColor = [UIColor colorWithRed:0xb2/255.0 green:0xb2/255.0 blue:0xb2/255.0 alpha:1.0].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCurrentServiceType:(ServiceType) type
{
    if(type == enumSmenquche){
        [self.btnSMQC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnSMQC setBackgroundColor:_COLOR(0xff, 0x66, 0x19)];
        
        [self.btnZJDD setBackgroundColor:_COLOR(0xe3, 0xe3, 0xe3)];
        [self.btnZJDD setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
    }
    else{
        [self.btnZJDD setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnZJDD setBackgroundColor:_COLOR(0xff, 0x66, 0x19)];
        
        [self.btnSMQC setBackgroundColor:_COLOR(0xe3, 0xe3, 0xe3)];
        [self.btnSMQC setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
    }
    
    _currentType = type;
}

- (ServiceType) obtainServiceType
{
    return _currentType;
}

- (IBAction)doBtnButtonClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    if(tag == 1001){
        [self setCurrentServiceType:enumZjiadaodian];
    }
    else{
        [self setCurrentServiceType:enumSmenquche];
    }
    
    if(self.delegate && [self .delegate respondsToSelector:@selector(NotifyServiceTypeChanged:type:)]){
        [self.delegate NotifyServiceTypeChanged:self type:_currentType];
    }
}

@end
