//
//  InfoViewController.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.navigationItem.title = @"信息提示";
    
    UIBarButtonItem *backBTN = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"向左箭头头"] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backBTN;
    
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.view.backgroundColor = [UIColor colorWithWhite:0.951 alpha:1.000];
    
    UIScrollView *scrv = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 25,
                                                                      kViewWidth(self.view)-40,
                                                                       kViewHeight(self.view)-50)];
    [self.view addSubview:scrv];
    
    scrv.alwaysBounceVertical = YES;
    
    UIImage *img = [UIImage imageNamed:@"text"];
    UIImageView *IMGV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                     kViewWidth(self.view)-40,
                                                                     (img.size.height/img.size.width)*(kViewWidth(self.view)-40))];
    IMGV.contentMode = UIViewContentModeScaleAspectFit;
    IMGV.image = img;
    
    [scrv addSubview:IMGV];
}

- (void)addTextView{
    UITextView *texview = [[UITextView alloc]initWithFrame:CGRectMake(20, 25,
                                                                      kViewWidth(self.view)-40,
                                                                      kViewHeight(self.view)-50)];
    texview.alwaysBounceVertical = YES;
    texview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:texview];
    
    NSString *showStr = @"位置同步\n开始位置上传后，将会以5秒一次的频率上传设备的位置信息。你可以在野狗[控制面板-实时通信引擎-数据预览]中查位置数据的变化。\n\n实时轨迹\n开始轨迹上传后，将会以5秒一次的品路上传设备的轨迹点。你可以在野狗[控制面板-实时通信引擎-数据预览]中查位置数据的变化。\n\n范围监听\n开启范围监听之后，将会监听在设备1000米内进行位置上传的设备。\n你可以使用多态设备进行位置上传进行测试。\n\n地理围栏\n开发中，敬请期待\n\n注意事项\n· \tDemo使用高德地图SDK展示，因此无法显示国外地图，如果使用Xcode模拟器进行测试，请将模拟器切换成自定义国内位置数据。\n· \t在功能开始的情况下离开页面时，功能会保持运行。你可以同时开启多个功能进行测试。";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:showStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0+4, 69-4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.400 alpha:1.000] range:NSMakeRange(0+4, 69-4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(69, 4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(69+4, 137-69-4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.400 alpha:1.000] range:NSMakeRange(69+4, 137-69-4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(137, 4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(137+4, 197-137-4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.400 alpha:1.000] range:NSMakeRange(137+4, 197-137-4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(197, 4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(197+4, 212-197-4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.400 alpha:1.000] range:NSMakeRange(197+4, 212-197-4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(212, 4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(212+4, showStr.length-213-4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.600 alpha:1.000] range:NSMakeRange(212+4, showStr.length-212-4)];
    
    texview.attributedText = attrStr;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    //状态栏变白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
