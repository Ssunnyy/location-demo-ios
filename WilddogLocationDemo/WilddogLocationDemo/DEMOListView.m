//
//  DEMOListView.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "DEMOListView.h"

@interface DEMOListView ()

@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *titleLab;

@property(nonatomic,strong)WDButton *openBTN;
@property(nonatomic,strong)UIImageView *flagIMGV;

@property(nonatomic,strong)UIView *listView;

@property(nonatomic,strong)UILabel *nodeviceLab;

@property(nonatomic,strong)UIScrollView *SCRV;

@property CGFloat originalY;

@property(nonatomic,strong)NSMutableArray *btnArr;

@property(nonatomic,strong) UIImageView *SCRVMask;

@end

@implementation DEMOListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.frame = CGRectMake(kRectX(frame),
                            kRectY(frame),
                            kScreenWidth-20,
                            50);
    self.backgroundColor = [UIColor clearColor];
    
    self.originalY = frame.origin.y;
    
    kSetLayerShadow(self, 0, 1, 0.3, 3, [UIColor lightGrayColor]);
    
    self.backView = [[UIView alloc]initWithFrame:self.bounds];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.alpha = 0.9;
    self.backView.layer.cornerRadius = 8;
    [self addSubview:self.backView];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kViewWidth(self), 50)];
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.numberOfLines = 0;
    self.titleLab.text = @"附近的设备列表";
    [self addSubview:self.titleLab];
    
    self.flagIMGV = [[UIImageView alloc]initWithFrame:CGRectMake(kViewWidth(self)-124+40,
                                                                                 20,
                                                                                 15,
                                                                                 9)];
    self.flagIMGV.contentMode = UIViewContentModeScaleAspectFit;
    self.flagIMGV.image = [UIImage imageNamed:@"向上箭头"];
    [self addSubview:self.flagIMGV];
    
    self.openBTN = [WDButton buttonWithType:UIButtonTypeCustom];
    self.openBTN.frame = self.bounds;
    self.openBTN.backgroundColor = [UIColor clearColor];
    self.openBTN.HilitedColor = kHilitedGray;
    kBTNsetAction(self.openBTN, touchedOpenOrClose);
    [self addSubview:self.openBTN];
    
    
    self.listView = [[UIView alloc]initWithFrame:CGRectMake(0, kViewHeight(self),
                                                           kViewWidth(self),
                                                            0)];
    self.listView.layer.masksToBounds = YES;
    [self addSubview:self.listView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth(self.listView), 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.3;
    [self.listView addSubview:line];
    
    self.SCRV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth(self.listView), 50)];
    self.SCRV.alwaysBounceVertical = YES;
    self.SCRV.showsVerticalScrollIndicator = NO;
    self.SCRV.backgroundColor = [UIColor clearColor];
    self.SCRV.contentSize = self.SCRV.bounds.size;
    [self.listView addSubview:self.SCRV];
    
    self.SCRVMask = [[UIImageView alloc]initWithFrame:CGRectMake(kViewX(self.SCRV),
                                                                         kViewMaxY(self.SCRV)-40,
                                                                         kViewWidth(self.SCRV),
                                                                         40)];
    self.SCRVMask.contentMode = UIViewContentModeScaleToFill;
    self.SCRVMask.image = [UIImage imageNamed:@"渐变填充"];
    self.SCRVMask.hidden = YES;
    [self.listView addSubview:self.SCRVMask];
    
    self.nodeviceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kViewWidth(self.listView), 50)];
    self.nodeviceLab.font = [UIFont systemFontOfSize:13];
    self.nodeviceLab.textAlignment = NSTextAlignmentCenter;
    self.nodeviceLab.numberOfLines = 0;
    self.nodeviceLab.textColor = [UIColor lightGrayColor];
    self.nodeviceLab.text = @"目前附近没有其他设备";
    [self.SCRV addSubview:self.nodeviceLab];
    
    self.btnArr = [NSMutableArray array];
    
    return self;
}

