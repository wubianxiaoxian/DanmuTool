//
//  SKFViewController.m
//  DanmuTool
//
//  Created by wubianxiaoxian on 04/17/2017.
//  Copyright (c) 2017 wubianxiaoxian. All rights reserved.
//
#import "SKFDanmuView.h"
#import "SKFViewController.h"
#import "SKFDanmuBackView.h"
#import "SKFDanmuModel.h"
@interface SKFViewController ()<SKFDanmuBackViewDelegate>
@property (nonatomic, weak) SKFDanmuBackView *backView;


@end

@implementation SKFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKFDanmuBackView *backView=[[SKFDanmuBackView alloc]initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 200)];
    backView.delegate=self;
    backView.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:backView];
    self.backView = backView;
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //添加弹幕模型
    SKFDanmuModel *dM = [[SKFDanmuModel alloc] init];
    dM.attributeContent = [[NSMutableAttributedString alloc] initWithString:@"😉😉22"];
    dM.beginTime = 1;
    dM.liveTime = 9;
    
    
    SKFDanmuModel *dM2 = [[SKFDanmuModel alloc] init];
    dM2.attributeContent = [[NSMutableAttributedString alloc] initWithString:@"😀😁11"];
    dM2.beginTime = 1;
    dM2.liveTime = 8;
    
    [self.backView.danmuMs addObjectsFromArray:@[dM, dM2]];
    
    
}
- (IBAction)pause:(id)sender {
    [self.backView pause];
}
- (IBAction)resume:(id)sender {
    [self.backView resume];
    
}
- (NSTimeInterval)currentTime {
    
    static double time = 0.0;
    time += 0.1;
    return time;
    
}

- (UIView *)danmuViewWithModel:(id<SKFDanmuModelDelegate>)model {
    
    SKFDanmuView *danmuView = [SKFDanmuView danmuViewWithDanmuM:model];
    return danmuView;
    
}

- (void)danmuBackViewDidSelectDanmu: (UIView *)danmuView atPoint: (CGPoint)point{
    
    NSLog(@"点击了弹幕试图 ---- %@ --- %@", danmuView, NSStringFromCGPoint(point));
    if ([danmuView isKindOfClass:[SKFDanmuView class]]) {
        [(SKFDanmuView *)danmuView showStars:point];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
