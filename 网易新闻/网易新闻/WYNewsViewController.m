//
//  WYNewsViewController.m
//  网易新闻
//
//  Created by Hsiao on 16/9/10.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "WYNewsViewController.h"
#import "Technology.h"
#import "Subscribe.h"
#import "Society.h"
#import "Video.h"
#import "Hotspot.h"
#import "Headline.h"
@interface WYNewsViewController ()

@end

@implementation WYNewsViewController

- (void)viewDidLoad {
    
    
    
    
    // 这里会调用到父类的方法
    [super viewDidLoad];
    
    // 为了扩展性，子视图应该在子类中设置
    // 但这里会有顺序依赖
    // 得到父类中修改
    [self setUpAllChildView];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark - 添加子视图
- (void) setUpAllChildView
{
    // 头条 headline
    Headline *headline = [[Headline alloc] init];
    headline.title = @"头条";
    [self addChildViewController:headline];
    
    // 热点 hotspot
    Hotspot *hotspot = [[Hotspot alloc] init];
    hotspot.title = @"热点";
    [self addChildViewController:hotspot];
    
    // 视频 video
    Video *video = [[Video alloc] init];
    video.title = @"视频";
    [self addChildViewController:video];
    
    // 社会 society
    Society *society = [[Society alloc] init];
    society.title = @"社会";
    [self addChildViewController:society];
    
    // 订阅 subscribe
    Subscribe *subscribe = [[Subscribe alloc] init];
    subscribe.title = @"订阅";
    [self addChildViewController:subscribe];
    
    // 科技 technology
    Technology *technology = [[Technology alloc] init];
    technology.title = @"科技";
    [self addChildViewController:technology];
}


@end
