//
//  CustomActionSheetItem.m
//  
//
//  Created by cts on 15/10/20.
//
//

#import "CustomActionSheetItem.h"

@implementation CustomActionSheetItem

- (instancetype)initWithType:(CustomActionSheetItemType)itemType
                andSubobject:(id)object
{
    self = [super init];
    
    if (self)
    {
        self.itemType = itemType;
        self.object = object;
    }
    
    return self;
}

@end
