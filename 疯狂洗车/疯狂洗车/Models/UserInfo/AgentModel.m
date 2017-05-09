//
//  AgentModel.m
//  疯狂洗车
//
//  Created by cts on 15/11/23.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "AgentModel.h"

@implementation AgentModel

- (id)initWithDictionary:(NSDictionary *)jsonDic
{
    self = [super initWithDictionary:jsonDic];
    if(self){
        self.agent_id = nil;
        
        self.agent_name = nil;
        
        self.agent_phone = nil;
        
        self.agent_logo = nil;
        
        self.agent_title = nil;
    }
    return self;
}

@end
