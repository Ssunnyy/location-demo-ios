#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class WDGLocation;
@class WDGPosition;

typedef long long WilddogHandle;

typedef NS_ENUM(NSUInteger, WDGQueryEventType) {
    WDGQueryEventTypeEntered,
    WDGQueryEventTypeExited,
    WDGQueryEventTypeMoved
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^WDGQueryResultBlock) (NSString *key, WDGPosition *location);
typedef void (^WDGQueryReadyBlock) ();

/**
 一个查找符合查询条件的数据集合的查询。这是一个抽象类，不能直接创建。请使用 `WDGCircleQuery`。
 */
@interface WDGQuery : NSObject

/**
 创建这个监听的 `WDGLocation` 实例。
 */
@property (nonatomic, strong, readonly) WDGLocation *wilddogLocation;

/**
 监听特定的事件。事件种类包括：进入(WDGQueryEventTypeEntered)、离开(WDGQueryEventTypeExited)、移动(WDGQueryEventTypeMoved)。

 @param eventType 监听的类型
 @param block 监听的回调，回调中包含 key 和这个 key 最新的位置信息。
 @return 这个监听的编号。
 */
- (WilddogHandle)observeEventType:(WDGQueryEventType)eventType withBlock:(WDGQueryResultBlock)block;

/**
 创建一个监听，当所有初始数据都加载完成后会调用。每当监听的参数变化后，需要重新加载初始数据，当重新加载完成后这个监听也会被调用一次。

 @param block 回调方法，可以在其中更新 UI 界面。
 @return 监听的编号。
 */
- (WilddogHandle)observeReadyWithBlock:(WDGQueryReadyBlock)block;

/**
 取消特定的监听。

 @param handle 要取消的监听的编号。
 */
- (void)removeObserverWithHandle:(WilddogHandle)handle;

/**
 取消当前实例创建的全部监听。
 */
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
