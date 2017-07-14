//
//  TracingPositionViewController.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "TracingPositionViewController.h"
#import "InfoViewController.h"

@interface TracingPositionViewController ()<MAMapViewDelegate>

//--------------------------显示
//下面的大按钮
@property (nonatomic,strong ) WDButton  *bigBTN;
//地图view
@property (nonatomic,strong ) MAMapView *mapView;
//地图上显示的定位点
@property(nonatomic,strong)MAAnimatedAnnotation *pointAnnotation;
//顶部显示的info
@property(nonatomic,strong)UIView  *infoView;
@property(nonatomic,strong)UILabel *infoLab;
//回到自己位置的BTN
@property(nonatomic,strong)WDButton *centerBTN;
//--------------------------查询相关
//查询自己位置的handle
@property WilddogHandle handle;

@end

@implementation TracingPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置界面
    [self setUpUI];
    
    //如果监听之前就打开了一直没关
    if([SDKManager defaultManager].tracingstarted){
        self.bigBTN.selected = YES;
        self.bigBTN.backgroundColor = [UIColor whiteColor];
        self.infoView.hidden = NO;
        self.infoLab.hidden  = NO;
        [self setUpLoationObserve];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    //状态栏变白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //检查权限
    [self AlertPrivacyIfNeed];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    self.mapView.delegate = nil;
    [[SDKManager defaultManager].locationService removeObserverWithHandle:self.handle];
    
}

/**
 *  点击了开始、关闭 位置同步的按钮
 */
-(void)touchedStartTracing{
    
    if(self.bigBTN.selected){
        //关闭监听
        [self stopTracingLocation];
    }else{
        //开启监听
        [self startTracingLocation];
    }
}

/**
 *  停止位置同步
 */
- (void)stopTracingLocation{
    //标记状态
    [SDKManager defaultManager].tracingstarted = NO;
    
    //处理UI
    self.bigBTN.selected = NO;
    self.bigBTN.backgroundColor = kThemeColor;
    [self.mapView removeAnnotation:self.pointAnnotation];
    self.centerBTN.hidden = YES;
    //停止同步
    [[SDKManager defaultManager].locationService stopTracingPositionForKey:[SDKManager defaultManager].uuid];
    
    //停止监听位置信息
    [[SDKManager defaultManager].locationService removeObserverWithHandle:self.handle];
}

/**
 *  开始位置同步
 */
- (void)startTracingLocation{
    //标记状态
    [SDKManager defaultManager].tracingstarted = YES;
    
    //设置位置监听
    [self setUpLoationObserve];
    
    //开始及同步
    [[SDKManager defaultManager].locationService startTracingPositionForKey:[SDKManager defaultManager].uuid withCompletionBlock:^(NSError * _Nullable error) {
        if(error){
            [self AlertPrivacyIfNeed];
        }else{
            //处理UI
            self.bigBTN.selected = YES;
            self.bigBTN.backgroundColor = [UIColor whiteColor];
            self.infoView.hidden = NO;
            self.infoLab.hidden  = NO;
            
            [self AlertOpenSucc];
        }
    }];
}

/**
 *  设置位置监听
 */
- (void)setUpLoationObserve{
    
    __weak typeof (self) weakSelf = self;
    __block BOOL onece = NO;
    self.handle = [[SDKManager defaultManager].locationService
                   observePositionForKey:[SDKManager defaultManager].uuid
                   withBlock:^(WDGPosition * _Nullable position, NSError * _Nullable error)
                   {
                       NSLog(@"Current Position: %@", position);
                       CLLocationCoordinate2D point = CLLocationCoordinate2DMake(position.latitude,
                                                                                 position.longitude);
                       //检测一下定位点是否可用
                       //[self AlertVailableIfNeedFOrLa:point.latitude lo:point.longitude];
                       self.centerBTN.hidden = NO;
                       if(AMapDataAvailableForCoordinate(point)){
                           if(!onece){
                               //第一次拿到位置
                               onece = YES;
                               
                               //在地图上显示定位点
                               weakSelf.pointAnnotation = [[MAAnimatedAnnotation alloc] init];
                               weakSelf.pointAnnotation.coordinate = point;
                               [weakSelf.mapView addAnnotation:weakSelf.pointAnnotation];
                               
                               //设缩放
                               [weakSelf.mapView setZoomLevel:14.25        animated:YES];
                               
                           }else{
                               //不是第一次拿到定位点
                               [weakSelf moveAnnotation:weakSelf.pointAnnotation toLocation:point];
                           }
                           //设中心点
                           [weakSelf.mapView setCenterCoordinate:point animated:YES];
                           
                           //刷新顶部显示的信息
                           NSDateFormatter *formater = [NSDateFormatter new];
                           formater.dateFormat = @"最近上传: HH:mm:ss";
                           weakSelf.infoLab.text = [formater stringFromDate:[NSDate date]];
                       }
                       
                   }];
}

/**
 *  把自己的定位点设成地图的中心店
 */
