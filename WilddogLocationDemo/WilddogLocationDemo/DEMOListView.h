//
//  DEMOListView.h
//  WilddogLocationDemo
//
//  Created by problemchild on 2017/7/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

/**
 *  界面上用来显示设备列表的View
 */
#import <UIKit/UIKit.h>

@protocol DEMOListViewDelegate <NSObject>

-(void)demoListViewChoosedDevice:(NSString *)device;

@end

@interface DEMOListView : UIView

@property(nonatomic,weak) id <DEMOListViewDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *deviceArr;

-(void)fresh;

-(void)selectDev:(NSString *)dev;

@end
