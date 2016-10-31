//
//  InsuranceCustomSelectModel.m
//  
//
//  Created by cts on 15/10/15.
//
//

#import "InsuranceCustomSelectModel.h"

@implementation InsuranceCustomSelectModel

- (instancetype)initWithCustomSelectModelWithTitle:(NSString*)titleString
                                          andIntro:(NSString*)introString
                                           andDesc:(NSString*)descString
                                 andValueModelType:(CustomSelectValueType)valueType
                                   andDefaultIndex:(NSInteger)index
                               andShouldBjmpEnable:(BOOL)shouldEnable;
{
    self = [super init];
    
    if (self)
    {
        self.selectTitle = titleString;
        self.selectIntro = introString;

        self.selectDesc = descString;
        
        self.valueType = valueType;

        self.itemsArray = [self createInsuranceValueModelArrayWithValueModelType:self.valueType];
        self.selectedIndex = index;
        self.bjmpEnable = shouldEnable;
        if (self.bjmpEnable && self.selectedIndex > 0)
        {
            self.bjmpSelected = YES;
        }

    }
    
    return self;
}

- (NSArray*)createInsuranceValueModelArrayWithValueModelType:(CustomSelectValueType)type
{
    NSMutableArray *resultArray = nil;
    
    if (type == CustomSelectValueTypeJQCC)
    {
        InsuranceCustomValueModel *model1 = [[InsuranceCustomValueModel alloc] init];
        
        model1.valueName = @"投保";
        model1.valueString = @"1";
        
        resultArray = [@[model1] mutableCopy];
    }
    else if (type == CustomSelectValueTypeCS)
    {
        InsuranceCustomValueModel *model1 = [[InsuranceCustomValueModel alloc] init];
        
        model1.valueName = @"不投";
        model1.valueString = @"0";
        
        InsuranceCustomValueModel *model2 = [[InsuranceCustomValueModel alloc] init];
        
        model2.valueName = @"投保";
        model2.valueString = @"1";
        
        resultArray = [@[model1,model2] mutableCopy];
    }
    else if (type == CustomSelectValueTypeSZ)
    {
        resultArray = [NSMutableArray array];
        NSArray *nameArray = @[@"不投",@"5万",@"10万",@"15万",@"20万",@"30万",@"50万",@"100万"];
        NSArray *valueArray = @[@"0",@"5",@"10",@"15",@"20",@"30",@"50",@"100"];
        
        for (int x = 0; x<nameArray.count; x++)
        {
            InsuranceCustomValueModel *model = [[InsuranceCustomValueModel alloc] init];
            
            model.valueName = nameArray[x];
            model.valueString = valueArray[x];
            
            [resultArray addObject:model];
        }
    }
    else if (type == CustomSelectValueTypeDQ)
    {
        InsuranceCustomValueModel *model1 = [[InsuranceCustomValueModel alloc] init];
        
        model1.valueName = @"不投";
        model1.valueString = @"0";
        
        InsuranceCustomValueModel *model2 = [[InsuranceCustomValueModel alloc] init];
        
        model2.valueName = @"投保";
        model2.valueString = @"1";
        
        resultArray = [@[model1,model2] mutableCopy];
    }
    else if (type == CustomSelectValueTypeSJ || type == CustomSelectValueTypeCK)
    {
        resultArray = [NSMutableArray array];
        NSArray *nameArray = @[@"不投",@"1万",@"2万",@"3万",@"4万",@"5万",@"10万"];
        NSArray *valueArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"10"];
        
        for (int x = 0; x<nameArray.count; x++)
        {
            InsuranceCustomValueModel *model = [[InsuranceCustomValueModel alloc] init];
            
            model.valueName = nameArray[x];
            model.valueString = valueArray[x];
            
            [resultArray addObject:model];
        }
    }
    else if (type == CustomSelectValueTypeBL)
    {
        InsuranceCustomValueModel *model1 = [[InsuranceCustomValueModel alloc] init];
        
        model1.valueName = @"不投";
        model1.valueString = @"0";
        
        InsuranceCustomValueModel *model2 = [[InsuranceCustomValueModel alloc] init];
        
        model2.valueName = @"国产";
        model2.valueString = @"1";
        
        InsuranceCustomValueModel *model3 = [[InsuranceCustomValueModel alloc] init];
        
        model3.valueName = @"进口";
        model3.valueString = @"2";
        
        resultArray = [@[model1,model2,model3] mutableCopy];
    }
    else if (type == CustomSelectValueTypeSS)
    {
        InsuranceCustomValueModel *model1 = [[InsuranceCustomValueModel alloc] init];
        
        model1.valueName = @"不投";
        model1.valueString = @"0";
        
        InsuranceCustomValueModel *model2 = [[InsuranceCustomValueModel alloc] init];
        
        model2.valueName = @"投保";
        model2.valueString = @"1";
        
        resultArray = [@[model1,model2] mutableCopy];
    }
    else if (type == CustomSelectValueTypeHH)
    {
        resultArray = [NSMutableArray array];
        NSArray *nameArray = @[@"不投",@"2000",@"5000",@"1万",@"2万"];
        NSArray *valueArray = @[@"0",@"2000",@"5000",@"1",@"2"];
        
        for (int x = 0; x<nameArray.count; x++)
        {
            InsuranceCustomValueModel *model = [[InsuranceCustomValueModel alloc] init];
            
            model.valueName = nameArray[x];
            model.valueString = valueArray[x];
            
            [resultArray addObject:model];
        }
    }
    else if (type == CustomSelectValueTypeZR)
    {
        InsuranceCustomValueModel *model1 = [[InsuranceCustomValueModel alloc] init];
        
        model1.valueName = @"不投";
        model1.valueString = @"0";
        
        InsuranceCustomValueModel *model2 = [[InsuranceCustomValueModel alloc] init];
        
        model2.valueName = @"投保";
        model2.valueString = @"1";
        
        resultArray = [@[model1,model2] mutableCopy];
    }
    
    
    return resultArray;
}


