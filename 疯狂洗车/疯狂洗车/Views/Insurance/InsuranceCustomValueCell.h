//
//  InsuranceCustomValueCell.h
//  
//
//  Created by cts on 15/10/15.
//
//

#import <UIKit/UIKit.h>

@interface InsuranceCustomValueCell : UITableViewCell
{
    
    IBOutlet UILabel *_eventNameLabel;
    
    
}
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

- (void)setDisplayEventName:(NSString*)titleString;

@end
