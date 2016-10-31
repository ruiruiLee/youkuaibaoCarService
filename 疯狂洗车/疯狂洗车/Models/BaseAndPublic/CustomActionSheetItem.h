//
//  CustomActionSheetItem.h
//  
//
//  Created by cts on 15/10/20.
//
//

#import "JsonBaseModel.h"

typedef enum
{
    CustomActionSheetItemTypeImage,
    CustomActionSheetItemTypeButton,
    CustomActionSheetItemTypeTitle,
    CustomActionSheetItemTypeCancel
}CustomActionSheetItemType;

@interface CustomActionSheetItem : JsonBaseModel

@property (nonatomic) CustomActionSheetItemType itemType;

@property (strong, nonatomic) id object;



- (instancetype)initWithType:(CustomActionSheetItemType)itemType
                andSubobject:(id)object;

@end
