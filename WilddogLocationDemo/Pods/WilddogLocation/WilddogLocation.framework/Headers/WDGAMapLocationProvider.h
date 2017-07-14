//
//  WDGAMapLocationProvider.h
//  WilddogLocation
//
//  Created by Hayden on 2017/6/1.
//  Copyright © 2017年 Wilddog. All rights reserved.
//

@class WDGPosition;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WDGLocationSampleType) {
    WDGLocationSampleTypeTime,
    WDGLocationSampleTypeDistance
};


/**
 对高德定位 SDK 进行封装，使其可以作为位置信息的数据源。
 */
@interface WDGAMapLocationProvider : NSObject

/**
 采样的方式，基于时间间隔采样或者基于移动距离采样。
 */
@property (nonatomic, assign, readonly) WDGLocationSampleType sampleType;

/**
 若当前采样方式为时间间隔，通过这个属性控制时间间隔的大小。单位为秒，范围为 1 到 300 秒。
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;

/**
 若当前采样方式为距离，通过这个属性控制距离的大小。单位为米，范围为 0 到 500 米。
 */
@property (nonatomic, assign, readonly) double distanceInterval;

/**
 从这个位置数据源获得当前位置。
 */
@property (nonatomic, strong, readonly, nullable) WDGPosition *currentPosition;


/**
 采用默认的采样方式，按时间间隔采样，间隔为5s。

 @return `WDGAMapLocationProvider` 实例。
 */
+ (instancetype)defaultLocationProvider;

/**
 将采样方式设置为基于时间间隔采样并设置间隔时间。
 
 @param timeInterval 采样的间隔时间。单位为秒，范围为 1 到 300 秒。
 @return `WDGAMapLocationProvider` 实例。
 */
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 将采样方式设置为基于移动距离采样并设置两次采样之间的最小距离。
 
 @param distanceInterval 两次采样之间的最小距离。单位为米，范围为 0 到 500 米。
 @return `WDGAMapLocationProvider` 实例。
 */
- (instancetype)initWithDistanceInterval:(double)distanceInterval;

@end


NS_ASSUME_NONNULL_END
