//
//  WDGCircleFence.h
//  WilddogLocation
//
//  Created by Zheng Li on 25/05/2017.
//  Copyright © 2017 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "WDGFence.h"

NS_ASSUME_NONNULL_BEGIN

/**
 代表一个圆形的地理围栏。
 */
@interface WDGCircleFence : WDGFence

/**
 圆心座标。
 */
@property (nonatomic, strong) CLLocation *center;

/**
 半径。以米为单位。
 */
@property (nonatomic, assign) double radius;

/**
 创建一个圆形的地理围栏实例。标签默认为 `default`。

 @param name 地理围栏的名字。每个地理围栏都要有唯一的名字。
 @param center 圆心座标。
 @param radius 半径。以米为单位。
 @return 创建的地理围栏实例。
 */
- (instancetype)initWithName:(NSString *)name center:(CLLocation *)center radius:(double)radius;
/**
 创建一个含有指定标签的圆形的地理围栏实例。

 @param name 地理围栏的名字。每个地理围栏都要有唯一的名字。
 @param tags 这个地理围栏的标签。
 @param center 圆心座标。
 @param radius 半径。
 @return 创建的地理围栏实例。
 */
- (instancetype)initWithName:(NSString *)name center:(CLLocation *)center radius:(double)radius tags:(NSArray<NSString *> *)tags;

@end

NS_ASSUME_NONNULL_END
