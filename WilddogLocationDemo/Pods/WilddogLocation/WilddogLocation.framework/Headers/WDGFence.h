//
//  WDGFence.h
//  WilddogLocation
//
//  Created by Zheng Li on 25/05/2017.
//  Copyright © 2017 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 代表一个地理围栏，这是一个抽象类不能直接创建。请使用 `WDGCircleFence`。
 */
@interface WDGFence : NSObject

/**
 每个地理围栏都要有唯一的名字。
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 每个地理围栏可以应用一个或多个标签。客户端通过标签来筛选想要监听的地理围栏。
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *tags;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