- (void)updatePropertyWithDetailModel:(InsuranceDetailItemModel*)targetModel
{
    if (self.valueType == CustomSelectValueTypeJQCC)
    {
    }
    else if (self.valueType == CustomSelectValueTypeCS)
    {
        if (targetModel.cs_status.intValue > 0)
        {
            self.selectedIndex = 1;
        }
        else
        {
            self.selectedIndex = 0;
        }
        self.bjmpSelected = targetModel.cs_bjmp_status.intValue > 0?YES:NO;
    }
    else if (self.valueType == CustomSelectValueTypeSZ)
    {
        NSArray *valueArray = @[@"0",@"5",@"10",@"15",@"20",@"30",@"50",@"100"];
        for (int x = 0; x<valueArray.count; x++)
        {
            if ([valueArray[x] isEqualToString:targetModel.sz_price])
            {
                self.selectedIndex = x;
                break;
            }
        }
        self.bjmpSelected = targetModel.sz_bjmp_status.intValue > 0?YES:NO;
    }
    else if (self.valueType == CustomSelectValueTypeDQ)
    {
        if (targetModel.dq_status.intValue > 0)
        {
            self.selectedIndex = 1;
        }
        else
        {
            self.selectedIndex = 0;
        }
        self.bjmpSelected = targetModel.dq_bjmp_status.intValue > 0?YES:NO;
    }
    else if (self.valueType == CustomSelectValueTypeSJ)
    {
        NSArray *valueArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"10"];
        for (int x = 0; x<valueArray.count; x++)
        {
            if ([valueArray[x] isEqualToString:targetModel.sj_price])
            {
                self.selectedIndex = x;
                break;
            }
        }
        self.bjmpSelected = targetModel.sj_bjmp_status.intValue > 0?YES:NO;
    }
    else if (self.valueType == CustomSelectValueTypeCK)
    {
        NSArray *valueArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"10"];
        for (int x = 0; x<valueArray.count; x++)
        {
            if ([valueArray[x] isEqualToString:targetModel.ck_price])
            {
                self.selectedIndex = x;
                break;
            }
        }
        self.bjmpSelected = targetModel.ck_bjmp_status.intValue > 0?YES:NO;
    }
    else if (self.valueType == CustomSelectValueTypeBL)
    {
        self.selectedIndex = targetModel.bl_stauts.intValue;
    }
    else if (self.valueType == CustomSelectValueTypeSS)
    {
        self.selectedIndex = targetModel.ss_status.intValue;
        self.bjmpSelected = targetModel.ss_bjmp_status.intValue > 0?YES:NO;
    }
    else if (self.valueType == CustomSelectValueTypeHH)
    {
        NSArray *valueArray = @[@"0",@"2000",@"5000",@"1",@"2"];
        for (int x = 0; x<valueArray.count; x++)
        {
            if ([valueArray[x] isEqualToString:targetModel.hh_price])
            {
                self.selectedIndex = x;
                break;
            }
        }
        self.bjmpSelected = targetModel.hh_bjmp_status.intValue > 0?YES:NO;
    }
    else if (self.valueType == CustomSelectValueTypeZR)
    {
        self.selectedIndex = targetModel.zr_status.intValue;
        self.bjmpSelected = targetModel.zr_bjmp_status.intValue > 0?YES:NO;
    }

}

@end
