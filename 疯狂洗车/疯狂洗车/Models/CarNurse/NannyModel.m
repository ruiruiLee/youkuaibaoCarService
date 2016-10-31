//
//  NannyModel.m
//  优快保
//
//  Created by cts on 15/4/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "NannyModel.h"

@implementation NannyModel


- (void)setPhoto_addrs:(NSString *)photo_addrs
{
    _photo_addrs = photo_addrs;
    if ([_photo_addrs isEqualToString:@""] || _photo_addrs == nil)
    {
        
    }
    else
    {
        _imageAddrsArray = [_photo_addrs componentsSeparatedByString:@","];
    }
}

@end
