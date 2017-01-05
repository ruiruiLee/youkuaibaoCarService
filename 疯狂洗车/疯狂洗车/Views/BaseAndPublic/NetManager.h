//
//  ThemeManager.h
//  SkinnedUI
//  换肤控制 颜色变化
//  Created by forrestlee on 12/3/12.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface NetManager : NSObject

@property (assign, nonatomic) NetworkStatus status;  
//单例模式
+ (Reachability *)defaultReachability;

@end
