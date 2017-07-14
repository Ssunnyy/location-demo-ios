//
//  WDGPosition.h
//  WilddogLocation
//
//  Created by Zheng Li on 12/05/2017.
//  Copyright © 2017 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 代表一个位置信息。
 */
@interface WDGPosition : NSObject

/**
 纬度。
 */
@property (nonatomic, assign, readonly) double latitude;

/**
 经度。
 */
@property (nonatomic, assign, readonly) double longitude;

/**
 位置信息在设备上创建时的时间戳。
 */
@property (nonatomic, strong, readonly) NSDate *timestamp;

/**
 可自定义添加的属性字典，将随同位置信息一起上传。
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary *customAttributes;

/**
 通过直接指定纬度和经度坐标初始化 `WDGPosition` 实例。时间戳会自动根据设备当前时间生成。

 @param latitude 纬度坐标。
 @param longitude 经度坐标。
 @return `WDGPosition` 实例。
 */
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;

/**
 通过直接指定纬度、经度和时间戳初始化 `WDGPosition` 实例。

 @param latitude 纬度坐标。
 @param longitude 经度坐标。
 @param timestamp 指定的时间戳。
 @return `WDGPosition` 实例。
 */
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude timestamp:(NSDate *)timestamp;

/**
 通过直接指定纬度、经度、时间戳和自定义属性字典初始化 `WDGPosition` 实例。

 @param latitude 纬度坐标。
 @param longitude 经度坐标。
 @param timestamp 指定的时间戳。
 @param customAttributes 随同位置信息一起上传的自定义属性字典。
 @return `WDGPosition` 实例。
 */
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude timestamp:(NSDate *)timestamp customAttributes:(NSDictionary *_Nullable)customAttributes;

/**
 通过位置信息初始化 `WDGPosition` 实例。

 @param location 位置信息。
 @return `WDGPosition` 实例。
 */
- (instancetype)initWithCLLocation:(CLLocation *)location;

/**
 指定初始化方法
 通过位置信息和自定义属性段初始化 `WDGPosition` 实例。

 @param location 位置信息。
 @param customAttributes 自定义属性段。 
 @return `WDGPosition` 实例。
 */
- (instancetype)initWithCLLocation:(CLLocation *)location customAttributes:(NSDictionary *_Nullable)customAttributes;


- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
