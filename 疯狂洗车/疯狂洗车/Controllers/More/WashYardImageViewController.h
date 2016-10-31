//
//  WashYardImageViewController.h
//  优快保
//
//  Created by cts on 15/7/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageUploadView.h"

@protocol WashYardImageDelegate <NSObject>

- (void)didFinishWasyYardImageSelect:(NSArray*)imageArray;

@end

//推广人员添加车场图片页面
@interface WashYardImageViewController : BaseViewController<ImageUploadViewDelegate>
{
    
    IBOutlet ImageUploadView *_imageUploadView;
}

@property (assign, nonatomic) id <WashYardImageDelegate> delegate;

@property (strong ,nonatomic) NSMutableArray *uploadImageArray;

@end
