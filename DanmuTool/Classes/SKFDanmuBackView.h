//
//  SKFDanmuBackView.h
//  DanmuTool
//
//  Created by 孙凯峰 on 2017/4/13.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//
/**
 弹幕承载视图, 用来控制弹幕弹出, 与弹幕动画
 */
#import <UIKit/UIKit.h>
#import "SKFDanmuModelProtocol.h"

@protocol SKFDanmuBackViewDelegate <NSObject>
/**
 当前时间
 */
@property(nonatomic,assign,readonly)NSTimeInterval currentTime;
/**
 根据model 获取相应的弹幕视图(由外界来控制)
 
 @param model 弹幕模型
 
 @return 弹幕视图
 */
-(UIView *)danmuViewWithModel:(id<SKFDanmuModelDelegate>)model;

- (void)danmuBackViewDidSelectDanmu: (UIView *)danmuView atPoint: (CGPoint)point;


@end
@interface SKFDanmuBackView : UIView
@property(nonatomic,weak) id<SKFDanmuBackViewDelegate>delegate;

/**
 弹幕模型数组, 只要外界向这个数组追加数据, 控件内部就会根据时间自动的弹出该弹幕
 */
@property (nonatomic, strong) NSMutableArray <id<SKFDanmuModelDelegate>>*danmuMs;
-(void)pause;

-(void)resume;
@end
