//
//  SKFDanmuModelProtocol.h
//  DanmuTool
//
//  Created by 孙凯峰 on 2017/4/13.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SKFDanmuModelDelegate <NSObject>
/** 弹幕标题, 可以提供富文本 */
@property (nonatomic, readonly) NSMutableAttributedString *attributeContent;
/** 弹幕开始弹出时间点 */

@property(nonatomic,assign,readonly) NSTimeInterval beginTime  ;
/** 弹幕存活时间(动画时间) */

@property (nonatomic, assign, readonly) NSTimeInterval liveTime;



@end
