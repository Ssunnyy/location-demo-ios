//
//  WDGPathSnapshot.h
//  WilddogLocation
//
//  Created by Zheng Li on 22/05/2017.
//  Copyright © 2017 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGPosition;

NS_ASSUME_NONNULL_BEGIN

/**
 代表一次轨迹查询的结果。
 */
@interface WDGPathSnapshot : NSObject

/**
 一个数组，包含轨迹中所有的`WDGPosition`对象。
 */
@property (nonatomic, strong, readonly) NSArray<WDGPosition *> *points;

/**
 轨迹的总长度，以米为单位。
 */
@property (nonatomic, assign, readonly) double length;

/**
 当前轨迹中最新的一个点。
 */
@property (nonatomic, strong, readonly) WDGPosition *latestPoint;

@end

NS_ASSUME_NONNULL_END
