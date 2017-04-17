//
//  SKFDanmuView.h
//  DanmuTool
//
//  Created by 孙凯峰 on 2017/4/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//
#import "SKFDanmuModelProtocol.h"
#import <UIKit/UIKit.h>
typedef void(^LoadImageBlock)(UIImageView *imageView, NSURL *url);

@interface SKFDanmuView : UIView

+ (instancetype)danmuViewWithDanmuM:(id<SKFDanmuModelDelegate>)danmuM;

@property (nonatomic, strong) id<SKFDanmuModelDelegate> danmuM;

/**
 *  用于加载图片的代码块, 必须赋值
 */
//@property (nonatomic, copy) LoadImageBlock loadBlock;

// 在某个位置显示星星
- (void)showStars:(CGPoint)point;
@end
