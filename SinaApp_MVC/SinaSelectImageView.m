//
//  SinaSelectImageView.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/6/3.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaSelectImageView.h"

@implementation SinaSelectImageView
-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        
        //self.backgroundColor = [UIColor redColor];
        
        self.userInteractionEnabled = YES;
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"compose_delete"] forState:UIControlStateNormal];
        
        CGFloat buttonW = 24;
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.frame)-buttonW, 0, buttonW, buttonW);
        
        [self addSubview:_deleteButton];
    }
    return self;
}

-(void)setIsAddButton:(BOOL)isAddButton{
    
    if (isAddButton) {
        
        CGRect buttonFrame = self.deleteButton.frame;
        buttonFrame.origin.x = 0;
        buttonFrame.origin.y = 0;
        buttonFrame.size = self.frame.size;
        self.deleteButton.frame = buttonFrame;
        [self.deleteButton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        CGFloat buttonW = 24;
        self.deleteButton.frame = CGRectMake(CGRectGetWidth(self.frame)-buttonW, 0, buttonW, buttonW);
        [self.deleteButton setImage:[UIImage imageNamed:@"compose_delete"] forState:UIControlStateNormal];
    }
}
@end













