
//  Created by forrestlee
// 主要用于整个界面换肤处理
//

#import "NetManager.h"



@implementation NetManager

//----------------- 定义网络变化单例参数

+(Reachability*) defaultReachability {
    static Reachability *_reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [Reachability reachabilityForInternetConnection];
#if !__has_feature(objc_arc)
        [_reachability retain];
#endif
    });
    
    return _reachability;
}
//--------------------- 定义网络变化单例参数

@end
