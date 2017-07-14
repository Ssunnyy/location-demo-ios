#import <Foundation/Foundation.h>

@class WDGQuery;

NS_ASSUME_NONNULL_BEGIN

/**
 `WDGQuery` 的子类，用于设置范围监听的查询条件。
 */
@interface WDGCircleQuery : WDGQuery

/**
 查询区域的中心。修改这个值将更新这个查询。
 */
@property (atomic, readwrite) CLLocation *center;

/**
 查询区域的半径，以千米为单位。修改这个值将更新这个查询。
 */
@property (atomic, readwrite) double radius;

@end

NS_ASSUME_NONNULL_END
