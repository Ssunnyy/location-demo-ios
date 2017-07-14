//
//  ChooseFunctionViewController.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "ChooseFunctionViewController.h"
#import "ChooseFunction_BTN.h"

#import "TracingPositionViewController.h"
#import "RecordingPathViewController.h"
#import "CircleQueryViewController.h"

@interface ChooseFunctionViewController ()

@end

@implementation ChooseFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //配置界面
    [self setUpUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/**
 *  选择了位置同步
 */
- (void)touchedTracingPosition{
    
    TracingPositionViewController *vc = [TracingPositionViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  选择了实时轨迹
 */
- (void)touchedRecordingPath{
    
    RecordingPathViewController *vc = [RecordingPathViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  选择了监听范围
 */
- (void)touchedObserveCircleQuery{
    
    CircleQueryViewController *vc = [CircleQueryViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}



//--------------------------------------------------

/**
 *  界面配置
 */
- (void)setUpUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor colorWithWhite:0.951 alpha:1.000];
    
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    
    UIImageView *LOGO = [[UIImageView alloc]initWithFrame:CGRectMake(0,20,
                                                                     kScreenWidth,
                                                                     kScreenScaleHeightWith6(190))];
    LOGO.contentMode = UIViewContentModeScaleAspectFit;
    LOGO.image = [UIImage imageNamed:@"底se"];
    [self.view addSubview:LOGO];
    
    
    UILabel *titleA = [[UILabel alloc]initWithFrame:CGRectMake(0, 49+20,
                                                               kViewWidth(self.view),
                                                               22)];
    titleA.font = [UIFont systemFontOfSize:20];
    titleA.textAlignment = NSTextAlignmentCenter;
    titleA.numberOfLines = 0;
    titleA.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    titleA.text = @"AppID";
    [self.view addSubview:titleA];
    
    UILabel *titleB = [[UILabel alloc]initWithFrame:CGRectMake(0,kViewMaxY(titleA)+11,
                                                               kViewWidth(self.view),
                                                               16)];
    titleB.font = [UIFont systemFontOfSize:15];
    titleB.textAlignment = NSTextAlignmentCenter;
    titleB.numberOfLines = 0;
    titleB.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    titleB.text = self.apppid;
    [self.view addSubview:titleB];
    
    WDButton *changeAppIdBTN  = [WDButton buttonWithType:UIButtonTypeCustom];
    changeAppIdBTN.frame = CGRectMake(0, kViewMaxY(titleB)+26, kScreenWidth, 18);
    [changeAppIdBTN setTitle:@"切换" forState:UIControlStateNormal];
    [changeAppIdBTN setTitleColor:kThemeColor forState:UIControlStateNormal];
    [changeAppIdBTN setTitleColor:kHilitedOrange forState:UIControlStateHighlighted];
    [changeAppIdBTN addTarget:self action:@selector(touchedChangeAppID) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeAppIdBTN];
    
    UIScrollView *SCRV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kScreenScaleHeightWith6(204), kScreenWidth, kScreenHeight-kScreenScaleHeightWith6(204))];
    SCRV.backgroundColor = [UIColor clearColor];
    SCRV.alwaysBounceVertical = YES;
    SCRV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:SCRV];
    
    ChooseFunction_BTN *tra = [[ChooseFunction_BTN alloc]initWithFrame:CGRectMake(0, 10,
                                                                                  kScreenWidth,
                                                                                  kScreenScaleHeightWith6(55))];
    tra.IMGV.image = [UIImage imageNamed:@"位置同步"];
    tra.Lab.text = @"位置同步";
    kBTNsetAction(tra.btn, touchedTracingPosition);
    [SCRV addSubview:tra];
    
    ChooseFunction_BTN *path = [[ChooseFunction_BTN alloc]initWithFrame:CGRectMake(0,
                                                                                  kViewMaxY(tra)+kScreenScaleHeightWith6(5),
                                                                                  kScreenWidth,
                                                                                  kScreenScaleHeightWith6(55))];
    path.IMGV.image = [UIImage imageNamed:@"实时轨迹"];
    path.Lab.text = @"实时轨迹";
    kBTNsetAction(path.btn, touchedRecordingPath);
    [SCRV addSubview:path];
    
    ChooseFunction_BTN *Observe = [[ChooseFunction_BTN alloc]initWithFrame:CGRectMake(0,
                                                                                   kViewMaxY(path)+kScreenScaleHeightWith6(5),
                                                                                   kScreenWidth,
                                                                                   kScreenScaleHeightWith6(55))];
    Observe.IMGV.image = [UIImage imageNamed:@"范围监听"];
    Observe.Lab.text = @"范围监听";
    kBTNsetAction(Observe.btn, touchedObserveCircleQuery);
    [SCRV addSubview:Observe];
    
    
    ChooseFunction_BTN *fenth = [[ChooseFunction_BTN alloc]initWithFrame:CGRectMake(0,
                                                                                      kViewMaxY(Observe)+kScreenScaleHeightWith6(5),
                                                                                      kScreenWidth,
                                                                                      kScreenScaleHeightWith6(55))];
    fenth.IMGV.image = [UIImage imageNamed:@"地理围栏"];
    fenth.Lab.text = @"地理围栏";
    fenth.Lab.textColor = [UIColor colorWithWhite:0.542 alpha:1.000];
    [fenth cannotTouch];
    kBTNsetAction(fenth.btn, alertInProgress);
    [SCRV addSubview:fenth];
    
}


- (void)touchedChangeAppID{
    
    [[SDKManager defaultManager] clear];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)alertInProgress{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"敬请期待"
                                                                             message:@"地理围栏功能正在开发中"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好的"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
