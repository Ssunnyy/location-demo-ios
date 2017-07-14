//
//  ChooseFunction_BTN.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "ChooseFunction_BTN.h"

@implementation ChooseFunction_BTN

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    kSetLayerShadow(self, 0, 1, 0.2, 1, [UIColor lightGrayColor]);
    
    self.IMGV = [[UIImageView alloc]initWithFrame:CGRectMake(kViewWidth(self)/2-70,
                                                             kViewHeight(self)/2-12.5,
                                                             21,25)];
    self.IMGV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.IMGV];
    
    self.Lab = [[UILabel alloc]initWithFrame:self.bounds];
    self.Lab.font = [UIFont systemFontOfSize:16];
    self.Lab.textAlignment = NSTextAlignmentCenter;
    self.Lab.numberOfLines = 0;
    self.Lab.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    [self addSubview:self.Lab];
    
    self.btn = [WDButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = self.bounds;
    self.btn.backgroundColor = [UIColor clearColor];
    self.btn.HilitedColor = kHilitedGray;
    [self addSubview:self.btn];
    
    return self;
}

- (void)cannotTouch
{
    UILabel *infoLab = [[UILabel alloc]initWithFrame:CGRectMake(kViewWidth(self)-49,
                                                                0,49,18)];
    infoLab.font = [UIFont systemFontOfSize:11];
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.numberOfLines = 0;
    infoLab.text = @"开发中";
    infoLab.backgroundColor = [UIColor colorWithWhite:0.931 alpha:1.000];
    [self addSubview:infoLab];
    
    self.btn.HilitedColor = nil;
}

@end
