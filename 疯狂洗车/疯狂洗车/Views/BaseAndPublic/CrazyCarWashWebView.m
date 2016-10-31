//
//  CrazyCarWashWebView.m
//  优快保
//
//  Created by cts on 15/6/23.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CrazyCarWashWebView.h"

@implementation CrazyCarWashWebView


- (void)loadRequest:(NSURLRequest *)request
{
    NSString *requestString = request.URL.relativeString;
    
    
    if (!_userInfo.member_id || self.forbidAddMark)
    {
        [super loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
    }
    else
    {
        NSString *fixString = nil;
        if ([[requestString substringWithRange:NSMakeRange(requestString.length-1, 1)] isEqualToString:@"?"])
        {
            fixString = @"";
        }
        else
        {
            fixString = @"?";
        }
        NSMutableString *appendingString = [NSMutableString stringWithFormat:@"%@&mark=%@",fixString,_userInfo.member_id];
        
        NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken];
        if (loginToken != nil)
        {
            [appendingString appendFormat:@"&token=%@",loginToken];
        }

        [super loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAppendingString:appendingString]]]];

    }
    // [super loadRequest:request];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
