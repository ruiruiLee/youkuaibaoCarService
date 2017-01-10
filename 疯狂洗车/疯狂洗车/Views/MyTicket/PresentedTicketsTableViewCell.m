//
//  PresentedTicketsTableViewCell.m
//  疯狂洗车
//
//  Created by LiuZach on 2017/1/7.
//  Copyright © 2017年 龚杰洪. All rights reserved.
//

#import "PresentedTicketsTableViewCell.h"

@implementation PresentedTicketsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_btnSelected setImage:[UIImage imageNamed:@"ticket_normal"] forState:UIControlStateNormal];
    [_btnSelected setImage:[UIImage imageNamed:@"ticket_normal_selected"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doBtnItemSelected:(id)sender
{
    _btnSelected.selected = !_btnSelected.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(notifyItemSelected:selectedFlag:indexPath:)]){
        [self.delegate notifyItemSelected:self selectedFlag:_btnSelected.selected indexPath:self.indexPath];
    }
}

- (void) setItemSelected:(BOOL) flag
{
    _btnSelected.selected = flag;
}

- (BOOL) getItemSelectedStatus
{
    return _btnSelected.selected;
}

@end
