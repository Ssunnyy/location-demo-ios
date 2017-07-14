//
//  SDKManager.h
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKManager : NSObject

+(SDKManager *)defaultManager;

@property(nonatomic,strong)WDGLocation *locationService;

-(BOOL)PrivacyOK;

@property(nonatomic,strong)NSString *uuid;

@property BOOL tracingstarted;

@property BOOL tracingPathStarted;

@property BOOL circleQueryTracingStarted;

@property(nonatomic,strong)NSDate *appstartDate;

- (void)clear;

@end
