//
//  CircleQueryViewController.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "CircleQueryViewController.h"
#import "DEMOListView.h"

#import "InfoViewController.h"

@interface CircleQueryViewController ()<MAMapViewDelegate,DEMOListViewDelegate>

//--------------------------显示
//下面的大按钮
@property (nonatomic,strong ) WDButton  *bigBTN;
//地图view
@property (nonatomic,strong ) MAMapView *mapView;
//显示附近的设备列表view
@property (nonatomic,strong) DEMOListView *listView;
//画在地图上的圆圈
@property(nonatomic,strong)MACircle *circle;
//回到自己位置的BTN
@property(nonatomic,strong)WDButton *centerBTN;
//--------------------------查询相关
//定位自己位置的handle
@property WilddogHandle selfHandle;
//查询附近的人的query
@property (nonatomic,strong) WDGCircleQuery *circleQuery;

//--------------------------定位点和坐标
//自己的位置的定位显示点
@property (nonatomic,strong) MAAnimatedAnnotation *pointAnnotation;
//自己的位置信息
@property CLLocationCoordinate2D selfLocation;
//选中的定位点
@property (nonatomic,strong) MAAnimatedAnnotation *ChoosedpointAnnotation;
//key =》 别人的定位点
@property (nonatomic,strong) NSMutableDictionary *annotationMap;

@end

@implementation CircleQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置界面
    [self setUpUI];
    
    //恢复状态
    if([SDKManager defaultManager].circleQueryTracingStarted){
        [self touchedStartTracing];
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
    
    self.mapView.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    self.mapView.delegate = nil;
    //停止监听
    [self.circleQuery removeAllObservers];
    //停止监听自己，条件是为了不对“位置监听demo”造成干扰
    if(![SDKManager defaultManager].tracingstarted){
        [[SDKManager defaultManager].locationService removeObserverWithHandle:self.selfHandle];
    }
    [self.circleQuery removeAllObservers];
}

/**
 *  点击了开始、关闭监听的按钮
 */
-(void)touchedStartTracing{
    
    if(self.bigBTN.selected){
        //关闭监听
        [self chooseToCloseCircleQuery];
        
    }else{
        //开启监听
        [self chooseToOpenCircleQuery];
        
    }
}

/**
 *  用户想要关闭范围监听
 */
- (void)chooseToCloseCircleQuery{
    //标记状态
    [SDKManager defaultManager].circleQueryTracingStarted = NO;
    
    //处理UI
    self.bigBTN.selected = NO;
    self.listView.hidden = YES;
    self.bigBTN.backgroundColor = kThemeColor;
    self.centerBTN.hidden = YES;
    
    //处理地图显示
    [self.mapView removeOverlay:self.circle];
    if(self.annotationMap.allValues.count>0){
        [self.mapView removeAnnotations:self.annotationMap.allValues];
    }
    [self.mapView removeAnnotation:self.pointAnnotation];
    
    //停止监听
    [self.circleQuery removeAllObservers];
    //停止监听自己，条件是为了不对“位置监听demo”造成干扰
    if(![SDKManager defaultManager].tracingstarted){
        [[SDKManager defaultManager].locationService removeObserverWithHandle:self.selfHandle];
    }
    
}

/**
 *  用户想要开始范围监听
 */
