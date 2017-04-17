//
//  SKFDanmuView.m
//  DanmuTool
//
//  Created by 孙凯峰 on 2017/4/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//
#import "CALayer+Aimate.h"
#import "DMHeartFlyView.h"
#import "SKFDanmuView.h"
static NSMutableArray *danDaos;

@interface SKFDanmuView()
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;


@end
@implementation SKFDanmuView
+ (instancetype)danmuViewWithDanmuM:(id<SKFDanmuModelDelegate>)danmuM {
    SKFDanmuView *danmuView=[[[NSBundle bundleForClass:[self class]]loadNibNamed:@"SKFDanmuView" owner:nil options:nil]firstObject];
    
    [danmuView.contentBtn setAttributedTitle:danmuM.attributeContent forState:UIControlStateNormal]
    ;
    
    CGSize size = [danmuM.attributeContent.string sizeWithAttributes:@{
                                                                       NSFontAttributeName: [danmuView.contentBtn.titleLabel font]
                                                                       }];
    
    danmuView.bounds = CGRectMake(0, 0, 80 + size.width, danmuView.bounds.size.height);
    danmuView.danmuM = danmuM;
    
    return danmuView;

    
    
}
-(void)didMoveToSuperview {
    [super didMoveToSuperview];
}

-(void)showStars:(CGPoint)point{
    
    CGFloat _heartSize=36;
    DMHeartFlyView *heart = [[DMHeartFlyView alloc] initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.superview addSubview:heart];
    heart.center = point;
    [heart animateInView:self.superview];
}
-(void)dealloc {
    NSLog(@"释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)danmuStateChange:(NSNotification *)notification {
    
    if ([notification.object  isEqual: @(YES)]) {
        [self.layer resumeAnimate];
    }else {
        [self.layer pauseAnimate];
    }
    
}
-(void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    UIImage *backImg = [self.contentBtn backgroundImageForState:UIControlStateNormal];
    UIImage *resultImage = [backImg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 10) resizingMode:UIImageResizingModeTile];
    [self.contentBtn setBackgroundImage:resultImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
