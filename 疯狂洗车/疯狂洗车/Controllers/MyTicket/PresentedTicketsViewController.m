//
//  PresentedTicketsViewController.m
//  疯狂洗车
//
//  Created by LiuZach on 2017/1/7.
//  Copyright © 2017年 龚杰洪. All rights reserved.
//

#import "PresentedTicketsViewController.h"
#import "MyTicketCell.h"
#import "TicketModel.h"
#import "ADVModel.h"
#import "ActivitysController.h"
#import "CheXiaoBaoViewController.h"
#import "define.h"
#import "PresentedTicketsTableViewCell.h"
#import "UIView+Toast.h"

@interface PresentedTicketsViewController ()<PresentedTicketsTableViewCellDelegate, UITextFieldDelegate>
{
    int _pageIndex;
    
    BOOL _canLoadMore;
}

@property (nonatomic, strong) NSString *serviceType;

@end

@implementation PresentedTicketsViewController
static NSString *ticketCellIndentifier = @"PresentedTicketsTableViewCell";

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"选择转赠优惠券"];
    self.serviceType = @"";
    _ticketArray = [NSMutableArray array];
    _selectedTicketArray = [NSMutableArray array];
    
    _tfTextField.delegate = self;
    
    [_ticketListTableView registerNib:[UINib nibWithNibName:ticketCellIndentifier
                                                     bundle:[NSBundle mainBundle]]
               forCellReuseIdentifier:ticketCellIndentifier];
    
    [_ticketListTableView addHeaderActionWithTarget:self
     
                                             action:@selector(getAllUserTickets)];
    
    [_ticketListTableView addFooterActionWithTarget:self
     
                                             action:@selector(getMoreUserTickets)];
    
//    [self getAllUserTickets];
    [_ticketListTableView tableViewHeaderBeginRefreshing];
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)

                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    _btnSubmit.layer.cornerRadius = 4;
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"注意！接收人需通过此号码登录优快保APP或微信公众号领取礼包。"];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:2];//调整行间距
    
    [attriString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 3)];
    _lbExplain.attributedText = attriString;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self closeKeyBoard];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self closeKeyBoard];
}

#pragma mark - 获取用户的券 Method

- (void)getAllUserTickets
{
    _pageIndex = 1;
    NSDictionary *submitDic = nil;
    
    submitDic = @{@"service_type":self.serviceType,
                  @"member_id":_userInfo.member_id,
                  @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
                  @"page_size":@"20",
                  @"share_status": @"1",
                  @"is_used":@"0"};
    
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonArrayWXOperationWithParam:submitDic
                                              action:@"serviceCode/service/list"
                                          modelClass:[TicketModel class]
                                      normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (status.intValue > 0 && array.count > 0)
         {
             if (_pageIndex == 1)
             {
                 _ticketArray = array;
             }
             else
             {
                 [_ticketArray addObjectsFromArray:array];
             }
             if (array.count >= 20)
             {
                 _canLoadMore = YES;
                 _pageIndex++;
             }
             else
             {
                 _canLoadMore = NO;
             }
             _noTickeyImageView.hidden = YES;
             _ticketListTableView.hidden = NO;
             [_ticketListTableView reloadData];
         }
         else
         {
             if (_pageIndex == 1)
             {
                 _noTickeyImageView.hidden = NO;
                 _ticketListTableView.hidden = YES;
             }
             else
             {
                 _noTickeyImageView.hidden = YES;
                 _ticketListTableView.hidden = NO;
             }
             _canLoadMore = NO;
         }
         self.view.userInteractionEnabled = YES;
         [_ticketListTableView tableViewHeaderEndRefreshing];
     }
                                   exceptionResponse:^(NSError *error)
     {
         self.view.userInteractionEnabled = YES;
         _noTickeyImageView.hidden = NO;
         _ticketListTableView.hidden = YES;
         _canLoadMore = NO;
         [_ticketListTableView tableViewHeaderEndRefreshing];
         [self.view makeToast:[error domain]];
     }];
}

- (void)getMoreUserTickets
{
    if (!_canLoadMore)
    {
        [_ticketListTableView tableViewfooterEndRefreshing];
        return;
    }
    NSDictionary *submitDic = nil;
    submitDic = @{@"service_type":self.serviceType,
                  @"member_id":_userInfo.member_id,
                  @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
                  @"page_size":@"20",
                  @"share_status": @"1",
                  @"is_used":@"0"};
    
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonArrayWXOperationWithParam:submitDic
                                              action:@"serviceCode/service/list"
                                          modelClass:[TicketModel class]
                                      normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (status.intValue > 0 && array.count > 0)
         {
             if (_pageIndex == 1)
             {
                 _ticketArray = array;
             }
             else
             {
                 [_ticketArray addObjectsFromArray:array];
             }
             if (array.count >= 20)
             {
                 _canLoadMore = YES;
                 _pageIndex++;
             }
             else
             {
                 _canLoadMore = NO;
             }
             [_ticketListTableView tableViewfooterEndRefreshing];
             [_ticketListTableView reloadData];
         }
         else
         {
             if (_pageIndex == 1)
             {
                 _noTickeyImageView.hidden = NO;
                 _ticketListTableView.hidden = YES;
             }
             else
             {
                 _noTickeyImageView.hidden = YES;
                 _ticketListTableView.hidden = NO;
             }
             [_ticketListTableView tableViewfooterEndRefreshing];
             _canLoadMore = NO;
         }
         self.view.userInteractionEnabled = YES;
     }
                                   exceptionResponse:^(NSError *error)
     {
         self.view.userInteractionEnabled = YES;
         [_ticketListTableView tableViewfooterEndRefreshing];
         _noTickeyImageView.hidden = NO;
         _ticketListTableView.hidden = YES;
         _canLoadMore = NO;
         [self.view makeToast:[error domain]];
     }];
}


