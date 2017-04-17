//
//  CALayer+Aimate.m
//  DanmuTool
//
//  Created by 孙凯峰 on 2017/4/13.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

#import "CALayer+Aimate.h"

@implementation CALayer (Aimate)
-(void)pauseAnimate{
    
    CFTimeInterval pausedTime=[self convertTime:CACurrentMediaTime() fromLayer:nil];
    
    self.speed=0.0;
    
    self.timeOffset=pausedTime;
    
    
}
-(void)resumeAnimate{
    
    CFTimeInterval pausedTime=[self timeOffset];
    
    self.speed=1.0;
    
    self.timeOffset=0.0;
    
    self.beginTime=0.0;
    
    CFTimeInterval timeSincePause=[self convertTime:CACurrentMediaTime() fromLayer:nil]-pausedTime;
    self.beginTime=timeSincePause;
}
@end
