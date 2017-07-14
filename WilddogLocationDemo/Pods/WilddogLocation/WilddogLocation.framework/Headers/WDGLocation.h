#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef long long WilddogHandle;

@class WDGAMapLocationProvider;
@class WDGQuery;
@class WDGCircleQuery;
@class WDGPathQuery;
@class WDGPosition;
@class WDGPathSnapshot;
@class WDGFence;
@class WDGApp;
@class WDGSyncReference;
@protocol WDGLocationDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^WDGLocationCompletionBlock) (NSError *_Nullable error);

typedef void (^WDGLocationCallbackBlock) (WDGPosition *_Nullable position, NSError *_Nullable error);

#pragma mark -

/**
 使用 `WDGLocation` 实例对 Sync 进行读写地理位置数据和查询。
 */
@interface WDGLocation : NSObject

/**
 `WDGSyncReference`实例，`WDGLocation`的数据读写将在这个实例所表示的路径下进行。
 */
@property (nonatomic, strong, readonly) WDGSyncReference *syncReference;

/**
 遵守`WDGLocationDelegate`协议的代理。
 */
@property (nonatomic, weak, nullable) id<WDGLocationDelegate> delegate;

/**
 回调和代理执行的队列。
 */
@property (nonatomic, strong) dispatch_queue_t callbackQueue;

/**
 控制当前设备是否开启地理围栏检测。默认关闭。
 */
@property (nonatomic, assign) BOOL enableGeoFence;

/**
 当前应用的地理围栏的标签。默认为 `@[@"default"]`。
 */
@property (nonatomic, strong) NSArray<NSString *> *observingFenceTags;


#pragma mark - 初始化

/**
 通过Wilddog的AppID来初始化 `WDGLocation` 实例。

 @param appID 在Wilddog控制台申请的AppID
 @return 初始化成功的 `WDGLocation` 实例
 */
- (instancetype)initWithWilddogAppID:(NSString *)appID;

/**
 通过一个 `WDGSyncReference` 实例进行初始化。

 @param syncReference 一个 `WDGSyncReference` 实例，后续的数据读写都在这个实例所在的路径下进行。
 @return 初始化成功的 `WDGLocation` 实例。
 */
- (instancetype)initWithSyncReference:(WDGSyncReference *)syncReference;

#pragma mark - 位置同步

/**
 开启自动位置同步，SDK 自动将 locationProvider 提供的位置数据上传到 key 名下，使用默认的LocationProvider。
 
 @param key 位置数据将上传到这个 key 名下。
 */
- (void)startTracingPositionForKey:(NSString *)key;

/**
 开启自动位置同步，SDK 自动将 locationProvider 提供的位置数据上传到 key 名下，使用默认的LocationProvider。

 @param key 位置数据将上传到这个 key 名下。
 @param block 完成后执行的回调。
 */
- (void)startTracingPositionForKey:(NSString *)key withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;

/**
 开启自动位置同步，SDK 自动将 locationProvider 提供的位置数据上传到 key 名下。

 @param key 位置数据将上传到这个 key 名下。
 @param locationProvider 位置数据的提供者。
 */
- (void)startTracingPositionForKey:(NSString *)key withLocationProvider:(WDGAMapLocationProvider *)locationProvider;

/**
 开启自动位置同步，SDK 自动将 locationProvider 提供的位置数据上传到 key 名下。

 @param key 位置数据将上传到这个 key 名下。
 @param locationProvider 位置数据的提供者。
 @param block 完成后执行的回调。
 */
- (void)startTracingPositionForKey:(NSString *)key withLocationProvider:(WDGAMapLocationProvider *)locationProvider withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;

/**
 终止针对 key 的自动位置同步。

 @param key 要终止自动位置同步的 key。
 */
- (void)stopTracingPositionForKey:(NSString *)key;

/**
 终止针对 key 的自动位置同步。

 @param key 要终止自动位置同步的 key。
 @param block 完成后执行的回调。
 */
- (void)stopTracingPositionForKey:(NSString *)key withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;


/**
 手动将位置数据写入。

 @param position 要写入的位置数据。
 @param key 位置数据将写入 key 名下。
 */
- (void)setPosition:(WDGPosition *)position forKey:(NSString *)key;

/**
 手动将位置数据写入。

 @param position 要写入的位置数据。
 @param key 位置数据将写入 key 名下。
 @param block 写入操作的回调函数。
 */
- (void)setPosition:(WDGPosition *)position forKey:(NSString *)key withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;


