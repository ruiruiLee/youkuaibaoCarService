//
//  CustomActionSheet.h
//  
//
//  Created by cts on 15/10/20.
//
//

#import <UIKit/UIKit.h>
#import "CustomActionSheetItem.h"


@protocol CustomActionSheetDelegate <NSObject>

- (void)customActionWillDismissWithButtonIndex:(NSInteger)buttonIndex andActionSheetTag:(NSInteger)tagValue;

@end


@interface CustomActionSheet : UIView



+ (void)showCustomActionSheetWithDelegate:(id<CustomActionSheetDelegate>)delegate
                                withItems:(NSArray*)itemArray
                     andCancelButtonTitle:(NSString*)titleString;

@property (assign, nonatomic) id <CustomActionSheetDelegate> delegate;


@end
