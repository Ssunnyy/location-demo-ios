//
//  WDButton.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/11.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDButton.h"

@interface WDButton ()

@property(nonatomic,strong)UIColor *BackBackGroundColor;

@property(nonatomic,strong)NSTimer *HeilitedTimer;

@end

@implementation WDButton

+(instancetype)buttonWithType:(UIButtonType)buttonType{
    
    WDButton *btn = [super buttonWithType:buttonType];
    
    [btn addTarget:btn action:@selector(buttonClick) forControlEvents:UIControlEventTouchDown];
    
    [btn addTarget:btn action:@selector(buttonClick1) forControlEvents:UIControlEventTouchUpInside];
    
    [btn addTarget:btn action:@selector(buttonClick1) forControlEvents:UIControlEventTouchDragOutside];
    
    return btn;
}

-(void)buttonClick{
    if(self.HilitedColor){
        self.BackBackGroundColor = self.backgroundColor;
        self.backgroundColor = self.HilitedColor;
        self.HeilitedTimer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(TouchDownTimeOut) userInfo:nil repeats:NO];
    }
}
-(void)buttonClick1{
    if(self.HilitedColor){
        [self.HeilitedTimer invalidate];
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = self.BackBackGroundColor;
        }];
    }
}

-(void)TouchDownTimeOut{
    if(self.backgroundColor != self.BackBackGroundColor){
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = self.BackBackGroundColor;
        }];
    }
}

@end
