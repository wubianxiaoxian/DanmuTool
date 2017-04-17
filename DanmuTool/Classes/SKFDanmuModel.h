//
//  SKFDanmuModel.h
//  DanmuTool
//
//  Created by 孙凯峰 on 2017/4/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKFDanmuModelProtocol.h"
@interface SKFDanmuModel : NSObject<SKFDanmuModelDelegate>
/** 开始时间 */

@property (nonatomic, assign) NSTimeInterval beginTime;
/** 存活时间 */

@property (nonatomic, assign) NSTimeInterval liveTime;

/** 弹幕内容, 可展示富文本 */
@property (nonatomic, strong) NSMutableAttributedString *attributeContent;
@end
