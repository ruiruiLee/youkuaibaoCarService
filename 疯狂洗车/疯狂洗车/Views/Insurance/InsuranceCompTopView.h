//
//  InsuranceCompTopView.h
//  
//
//  Created by cts on 15/9/15.
//
//

#import <UIKit/UIKit.h>

@protocol InsuranceCompTopViewDelegate <NSObject>

- (void)didSelectedInsuranceCompItem:(NSInteger)itemIndex;

@end

@interface InsuranceCompTopView : UIView
{
    float _padRect;
    
    float _itemWidth;
    
    float _itemHeight;
    
    UIView *_selectedView;
}

- (void)setUpWithInsuranceComps:(NSArray*)insuranceComps;

- (void)moveSelectToTarget:(NSInteger)targetIndex;
@property (assign, nonatomic) id <InsuranceCompTopViewDelegate> delegate;

@end
