//
//  InsuranceCustomSelectModel.h
//  
//
//  Created by cts on 15/10/15.
//
//

#import "JsonBaseModel.h"
#import "InsuranceCustomValueModel.h"
#import "InsuranceDetailItemModel.h"


typedef enum
{
    CustomSelectValueTypeJQCC,
    CustomSelectValueTypeCS,
    CustomSelectValueTypeSZ,
    CustomSelectValueTypeDQ,
    CustomSelectValueTypeSJ,
    CustomSelectValueTypeCK,
    CustomSelectValueTypeBL,
    CustomSelectValueTypeSS,
    CustomSelectValueTypeHH,
    CustomSelectValueTypeZR
}CustomSelectValueType;

@interface InsuranceCustomSelectModel : JsonBaseModel
{
    
}

@property (strong, nonatomic) NSString *selectTitle;

@property (strong, nonatomic) NSString *selectIntro;

@property (strong, nonatomic) NSString *selectDesc;


@property (strong, nonatomic) NSArray *itemsArray;

@property (assign, nonatomic) NSInteger selectedIndex;

@property (assign, nonatomic) CustomSelectValueType valueType;

@property (assign, nonatomic) BOOL bjmpEnable;

@property (assign, nonatomic) BOOL bjmpSelected;

- (instancetype)initWithCustomSelectModelWithTitle:(NSString*)titleString
                                          andIntro:(NSString*)introString
                                           andDesc:(NSString*)descString
                                     andValueModelType:(CustomSelectValueType)valueType
                                   andDefaultIndex:(NSInteger)index
                               andShouldBjmpEnable:(BOOL)shouldEnable;

- (void)updatePropertyWithDetailModel:(InsuranceDetailItemModel*)targetModel;
@end
