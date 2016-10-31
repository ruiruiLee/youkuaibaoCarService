//
//  InsuranceCustomValueCell.m
//  
//
//  Created by cts on 15/10/15.
//
//

#import "InsuranceCustomValueCell.h"

@implementation InsuranceCustomValueCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayEventName:(NSString*)titleString
{
    _eventNameLabel.text = titleString;
}

@end