/**
 获取某个 key 最新位置。

 @param key 要获取其位置的 key。
 @param block 包含位置信息或错误信息的回调函数。
 */
- (void)getPositionForKey:(NSString *)key withBlock:(WDGLocationCallbackBlock)block;

/**
 持续监听指定 key 的位置。

 @param key 要获取其位置的 key。
 @param block 包含位置信息的回调函数。
 @return 代表当前监听的编号，可用于稍后取消监听。
 */
- (WilddogHandle)observePositionForKey:(NSString *)key withBlock:(WDGLocationCallbackBlock)block;

/**
 取消指定的位置监听。

 @param handle 要取消的监听的编号。
 */
- (void)removeObserverWithHandle:(WilddogHandle)handle;

/**
 取消对指定key的位置监听。

 @param key 要取消监听的key。
 */
- (void)removeAllObserversForKey:(NSString *)key;

/**
 取消所有位置监听。
 */
- (void)removeAllObservers;

/**
 移除指定key下的位置数据。

 @param key 需要移除的节点。
 */
- (void)removePositionForKey:(NSString *)key;

/**
 移除指定key下的位置数据。

 @param key 需要移除的节点。
 @param block 删除操作的回调函数。
 */
- (void)removePositionForKey:(NSString *)key withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;


#pragma mark - 范围监听

/**
 初始化一个用于范围查询的 `WDGCircleQuery` 实例。

 @param position 范围查询的圆心。
 @param radius 范围查询的半径。
 @return `WDGCircleQuery` 实例。
 */
- (WDGCircleQuery *)circleQueryAtPosition:(WDGPosition *)position withRadius:(double)radius;


#pragma mark - 实时轨迹

/**
 开始记录 key 的轨迹。开启成功后每次 key 的位置同步数据更新时，都将存一份副本到实时轨迹数据库中。使用默认的位置提供者。

 @param key 要记录轨迹的 key。
 */
- (void)startRecordingPathForKey:(NSString *)key;

/**
 开始记录 key 的轨迹。开启成功后每次 key 的位置同步数据更新时，都将存一份副本到实时轨迹数据库中。使用默认的位置提供者。

 @param key 要记录轨迹的 key。
 @param block 完成后执行的回调。
 */
- (void)startRecordingPathForKey:(NSString *)key withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;

/**
 开始记录 key 的轨迹。开启成功后每次 key 的位置同步数据更新时，都将存一份副本到实时轨迹数据库中。
 
 @param key 要记录轨迹的 key。
 @param locationProvider 位置数据的提供者。
 */
- (void)startRecordingPathForKey:(NSString *)key withLocationProvider:(WDGAMapLocationProvider *)locationProvider;

/**
 开始记录 key 的轨迹。开启成功后每次 key 的位置同步数据更新时，都将存一份副本到实时轨迹数据库中。

 @param key 要记录轨迹的 key。
 @param locationProvider 位置数据的提供者。
 @param block 完成后执行的回调。
 */
- (void)startRecordingPathForKey:(NSString *)key withLocationProvider:(WDGAMapLocationProvider *)locationProvider withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;

/**
 终止 key 的轨迹记录。

 @param key 要终止记录轨迹的 key。
 */
- (void)stopRecordingPathForKey:(NSString *)key;

/**
 终止 key 的轨迹记录。

 @param key 要终止记录轨迹的 key。
 @param block 完成后执行的回调。
 */
- (void)stopRecordingPathForKey:(NSString *)key withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;

/**
 初始化一个用于实时轨迹查询的 `WDGPathQuery` 实例。

 @param key 要查询的 key。
 @param startTime 要查询的时间段的开始时间。
 @param endTime 要查询的时间段的结束时间。
 @return `WDGPathQuery` 实例。
 */
- (WDGPathQuery *)pathQueryForKey:(NSString *)key startTime:(NSDate *)startTime endTime:(NSDate *_Nullable)endTime;

/**
 初始化一个用于实时轨迹查询的 `WDGPathQuery` 实例，不需要开始、结束时间，查询一个key的全部记录。

 @param key 要查询的 key。
 @return `WDGPathQuery` 实例。
 */
- (WDGPathQuery *)pathQueryForKey:(NSString *)key;

/**
 初始化一个用于实时轨迹查询的 `WDGPathQuery` 实例。不设置结束时间，如果选择持续监听，将持续更新。
 
 @param key 要查询的 key。
 @param startTime 要查询的时间段的开始时间。
 @return `WDGPathQuery` 实例。
 */
- (WDGPathQuery *)pathQueryForKey:(NSString *)key startTime:(NSDate *)startTime;

