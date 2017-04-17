//
//  SKFDanmuBackView.m
//  DanmuTool
//
//  Created by 孙凯峰 on 2017/4/13.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

#import "SKFDanmuBackView.h"
#import "CALayer+Aimate.h"

#define kCheckTime 0.1

#define kLaneCount 5

@interface SKFDanmuBackView()
{
    BOOL _isPause;
}
/**
 用于记录各个弹道的剩余存活时间
 */
@property (nonatomic, strong) NSMutableArray *laneLiveTimes;

/**
 用于记录各个弹道的剩余绝对等待时间
 */
@property (nonatomic, strong) NSMutableArray *laneWaitTimes;


/**
 定时器, 负责定时的给各个弹道的存活时间-1, 负责检测, 可以发射的弹幕模型, 并配合相应的弹幕视图, 进行发射
 */
@property (nonatomic, weak) NSTimer *updateTimer;


/**
 用于存放当前屏幕上的弹幕
 */
@property (nonatomic, strong) NSMutableArray *danmuViews;


@end
@implementation SKFDanmuBackView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer setMasksToBounds:YES];
        UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGester:)];
        [self addGestureRecognizer:tapGester];
    }
    return self;
}


- (void)tapGester: (UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self];
    
    for (UIView *danmuView in self.danmuViews) {
        CGRect tempFrame = danmuView.layer.presentationLayer.frame;
        if (CGRectContainsPoint(tempFrame, point)) {
            //            NSLog(@"选中了, 视图--%@", danmuView);
            if ([self.delegate respondsToSelector:@selector(danmuBackViewDidSelectDanmu:atPoint:)]) {
                [self.delegate danmuBackViewDidSelectDanmu:danmuView atPoint:point];
            }
        }
    }
}




- (NSMutableArray *)laneLiveTimes {
    if (!_laneLiveTimes) {
        _laneLiveTimes = [NSMutableArray arrayWithCapacity:kLaneCount];
        for (int i = 0; i < kLaneCount; i++) {
            [_laneLiveTimes addObject:@0];
        }
    }
    return _laneLiveTimes;
}

- (NSMutableArray *)laneWaitTimes {
    if (!_laneWaitTimes) {
        _laneWaitTimes = [NSMutableArray arrayWithCapacity:kLaneCount];
        for (int i = 0; i < kLaneCount; i++) {
            [_laneWaitTimes addObject:@0];
        }
    }
    return _laneWaitTimes;
}


- (NSMutableArray<id<SKFDanmuModelDelegate>> *)danmuMs {
    if (!_danmuMs) {
        _danmuMs = [NSMutableArray array];
    }
    return _danmuMs;
}

- (NSMutableArray *)danmuViews {
    if (!_danmuViews) {
        _danmuViews = [NSMutableArray array];
    }
    return _danmuViews;
}



- (NSTimer *)updateTimer {
    if (!_updateTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:kCheckTime target:self selector:@selector(check) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _updateTimer = timer;
    }
    return _updateTimer;
}

- (void)didMoveToSuperview {
    [self updateTimer];
}