-(void)movetoCenter{
    if(self.pointAnnotation){
        [self.mapView setZoomLevel:14.25 animated:YES];
        [self.mapView setCenterCoordinate:self.pointAnnotation.coordinate
                                 animated:YES];
    }
}

/**
 *  移动地图上的点
 *
 *  @param annotation 地图上的点
 *  @param location   移动的目标坐标
 */
- (void)moveAnnotation:(MAAnimatedAnnotation *)annotation toLocation:(CLLocationCoordinate2D)location{
    CLLocationCoordinate2D locations[1];
    locations[0] = location;
    
    [annotation addMoveAnimationWithKeyCoordinates:locations
                                             count:1
                                      withDuration:0.5
                                          withName:nil
                                  completeCallback:nil];
}

/**
 *  界面配置
 */
- (void)setUpUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.navigationItem.title = @"位置同步";
    UIBarButtonItem *infoBTN = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"提示信息"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(showInfo)];
    self.navigationItem.rightBarButtonItem = infoBTN;
    
    UIBarButtonItem *backBTN = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"向左箭头头"]
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backBTN;
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.view.backgroundColor = [UIColor colorWithWhite:0.951 alpha:1.000];
    
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    self.mapView.showsCompass  = NO;
    [self.view addSubview:self.mapView];
    
    self.bigBTN = [WDButton buttonWithType:UIButtonTypeCustom];
    self.bigBTN.frame = CGRectMake(10, kScreenHeight-64-50-17, kScreenWidth-20, 50);
    self.bigBTN.layer.cornerRadius = 8;
    [self.bigBTN setTitle:@"开启位置上传"              forState:UIControlStateNormal];
    [self.bigBTN setTitle:@"关闭位置上传"              forState:UIControlStateSelected];
    [self.bigBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bigBTN setTitleColor:kThemeColor          forState:UIControlStateSelected];
    self.bigBTN.backgroundColor = kThemeColor;
    self.bigBTN.HilitedColor = kHilitedOrange;
    kSetLayerShadow(self.bigBTN, 0, 2, 0.1, 2, kThemeColor);
    kBTNsetAction(self.bigBTN, touchedStartTracing);
    [self.view addSubview:self.bigBTN];
    
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoView.alpha = 0.9;
    kSetLayerShadow(self.infoView, 0, 1, 0.2, 1, kThemeColor);
    [self.view addSubview:self.infoView];
    self.infoLab      = [[UILabel alloc]initWithFrame:self.infoView.frame];
    self.infoLab.font = [UIFont systemFontOfSize:12];
    self.infoLab.textColor = [UIColor colorWithRed:0.059 green:0.378 blue:0.998 alpha:1.000];
    self.infoLab.textAlignment = NSTextAlignmentCenter;
    self.infoLab.numberOfLines = 0;
    [self.view addSubview:self.infoLab];
    
    self.centerBTN = [WDButton buttonWithType:UIButtonTypeCustom];
    [self.centerBTN setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    self.centerBTN.frame = CGRectMake(kScreenWidth-10-35, 10+kViewHeight(self.infoView), 35, 35);
    self.centerBTN.backgroundColor = [UIColor whiteColor];
    self.centerBTN.HilitedColor = kHilitedGray;
    self.centerBTN.layer.cornerRadius = 2;
    self.centerBTN.hidden = YES;
    kSetLayerShadow(self.centerBTN, 0, 1, 0.1, 2, kThemeColor);
    kBTNsetAction(self.centerBTN, movetoCenter);
    [self.view addSubview:self.centerBTN];
    
    self.infoView.hidden = YES;
    self.infoLab.hidden  = YES;
    
}

-(void)showInfo{
    [self.navigationController pushViewController:[InfoViewController new]
                                         animated:YES];
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  给用户提示开启成功
 */
- (void)AlertOpenSucc{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"开启成功 "
                                                                             message:@"你可以在[野狗-控制面板-数据预览]\n页面看到位置数据的更新"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  如果没有权限，就给用户提醒一下需要开权限
 */
- (void)AlertPrivacyIfNeed{
    
    if(![[SDKManager defaultManager]PrivacyOK]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"位置获取失败"
                                                                                 message:@"请在“设置”中允许“实时定位示例”\n获取位置"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //NSLog(@"相关操作");
                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //NSLog(@"相关操作");
                                                              
                                                          }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

/**
 *  如果定位点不在国内要给用户一个提示
 */
-(void)AlertVailableIfNeedFOrLa:(double)la lo:(double)lo{
    if(!AMapDataAvailableForCoordinate(CLLocationCoordinate2DMake(la, lo))) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"定位不在国内"
                                                                                 message:@"Demo使用高德地图SDK展示，因此无法显示国外地图，如果使用Xcode模拟器进行测试，请将模拟器切换成自定义国内位置数据。"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma  mark -- MAMapViewDelegate
//高德地图的显示的相关代理设置
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"点位"];
        return annotationView;
    }
    return nil;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
