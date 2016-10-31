//
//  NewsAnnotationView.h
//  优快保
//
//  Created by 朱伟铭 on 13-7-15.
//  Copyright (c) 2013年 朱伟铭. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "NewsOutCell.h"

@protocol NewsAnnotationViewDelegate;

@interface NewsAnnotationView : MKAnnotationView
{
//    id<NewsAnnotationViewDelegate>delegate;
}

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) NewsOutCell *infoView;//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView

@property(nonatomic,assign) id<NewsAnnotationViewDelegate>delegate;

-(void)refrashView;

@end

@protocol NewsAnnotationViewDelegate <NSObject>

-(void)didTouchNewsAnnotationView;

@end