#pragma mark - UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ticketArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146.0*SCREEN_WIDTH/375.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PresentedTicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ticketCellIndentifier];
    
    if (cell == nil)
    {
        cell = [[PresentedTicketsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ticketCellIndentifier];
    }
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    TicketModel *model = _ticketArray[indexPath.row];
    
    [cell setDisplayInfo:model];
    
    if([self findObjectInSelectArray:model]){
        [cell setItemSelected:YES];
    }else{
        [cell setItemSelected:NO];
    }
    
    
    return cell;
}



#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tfTextField.isFirstResponder){
        [self closeKeyBoard];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TicketModel *model = _ticketArray[indexPath.row];
    BOOL flag = [self findObjectInSelectArray:model];
    if(flag){
        [self removObjById:model.code_id];
    }
    else{
        [_selectedTicketArray addObject:model];
    }
    
    [_ticketListTableView reloadData];
}

- (BOOL) findObjectInSelectArray:(TicketModel *) model
{
    BOOL flag = NO;
    for(int i = 0 ; i < _selectedTicketArray.count; i++){
        TicketModel *obj = [_selectedTicketArray objectAtIndex:i];
        if([obj.code_id isEqualToString:model.code_id]){
            flag = YES;
            break;
        }
    }
    
    return flag;
}

#pragma PresentedTicketsTableViewCellDelegate
- (void) notifyItemSelected:(PresentedTicketsTableViewCell *) cell selectedFlag:(BOOL) flag indexPath:(NSIndexPath*)indexPath
{
    TicketModel *model = _ticketArray[indexPath.row];
    if(flag){
        [_selectedTicketArray addObject:model];
    }
    else{
        [self removObjById:model.code_id];
    }
}

- (void) removObjById:(NSString *) objId
{
    for(int i = 0 ; i < _selectedTicketArray.count; i++){
        TicketModel *obj = [_selectedTicketArray objectAtIndex:i];
        if([obj.code_id isEqualToString:objId]){
            [_selectedTicketArray removeObject:obj];
            break;
        }
    }
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
//    CGRect frame = _incomeBar.frame;
//    _incomeBar.frame = CGRectMake(0, frame.origin.y - kbSize.height, frame.size.width, frame.size.height);
    _inputBarConstant.constant = kbSize.height;
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //do something
//    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
//    CGRect frame = _incomeBar.frame;
//    CGRect viewframe = self.view.frame;
//    _incomeBar.frame = CGRectMake(0, viewframe.size.height - kbSize.height - frame.size.height, frame.size.width, frame.size.height);
    _inputBarConstant.constant = 0;
}

#pragma ACTION 
- (IBAction) doBtnSubmit:(UIButton *) sender
{
    [self closeKeyBoard];
    
    if(_selectedTicketArray.count == 0)
    {
        [self.view makeToast:@"请选择您要赠送的优惠券"];
        return;
    }
    
    if (!_tfTextField.text || [_tfTextField.text length] == 0)
    {
        [self.view makeToast:@"请输入接受人的手机号"];
        return;
    }
    if (_tfTextField.text.length < 11)
    {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    
    if([_tfTextField.text isEqualToString:_userInfo.member_phone]){
        [self.view makeToast:@"不能转赠给自己"];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"确定将所选优惠券转赠给%@用户，一旦确定将无法返还。", _tfTextField.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"再想一想" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSString *phoneNUm = _tfTextField.text;
        
        NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
        [pramas setObject:_userInfo.member_id forKey:@"member_id"];
        [pramas setObject:phoneNUm forKey:@"member_phone"];
        NSMutableString *code = [[NSMutableString alloc] init];
        for (int i = 0; i < _selectedTicketArray.count; i++) {
            TicketModel *model = [_selectedTicketArray objectAtIndex:i];
            [code appendString:model.code_id];
            if(i < _selectedTicketArray.count - 1)
                [code appendString:@","];
        }
        [pramas setObject:code forKey:@"code_ids"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.view.userInteractionEnabled = NO;
        [WebService requestJsonWXOperationWithParam:pramas action:@"serviceCode/service/subShareCodes.xhtml" normalResponse:^(NSString *status, id data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            
            if(status.intValue > 0){
                [_ticketListTableView tableViewHeaderBeginRefreshing];
                [Constants showMessage:@"优惠券已赠送成功"];
            }
        } exceptionResponse:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
            [Constants showMessage:[error domain]];
        }];
    }
}

#pragma mark - UITextFieldDelegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _tfTextField)
    {
        if ([textField.text length] >= 11)
        {
            if ([string isEqualToString:@""])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else if (textField.text.length + string.length == 11)
        {
            textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            [self closeKeyBoard];
            return NO;
        }
        else
        {
            return YES;
        }
        
    }
    return YES;
}

- (void)closeKeyBoard
{
    [[self findFirstResponder:self.view] resignFirstResponder];
}

- (UIView *)findFirstResponder:(UIView*)view
{
    for ( UIView *childView in view.subviews )
    {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder])
        {
            return childView;
        }
        UIView *result = [self findFirstResponder:childView];
        if (result) return result;
    }
    return nil;
}

@end
