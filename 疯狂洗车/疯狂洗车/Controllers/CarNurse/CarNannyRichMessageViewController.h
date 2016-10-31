//
//  CarNannyRichMessageViewController.h
//  优快保
//
//  Created by cts on 15/5/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageUploadView.h"
#import "GCPlaceholderTextView.h"
#import "NannyTypeModel.h"
#import "HFTRadionButton.h"

@protocol CarNannyRichMessageDelegate <NSObject>

- (void)didFinishMessageSend;

@end

//富文本编辑发送页面
@interface CarNannyRichMessageViewController : BaseViewController<ImageUploadViewDelegate,UITextViewDelegate>
{
    
    IBOutlet ImageUploadView *_imageSelectView;
    
    IBOutlet UIView *_contentView;
    
    IBOutlet GCPlaceholderTextView *_contextTextView;
    
    NSMutableArray  *_submitImageItemsArray;
    
    IBOutlet HFTRadionButton *_shouldShowImageButton;
    
    IBOutlet HFTRadionButton *_shouldNotShowImageButton;
    
    
}

@property (assign, nonatomic) id <CarNannyRichMessageDelegate> delegate;

@property (strong, nonatomic) NSString *preInputString;

@property (strong, nonatomic) NannyTypeModel  *selectNannyType;


@end
