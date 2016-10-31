//
//  HomeBulterMenuItem.m
//  
//
//  Created by cts on 15/10/29.
//
//

#import "HomeBulterMenuItem.h"

@implementation HomeBulterMenuItem

- (instancetype)initWithFrame:(CGRect)frame
                withImageName:(NSString*)imageName
                    withTitle:(NSString*)titleString
{
    self = [super initWithFrame:frame];
    
    if (self)
    {

        
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [_itemImageView setImage:[UIImage imageNamed:imageName]];
        [self addSubview:_itemImageView];
        
        _itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width+10, frame.size.width, 20)];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1.0];
        _itemLabel.font = frame.size.width > 80?[UIFont systemFontOfSize:16]:[UIFont systemFontOfSize:14];
        _itemLabel.text = titleString;
        [self addSubview:_itemLabel];
        
        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemButton.frame = self.bounds;
        [_itemButton addTarget:self
                        action:@selector(didItemButtonTouch)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_itemButton];
    }
    
    return self;
}

- (void)didItemButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didHomeBulterMenuItemTouch:)])
    {
        [self.delegate didHomeBulterMenuItemTouch:self.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