-(void)touchedOpenOrClose{
    if(self.openBTN.selected){
        self.openBTN.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(kViewX(self),
                                    self.originalY,
                                    kViewWidth(self),
                                    50);
            self.listView.frame = kRectSetHeight(self.listView.frame, 0);
            self.listView.alpha = 0;
            
            self.backView.frame = self.bounds;
            self.flagIMGV.image = [UIImage imageNamed:@"向上箭头"];
            
        }];
        
    }else{
        self.openBTN.selected = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.listView.frame = kRectSetHeight(self.listView.frame, kViewHeight(self.SCRV));
            self.listView.alpha = 1;
            
            self.frame = CGRectMake(kViewX(self),
                                    self.originalY - kViewHeight(self.listView),
                                    kViewWidth(self),
                                    50+kViewHeight(self.listView));
            
            self.backView.frame = self.bounds;
            self.flagIMGV.image = [UIImage imageNamed:@"向下箭头"];
            
        }];
    }
}


-(void)fresh{
    
    if(self.deviceArr.count>0){
        self.nodeviceLab.hidden = YES;
        if(self.deviceArr.count>5){
            self.SCRV.frame = CGRectMake(0, 0, kViewWidth(self.SCRV), 5*27+20);
            self.SCRVMask.frame = CGRectMake(kViewX(self.SCRV),
                                             kViewMaxY(self.SCRV)-40,
                                             kViewWidth(self.SCRV),
                                             40);
            self.SCRVMask.hidden = NO;
        }else{
            self.SCRV.frame = CGRectMake(0, 0, kViewWidth(self.SCRV), self.deviceArr.count*27+20);
            self.SCRVMask.hidden = YES;
        }
        
        self.SCRV.contentSize = CGSizeMake(kViewWidth(self.SCRV), self.deviceArr.count*27+20);
        for (UIView *subv in self.SCRV.subviews) {
            if(subv!=self.nodeviceLab){
                [subv removeFromSuperview];
            }
        }
        [self.btnArr removeAllObjects];
        for (int i=0;i<self.deviceArr.count;i++) {
            NSString *dev = self.deviceArr[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:dev forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.174 green:0.640 blue:0.284 alpha:1.000] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.frame = CGRectMake(0, 10+i*27, kViewWidth(self), 27);
            btn.tag = 88+i;
            kBTNsetAction(btn, ChoosedDevice:);
            [self.btnArr addObject:btn];
            [self.SCRV addSubview:btn];
        }
        
    }else{
        self.nodeviceLab.hidden = NO;
        self.SCRV.frame = CGRectMake(0, 0, kViewWidth(self.listView), 50);
        self.SCRV.contentSize = self.SCRV.bounds.size;
    }
    
    if(self.openBTN.selected){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.listView.frame = kRectSetHeight(self.listView.frame, kViewHeight(self.SCRV));
            self.listView.alpha = 1;
            
            self.frame = CGRectMake(kViewX(self),
                                    self.originalY - kViewHeight(self.listView),
                                    kViewWidth(self),
                                    50+kViewHeight(self.listView));
            
            self.backView.frame = self.bounds;
            self.flagIMGV.image = [UIImage imageNamed:@"向下箭头"];
            
            
        }];
        
    }
}

-(void)ChoosedDevice:(UIButton *)btn{
    long index = btn.tag-88;
    
    NSString *dev = self.deviceArr[index];
    
    [self.delegate demoListViewChoosedDevice:dev];
    
    btn.selected = YES;
    
    for (UIButton *btn2 in self.btnArr) {
        if(btn2 != btn){
            btn2.selected = NO;
        }
    }
}


-(void)selectDev:(NSString *)dev{
    int index = 0;
    for(int i=0;i<self.deviceArr.count;i++){
        NSString *loopdev = self.deviceArr[i];
        if([loopdev isEqualToString:dev]){
            index = i;
        }
    }
    
    UIButton *btn = self.btnArr[index];
    [self ChoosedDevice:btn];
}
@end
