//
//  MessageContentDetailViewController.m
//  优快保
//
//  Created by cts on 15/7/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MessageContentDetailViewController.h"

@interface MessageContentDetailViewController ()

@end

@implementation MessageContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"信息详情"];
    
    if (self.model)
    {
        if ([self.model.msg_type isEqualToString:@"0"])
        {
            _messageAuthor.text   = [NSString stringWithFormat:@"系统消息："];
        }
        else
        {
            _messageAuthor.text   = [NSString stringWithFormat:@"%@：",self.model.msg_type];
        }
        
        _createTimeLabel.text = self.model.create_time;
        
        _messageContentLabel.text = self.model.msg_content;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
