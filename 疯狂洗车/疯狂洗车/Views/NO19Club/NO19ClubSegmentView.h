//
//  NO19ClubSegmentView.h
//  优快保
//
//  Created by cts on 15/8/10.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NO19ClubSegmentDelegate <NSObject>

- (void)didClubSegmentIndexChanged:(NSInteger)index;

@end

@interface NO19ClubSegmentView : UIView



@property (nonatomic, assign) id <NO19ClubSegmentDelegate> delegate;

@property (assign, nonatomic) NSInteger selectIndex;

/**
 *	@brief	设置自定义segment的子控件
 *
 *	@return	void
 */
- (void)setUpSegmentViewWithItems:(NSArray*)itemsArray;

@end
