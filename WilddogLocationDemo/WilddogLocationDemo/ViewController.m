//
//  ViewController.m
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "ViewController.h"

#import "ChooseFunctionViewController.h"

#import "Reachability.h"

@interface ViewController ()

@property (nonatomic,strong) UITextField *field;

@property (nonatomic,strong) WDButton    *okBTN;

@property(nonatomic,strong)NSTimer *waitToCHeckAppID;

@property BOOL checked;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //配置界面
    [self setUpUI];
}


/**
 *  点击了OK按钮
 */
-(void)touchedOKBTN{
    
    self.field.text = [self.field.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(![self isExistenceNetwork]){
        
        [self alertNetWorkWrong];
        self.okBTN.enabled = YES;
        
    }else{
        if(self.okBTN.enabled &&
           self.field.text.length>0)
        {
            self.okBTN.enabled = NO;//防止重复点击
            [self waitCheckAPPID];//防止超时
            
            // 初始化Wilddog Sync
            WDGOptions *option = [[WDGOptions alloc] initWithSyncURL:[NSString stringWithFormat:@"https://%@.wilddogio.com",self.field.text]];
            //        WDGOptions *option = [[WDGOptions alloc] initWithSyncURL:@"https://location-demo.wilddogio.com"];
            [WDGApp configureWithOptions:option];
            
            WDGSyncReference *ref = [[WDGSync sync] reference];
            
            // 使用Sync Reference初始化Wilddog Location
            WDGLocation *locationService = [[WDGLocation alloc] initWithSyncReference:ref];
            
            //SDKManager是本demo中自定义的一个类，用来全局管理、调用SDK的功能
            [SDKManager defaultManager].locationService = locationService;
            
            //使用sync保存一条测试数据监测appid是否可用
            [[[[[WDGSync sync]reference]child:@"WilddogLocation"]child:@"DemoConnectInfo"]setValue:@"ok" withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
                self.okBTN.enabled = YES;
                if(error){
                    [self.waitToCHeckAppID invalidate];
                    
                    //appid不可用，出现了一些问题
                    if([error.localizedDescription isEqualToString:@"failure : The server indicated that this operation failed"]){
                        [self alertAppIDWrong];
                    }else if([error.localizedDescription isEqualToString:@"permission_denied : This client does not have permission to perform this operation"]){
                        [self alertPermissionWrong];
                    }else{
                        [self alertFail];
                    }
                    
                }else{
                    [self.waitToCHeckAppID invalidate];
                    self.checked = YES;
                    //appid可用，跳转到下一页
                    ChooseFunctionViewController *nextVC = [ChooseFunctionViewController new];
                    nextVC.apppid = self.field.text;
                    [self.navigationController pushViewController:nextVC animated:YES];
                    
                }
            }];
        }
    }
}


//--------------------------------------------------

/**
 *  界面配置
 */
- (void)setUpUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    
    UIImageView *LOGO = [[UIImageView alloc]initWithFrame:CGRectMake(kViewWidth(self.view)/2-75/2,
                                                                     (74+40)/2,
                                                                     75,75)];
    LOGO.contentMode = UIViewContentModeScaleAspectFit;
    LOGO.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:LOGO];
    
    UILabel *titleA = [[UILabel alloc]initWithFrame:CGRectMake(0,kViewMaxY(LOGO)+22,
                                                               kViewWidth(self.view),
                                                               24)];
    titleA.font = [UIFont systemFontOfSize:24];
    titleA.textAlignment = NSTextAlignmentCenter;
    titleA.numberOfLines = 0;
    titleA.text = @"野狗通信云";
    titleA.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    [self.view addSubview:titleA];
    
    UILabel *titleB = [[UILabel alloc]initWithFrame:CGRectMake(0,kViewMaxY(titleA)+10,
                                                               kViewWidth(self.view),
                                                               15)];
    titleB.font = [UIFont systemFontOfSize:15];
    titleB.textAlignment = NSTextAlignmentCenter;
    titleB.numberOfLines = 0;
    titleB.text = @"实时定位示例程序";
    titleB.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    [self.view addSubview:titleB];
    
    self.field = [[UITextField alloc]initWithFrame:CGRectMake(kViewWidth(self.view)/2-139,
                                                             kViewMaxY(titleB)+82,
                                                              278, 15)];
    self.field.font = [UIFont systemFontOfSize:15];
    self.field.textAlignment = NSTextAlignmentCenter;
    self.field.borderStyle = UITextBorderStyleNone;
    self.field.placeholder = @"请输入野狗应用的AppID";
    [self.view addSubview:self.field];
    
    UIImageView *Line = [[UIImageView alloc]initWithFrame:CGRectMake(kViewX(self.field),
                                                                     kViewMaxY(self.field)+10,
                                                                     kViewWidth(self.field),
                                                                     1)];
    Line.contentMode = UIViewContentModeScaleAspectFit;
    Line.image = [UIImage imageNamed:@"填写或粘贴用户ID"];
    [self.view addSubview:Line];
    
    self.okBTN = [WDButton buttonWithType:UIButtonTypeCustom];
    self.okBTN.backgroundColor = kThemeColor;
    self.okBTN.HilitedColor = kHilitedOrange;
    [self.okBTN setTitle:@"确认" forState:UIControlStateNormal];
    [self.okBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.okBTN.titleLabel.font = [UIFont systemFontOfSize:14];
    self.okBTN.frame = CGRectMake(kViewWidth(self.view)/2-120, kViewMaxY(Line)+15, 240, 41);
    self.okBTN.layer.cornerRadius = 20;
    [self.okBTN addTarget:self action:@selector(touchedOKBTN) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okBTN];
    
    UIButton *appIdHelpBTN  = [UIButton buttonWithType:UIButtonTypeCustom];
    appIdHelpBTN.frame = CGRectMake(0, kViewMaxY(self.okBTN)+10, kScreenWidth, 13);
    [appIdHelpBTN setTitle:@"AppID ?" forState:UIControlStateNormal];
    [appIdHelpBTN setTitleColor:kThemeColor forState:UIControlStateNormal];
    [appIdHelpBTN addTarget:self action:@selector(touchedAppIdHelp) forControlEvents:UIControlEventTouchUpInside];
    appIdHelpBTN.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:appIdHelpBTN];
    
}

- (void)touchedAppIdHelp{
    self.okBTN.enabled = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AppID"
                                                                             message:@"AppID 是野狗应用的唯一标识\n请前往野狗控制面板获取"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.field resignFirstResponder];
}

- (void)alertAppIDWrong{
    self.okBTN.enabled = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AppID不存在"
                                                                             message:@"该AppID不存在\n请输入正确的AppID"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertPermissionWrong{
    self.okBTN.enabled = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有访问权限"
                                                                             message:@"你没有该App的访问权限\n请修改规则表达式或者更换AppID"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertNetWorkWrong{
    self.okBTN.enabled = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有网络权限"
                                                                             message:@"当前DEMO处于断网状态"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch([reachability currentReachabilityStatus]){
        case NotReachable: isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN: isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi: isExistenceNetwork = TRUE;
            break;
    }
    return isExistenceNetwork;
}

-(void)waitCheckAPPID{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(!self.checked){
            [self alertFail];
        }
    });
}

-(void)alertFail{
    self.okBTN.enabled = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"连接失败"
                                                                             message:@"你的AppID可能不正确"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好的"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