- (void)chooseToOpenCircleQuery{
    //标记状态
    [SDKManager defaultManager].circleQueryTracingStarted = YES;
    
    //处理UI
    self.bigBTN.selected = YES;
    self.bigBTN.backgroundColor = [UIColor whiteColor];
    self.listView.hidden = NO;
    
    //用来储存 附近的人的点和key的对应关系
    self.annotationMap = [NSMutableDictionary dictionary];
    
    //获得自己的位置
    if (![SDKManager defaultManager].tracingstarted){
        [[SDKManager defaultManager].locationService startTracingPositionForKey:[SDKManager defaultManager].uuid];
    }
    __weak typeof (self) weakSelf = self;
    __block BOOL once = NO;
    self.selfHandle = [[SDKManager defaultManager].locationService
                       observePositionForKey:[SDKManager defaultManager].uuid
                       withBlock:^(WDGPosition * _Nullable position, NSError * _Nullable error)
    {
        //拿到了自己的位置 ，或是刷新
        NSLog(@"Current Position: %@", position);
        CLLocationCoordinate2D selfLocation = CLLocationCoordinate2DMake(position.latitude,
                                                                         position.longitude);
        self.selfLocation = selfLocation;
        //检测一下定位点是否可用
        //[self AlertVailableIfNeedFOrLa:position.latitude lo:position.longitude];
        self.centerBTN.hidden = NO;
        if(AMapDataAvailableForCoordinate(selfLocation)){
        if(!once){
            //第一次得到自己的位置
            once = YES;
            
            //给自己建一个地图显示点
            weakSelf.pointAnnotation = [[MAAnimatedAnnotation alloc] init];
            weakSelf.pointAnnotation.coordinate = selfLocation;
            [weakSelf.mapView addAnnotation:weakSelf.pointAnnotation];
            
            //把自己的点加入到地图上显示
            [weakSelf.mapView setZoomLevel:14.25 animated:YES];
            [weakSelf.mapView setCenterCoordinate:selfLocation animated:YES];
            
            //在地图上显示一个圆圈,高德地图的单位是米
            weakSelf.circle = [MACircle circleWithCenterCoordinate:selfLocation radius:1000];
            [weakSelf.mapView addOverlay: weakSelf.circle];
            
            //设置范围监听,范围单位是公里
            WDGPosition *centerPosition = [[WDGPosition alloc] initWithLatitude:selfLocation.latitude
                                                                      longitude:selfLocation.longitude];
            weakSelf.circleQuery = [[SDKManager defaultManager].locationService circleQueryAtPosition:centerPosition
                                                                                       withRadius:1];
            //开始监听
            [weakSelf StartObserveWithCircleQuery:self.circleQuery];
            
        }else{
            //刷新了位置，更新一下地图上的显示
            NSLog(@"----------");
            NSLog(@"%f",selfLocation.latitude);
            NSLog(@"%f",selfLocation.longitude);
            [weakSelf moveAnnotation:weakSelf.pointAnnotation toLocation:selfLocation];
        }
        }
    }];
}

/**
 *  通过设置好的circleQuery进行监听
 *
 *  @param query 设置好的circleQuery
 */
