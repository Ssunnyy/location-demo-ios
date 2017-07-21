//
//  WDGPathQuery.h
//  WilddogLocation
//
//  Created by Zheng Li on 22/05/2017.
//  Copyright © 2017 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef long long WilddogHandle;

@class WDGPathSnapshot;

NS_ASSUME_NONNULL_BEGIN

/**
 代表一个特定的轨迹查询条件。当一个 `WDGPathQuery` 实例销毁时，其建立的监听将自动取消。
 */
@interface WDGPathQuery : NSObject

/**
 要查询的 key。
 */
@property (nonatomic, strong, readonly) NSString *key;

/**
 查询时间段的开始时间。
 */
@property (nonatomic, strong, readonly) NSDate *startTime;

/**
 查询时间段的结束时间。如果设置为`nil`，结束时间为未来无限远。
 */
@property (nonatomic, strong, readonly, nullable) NSDate *endTime;

/**
 对当前查询进行持续监听。

 @param block 查询操作的回调。
 @return `WilddogHandle`实例，代表当前监听的编号，可用于稍后取消监听。
 */
- (WilddogHandle)observeWithBlock:(void (^)(WDGPathSnapshot *snapshot))block;

/**
 对当前查询进行单次监听。

 @param block 查询操作的回调。
 */
- (void)observeSingleEventWithBlock:(void (^)(WDGPathSnapshot *snapshot))block;

/**
 取消当前查询上的指定监听。

 @param handle 要取消的监听的编号。
 */
- (void)removeObserverWithHandle:(WilddogHandle)handle;

/**
 取消当前查询上的所有监听。
 */
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