/**
 初始化一个用于实时轨迹查询的 `WDGPathQuery` 实例。默认从最早的轨迹记录开始查询。
 
 @param key 要查询的 key。
 @param endTime 要查询的时间段的结束时间。
 @return `WDGPathQuery` 实例。
 */
- (WDGPathQuery *)pathQueryForKey:(NSString *)key endTime:(NSDate *)endTime;


/**
 * 移除指定key下的轨迹记录。
 *
 * @param key 需要移除的节点。
 */
- (void)removePathForKey:(NSString *)key;


/**
 * 移除指定key下的轨迹记录
 *
 * @param key 需要移除的节点。
 * @param block 删除操作的回调函数。
 */
- (void)removePathForKey:(NSString *)key withCompletionBlock:(WDGLocationCompletionBlock _Nullable)block;


#pragma mark - 地理围栏

/**
 将一个地理围栏实例上传到云端，供所有设备应用。

 @param fence 要设置的
 @param block 上传操作的回调方法。
 */
- (void)uploadFence:(WDGFence *)fence withBlock:(void (^)(NSError *_Nullable error))block;

/**
 将一个具有特定名称的地理围栏从云端移除。

 @param fenceName 要移除的地理围栏的名称。
 @param block 移除操作的回调方法。
 */
- (void)removeFenceWithName:(NSString *)fenceName withBlock:(void (^)(NSError *_Nullable error))block;

#pragma mark - 计算两个坐标之间的距离

/**
 用于计算两个位置点的距离的辅助函数。

 @param position1 第一个位置点。
 @param position2 第二个位置点。
 @return 以米为单位的距离。
 */
+ (double)distanceBetweenPosition:(WDGPosition *)position1 andPosition:(WDGPosition *)position2;

@end


#pragma mark - WDGLocation代理

/**
 `WDGLocation` 的代理方法。
 */
@protocol WDGLocationDelegate <NSObject>

@optional

/**
 当 SDK 即将更新位置同步和实时轨迹的数据时，可以通过这个代理方法对上传到云端的位置信息进行替换。
 
 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param key 位置同步和实时轨迹数据将写在这个 key 名下。
 @param position 原始位置数据。
 @return 实际上传的位置数据。
 */
- (WDGPosition *_Nullable)wilddogLocation:(WDGLocation *)wilddogLocation willUpdatePosition:(WDGPosition *)position ForKey:(NSString *)key;

/**
 当针对指定 key 的位置同步开始后通过这个代理方法进行通知。

 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param key 位置数据将写在这个 key 名下。
 */
- (void)wilddogLocation:(WDGLocation *)wilddogLocation didStartedTracingPositionForKey:(NSString *)key;

/**
 当针对指定 key 的位置同步终止后通过这个代理方法进行通知。

 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param key 位置数据将写在这个 key 名下。
 */
- (void)wilddogLocation:(WDGLocation *)wilddogLocation didStoppedTracingPositionForKey:(NSString *)key;

/**
 当针对指定 key 的位置同步未能正常开启时通过这个代理方法进行通知。
 
 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param key 位置数据将写在这个 key 名下。
 @param error 错误信息。
 */
- (void)wilddogLocation:(WDGLocation *)wilddogLocation didFailedTracingPositionForKey:(NSString *)key withError:(NSError *)error;

/**
 当针对指定 key 的轨迹记录开始后通过这个代理方法进行通知。

 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param key 位置数据将写在这个 key 名下。
 */
- (void)wilddogLocation:(WDGLocation *)wilddogLocation didStartedRecordingPathForKey:(NSString *)key;

/**
 当针对指定 key 的轨迹记录终止后通过这个代理方法进行通知。

 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param key 位置数据将写在这个 key 名下。
 */
- (void)wilddogLocation:(WDGLocation *)wilddogLocation didStoppedRecordingPathForKey:(NSString *)key;

/**
 当当前设备进入某个地理围栏时通过这个代理方法进行通知。

 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param fence 进入的地理围栏。
 */
- (void)wilddogLocation:(WDGLocation *)wilddogLocation didEnteredGeoFence:(WDGFence *)fence;

/**
 当当前设备离开某个地理围栏时通过这个代理方法进行通知。

 @param wilddogLocation 调用这个代理方法的 `WDGLocation` 实例。
 @param fence 离开的地理围栏。
 */
- (void)wilddogLocation:(WDGLocation *)wilddogLocation didLeavedGeoFence:(WDGFence *)fence;

@end

NS_ASSUME_NONNULL_END