- (void)StartObserveWithCircleQuery:(WDGCircleQuery *)query{
    //进入监听
    [query observeEventType:WDGQueryEventTypeEntered
                             withBlock:^(NSString * _Nonnull key,
                                         WDGPosition * _Nonnull location)
     {
         if(![key isEqualToString:[SDKManager defaultManager].uuid]){
             NSLog(@"进入:%@",key);
             NSLog(@"sdkID:%@",[SDKManager defaultManager].uuid);
             //建立地图上显示的定位点
             MAAnimatedAnnotation *newpointAnnotation = [[MAAnimatedAnnotation alloc] init];
             newpointAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude,
                                                                        location.longitude);
             [self.mapView addAnnotation:newpointAnnotation];
             
             //保存一下
             [self.annotationMap setObject:newpointAnnotation forKey:key];
             
             //刷新界面上下方的列表View
             self.listView.deviceArr = [NSMutableArray arrayWithArray:self.annotationMap.allKeys];
             [self.listView fresh];
         }
     }];
    
    //移动监听
    [query observeEventType:WDGQueryEventTypeMoved
                             withBlock:^(NSString * _Nonnull key,
                                         WDGPosition * _Nonnull location)
     {
         if(![key isEqualToString:[SDKManager defaultManager].uuid]){
             NSLog(@"移动");
             MAAnimatedAnnotation *ann = [self.annotationMap objectForKey:key];
             [self moveAnnotation:ann toLocation:CLLocationCoordinate2DMake(location.latitude,
                                                                            location.longitude)];
         }
     }];
    //退出监听
    [query observeEventType:WDGQueryEventTypeExited
                             withBlock:^(NSString * _Nonnull key,
                                         WDGPosition * _Nonnull location)
     {
         NSLog(@"退出,%@",key);
         //移除地图上显示的定位点
         MAAnimatedAnnotation *ann = [self.annotationMap objectForKey:key];
         if(ann && ![key isEqualToString:[SDKManager defaultManager].uuid]){
             [self.mapView removeAnnotation:ann];
         }
         
         
         [self.annotationMap removeObjectForKey:key];
         //刷新界面上下方的列表View
         self.listView.deviceArr = [NSMutableArray arrayWithArray:self.annotationMap.allKeys];
         [self.listView fresh];
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
        self.ChoosedpointAnnotation = nil;
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

-(void)showInfo{
    [self.navigationController pushViewController:[InfoViewController new]
                                         animated:YES];
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  界面配置
 */
- (void)setUpUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.navigationItem.title = @"范围监听";
    UIBarButtonItem *infoBTN = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"提示信息"] style:UIBarButtonItemStylePlain target:self action:@selector(showInfo)];
    self.navigationItem.rightBarButtonItem = infoBTN;
    
    UIBarButtonItem *backBTN = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"向左箭头头"] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backBTN;
    
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.view.backgroundColor = [UIColor colorWithWhite:0.951 alpha:1.000];
    
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.mapView.rotateEnabled = NO;
    self.mapView.showsCompass = NO;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    
    self.bigBTN = [WDButton buttonWithType:UIButtonTypeCustom];
    self.bigBTN.frame = CGRectMake(10, kScreenHeight-64-50-17, kScreenWidth-20, 50);
    self.bigBTN.layer.cornerRadius = 8;
    [self.bigBTN setTitle:@"开启范围监听" forState:UIControlStateNormal];
    [self.bigBTN setTitle:@"关闭范围监听" forState:UIControlStateSelected];
    [self.bigBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bigBTN setTitleColor:kThemeColor forState:UIControlStateSelected];
    self.bigBTN.backgroundColor = kThemeColor;
    self.bigBTN.HilitedColor = kHilitedOrange;
    kSetLayerShadow(self.bigBTN, 0, 2, 0.1, 2, kThemeColor);
    kBTNsetAction(self.bigBTN, touchedStartTracing);
    [self.view addSubview:self.bigBTN];
    
    self.centerBTN = [WDButton buttonWithType:UIButtonTypeCustom];
    [self.centerBTN setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    self.centerBTN.frame = CGRectMake(kScreenWidth-10-35, 10, 35, 35);
    self.centerBTN.backgroundColor = [UIColor whiteColor];
    self.centerBTN.HilitedColor = kHilitedGray;
    self.centerBTN.layer.cornerRadius = 2;
    self.centerBTN.hidden = YES;
    kSetLayerShadow(self.centerBTN, 0, 1, 0.1, 2, kThemeColor);
    kBTNsetAction(self.centerBTN, movetoCenter);
    [self.view addSubview:self.centerBTN];
    
    self.listView = [[DEMOListView alloc]initWithFrame:CGRectMake(10, kViewY(self.bigBTN)-50-5, kViewWidth(self.bigBTN), 50)];
    self.listView.delegate = self;
    self.listView.hidden = YES;
    [self.view addSubview:self.listView];
    
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

#pragma  mark -- DEMOListViewDelegate
/**
 *  从界面上的列表view里面选中了一个设备
 *
 *  @param device 选中的设备key
 */
-(void)demoListViewChoosedDevice:(NSString *)device{
    
    //根据key取定位点
    MAAnimatedAnnotation *pointAnnotation = [self.annotationMap objectForKey:device];
    //记录
    self.ChoosedpointAnnotation = pointAnnotation;
    //通过重设定位点，达到改变选中的点的颜色的效果
    if(self.annotationMap.allValues.count>0){
        [self.mapView removeAnnotations:self.annotationMap.allValues];
        [self.mapView addAnnotations:self.annotationMap.allValues];
    }
    //把选中的点，设成地图的中心点
    [self.mapView setCenterCoordinate:pointAnnotation.coordinate
                                 animated:YES];
}

#pragma  mark -- MAMapViewDelegate

//高德地图的显示的相关代理设置
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        NSLog(@"%f,%f,%f,%f",annotation.coordinate.latitude,
                             annotation.coordinate.longitude,
                             self.selfLocation.latitude,
                             self.selfLocation.longitude);
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        if(annotation.coordinate.latitude == self.selfLocation.latitude &&
           annotation.coordinate.longitude == self.selfLocation.longitude){
            //自己
            annotationView.image = [UIImage imageNamed:@"点位"];
            NSLog(@"自己");
        }else if(annotation.coordinate.latitude == self.ChoosedpointAnnotation.coordinate.latitude &&
                 annotation.coordinate.longitude == self.ChoosedpointAnnotation.coordinate.longitude){
            //选中的人
            annotationView.image = [UIImage imageNamed:@"设备2"];
        }else{
            //其他人
            annotationView.image = [UIImage imageNamed:@"设备1"];
        }
        
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:0.000 green:0.627 blue:0.914 alpha:1.000];
        circleRenderer.fillColor    = [UIColor colorWithRed:0.000 green:0.627 blue:0.914 alpha:0.100];
        return circleRenderer;
    }
    return nil;
}
@end