- (void)dealloc {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

// 每一秒都会执行一次这个方法
- (void)check {
    
    if (_isPause) {
        return;
    }
    
    // 1. 给每个弹道的存活时间都减去1 , 如果减到0 , 则不再减
    NSInteger count = self.laneLiveTimes.count;
    for (int i = 0; i < count; i ++) {
        if ([self.laneLiveTimes[i] doubleValue] <= 0) {
            self.laneLiveTimes[i] = @0;
            continue;
        }
        self.laneLiveTimes[i] = @([self.laneLiveTimes[i] doubleValue] - kCheckTime);
    }
    // 1.2 各个弹道的绝对等待时间
    for (int i = 0; i < count; i ++) {
        if ([self.laneWaitTimes[i] doubleValue] <= 0) {
            self.laneWaitTimes[i] = @0;
            continue;
        }
        self.laneWaitTimes[i] = @([self.laneWaitTimes[i] doubleValue] - kCheckTime);
    }
    
    
    NSLog(@"%@", self.laneLiveTimes);
    
    
    // 2. 从弹幕源中, "取出(从弹幕源移除)"合适的弹幕模型, 并使用弹幕视图进行发射
    // 2.1 对弹幕源的数据, 按照弹幕开始时间, 从小到大进行排序
    [self.danmuMs sortUsingComparator:^NSComparisonResult(id<SKFDanmuModelDelegate>  _Nonnull obj1, id<SKFDanmuModelDelegate>  _Nonnull obj2) {
        if (obj1.beginTime <= obj2.beginTime) {
            return NSOrderedAscending;
        }else {
            return NSOrderedDescending;
        };
    }];
    
    // 2.2 从第一个弹幕开始遍历, 逐个检测是否满足条件
    NSMutableArray *deleteModels = [NSMutableArray array];
    for (id<SKFDanmuModelDelegate> model in self.danmuMs) {
        
        NSTimeInterval currentTime = self.delegate.currentTime;
        if (model.beginTime > currentTime) {
            break;
        }
        
        // 把这个模型放在每一个弹道里面去检测, 能否发射
        BOOL isFirstModelCanBiu = NO;
        for (int i = 0; i < self.laneLiveTimes.count; i++) {
            BOOL isCanBiu = [self checkBiuDanmuWithModel:model index:i];
            if (isCanBiu) {
                [deleteModels addObject:model];
                isFirstModelCanBiu = YES;
                break;
            }
        }
        if (!isFirstModelCanBiu) {
            break;
        }
    }
    
    [self.danmuMs removeObjectsInArray:deleteModels];
    
}



- (BOOL)checkBiuDanmuWithModel: (id<SKFDanmuModelDelegate>)model index: (NSInteger)index {
    
    // 什么时候不能biu
    // 0. 还没到发射时间
    // 1. 该弹道有等待时间
    // 2. 在剩余时间内, 这个模型对应的视图x值, 可以跑到超过屏幕左侧
    
    if ([self.laneWaitTimes[index] doubleValue] > 0) {
        return NO;
    }
    
    UIView *danmuView = [self.delegate danmuViewWithModel:model];
    NSTimeInterval danmuLiveTime = model.liveTime;
    NSTimeInterval laneLiveTime = [self.laneLiveTimes[index] doubleValue];
    // 计算速度
    float speed = (self.bounds.size.width + danmuView.bounds.size.width) / danmuLiveTime;
    // 计算剩余时间内, 可以跑的距离
    CGFloat distance = speed * laneLiveTime;
    if (distance > self.bounds.size.width) {
        return NO;
    }
    
    
    // 0. 根据弹道索引, 重置剩余时间 + 弹幕完全进入屏幕的时间
    float ratio = danmuView.bounds.size.width / (self.bounds.size.width + danmuView.bounds.size.width);
    self.laneLiveTimes[index] = @(model.liveTime);
    self.laneWaitTimes[index] = @(ratio * model.liveTime);
    
    // 1. 根据模型, 获取相应的弹幕视图
    [self addSubview:danmuView];
    [self.danmuViews addObject:danmuView];
    // 2. 根据弹道的索引, 确定Y值
    CGFloat laneH = self.bounds.size.height / kLaneCount;
    CGFloat y = index * laneH;
    CGFloat x = self.bounds.size.width;
    
    CGRect frame = danmuView.frame;
    frame.origin = CGPointMake(x, y);
    danmuView.frame = frame;
    
    [UIView animateWithDuration:model.liveTime delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = danmuView.frame;
        frame.origin.x = -danmuView.bounds.size.width;
        danmuView.frame = frame;
    } completion:^(BOOL finished) {
        // 动画完毕, 移除该视图
        [danmuView removeFromSuperview];
        [self.danmuViews removeObject:danmuView];
    }];
    
    
    return YES;
}

- (void)pause {
    if (!_isPause) {
        _isPause = YES;
        [[self.danmuViews valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(pauseAnimate)];
        
        // 停止计时器
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        
    }
}
- (void)resume {
    if (_isPause) {
        _isPause = NO;
        [[self.danmuViews valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(resumeAnimate)];
        
        // 开启定时器
        [self updateTimer];
    }
    
    
}


@end
