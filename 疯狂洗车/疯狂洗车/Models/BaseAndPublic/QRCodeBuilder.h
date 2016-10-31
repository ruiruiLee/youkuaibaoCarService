//
//  QRCodeBuilder.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeBuilder : NSObject
{
    
}

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;
+ (UIImage *)twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage;

@end
