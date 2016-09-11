//
//  ViewController.m
//  网易新闻
//
//  Created by Hsiao on 16/9/8.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "ViewController.h"




// 屏幕宽、高的宏
#define ScreenW [UIScreen mainScreen].bounds.size.width

#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *TitleView;

@property (nonatomic, weak) UIScrollView *ContentView;

@property (nonatomic, weak) UIButton *SelectedButton;


@property (nonatomic, assign) BOOL isLoad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 全部使用代码布局
    // 0. 设置标题
    self.navigationItem.title = @"网易新闻";
    
    // 子类通过[super viewDidLoad];方法来到这里
    // 这里的self代表的是子类,所以视图可以显示
    NSLog(@"----%@", [self class]);
    
    // 1. 添加title的scrollView
    [self setUpTitleView];
    
    // 2. 添加content的scrollView
    [self setUpContentView];
    

    
    // 关闭自动校正
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    
    // 设置代理
    _ContentView.delegate = self;
    

    
}

// 视图将要显示时调用
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//        NSLog(@"%s", __func__);
    
    if (_isLoad == NO)
    {
        // 解除子类中的顺序依赖
        // 但这个方法调用很频繁，要做一次判断
        // 4.设置标题
        [self setUpAllTitle];
        
        _isLoad = YES;
    }
    
}


#pragma mark -
#pragma mark - button居中
- (void)buttonCenter:(UIButton *)button
{
    // 先要判断这个button是不是最旁边的两个
    // 接收子视图个数
//    NSUInteger count = _TitleView.subviews.count;
    
//    if (button.tag == 0 && button.tag == (count - 1))
//    {
//        // 如果是第一个和最后一个就不做任何操作, 我是把button的宽度等于三分之一屏幕宽度才能这样
//        // 没有通用性
//        return;
//    }
        /*
         本来应该是用屏幕的宽度减去button的宽度乘以0.5，求出button的位置
         
         拿到现在点击的button的frame，主要是x的值，与上面求出的x值做比较
         */
    
    CGFloat x = (ScreenW - button.frame.size.width) * 0.5;
    
    // 如果button的x值小于上面的x 和 button的最大x和scrollView的边距小于x都不操作
    
    /*
    还是使用button.center来进行判断，这样其实更加方便计算
    */
    
    // 这里必须通过scrollView的contentSize来获取值
    CGFloat OffX = _TitleView.contentSize.width - CGRectGetMaxX(button.frame);
    
    // 第一次是个负数值，是因为_TitleView.contentSize还没有设置
//    NSLog(@"%f", OffX);
    
    
    
    // 要使用或运算
    if (button.frame.origin.x < x || OffX < x)
    {
        return;
    }
    else
    {
        // 设置偏移量
//        _TitleView.contentOffset = CGPointMake(button.frame.origin.x - x, 0);
        
        [_TitleView setContentOffset:CGPointMake(button.frame.origin.x - x, 0) animated:YES];
        
    }
    

}

#pragma mark -
#pragma mark - scrollViewDelegate
// 停止滚动时调用
// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    // 要获取视图滚动的偏移量
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSUInteger i = offsetX / ScreenW;
    
    // 视频中说有两个自带的子控件VerticalScrollIndicator和HorizontalScrollIndicator
    // 但我在这里打印的值没有问题，只有我自己加的6个字控件
//    NSLog(@"%zd", _TitleView.subviews.count);
    
        
    // 调用button点击方法
    [self btnClick:_TitleView.subviews[i]];
    
    
//    UIView *subView = self.childViewControllers[i].view;
    
    UIViewController *childController = self.childViewControllers[i];
    
    childController.view.frame = CGRectMake(offsetX, 0, ScreenW, scrollView.bounds.size.height);
    
    // 如果加载过就不继续加载
    if (childController.viewIfLoaded)
    {
        return;
    }
    // 再加载子视图
    [scrollView addSubview:childController.view];
    
    
//    NSLog(@"调用了%@", NSStringFromCGPoint(scrollView.contentOffset));
}

// 视图一滚动就会调用
// any offset changes

#if 0
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 要获取视图滚动的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 获取角标
    NSUInteger i = offsetX / ScreenW;
    
    NSLog(@"%zd", i);

    
    NSUInteger rightI = i + 1;
    
    // 获取需要缩放的两个button
    UIButton *leftButton = _TitleView.subviews[i];
    
    UIButton *rightButton;
    
    // 防止角标越界
    if (rightI < self.childViewControllers.count)
    {
        rightButton = _TitleView.subviews[rightI];
    }
    
    // 缩放比例
    // 但这里的缩放比例是 1～0 要改成 1.3～1
    CGFloat scaleL = 1 - (offsetX / ScreenW - i);
    
    // 这里是 0~1
    CGFloat scaleR = offsetX / ScreenW - i;
    
    // 左边的
    leftButton.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL * 0.3 + 1);
    
    // 右边的
    rightButton.transform = CGAffineTransformMakeScale(scaleR * 0.3 + 1 , scaleR * 0.3 +1);
    
    // 实际打印大的都是1～0之间，要是实现1.3～1，是在scale时做的
    NSLog(@"scaleL:%f",scaleL);
    
    NSLog(@"scaleR:%f", scaleR);
    
    // 颜色渐变
    [leftButton setTitleColor:[UIColor colorWithRed:scaleL green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor colorWithRed:scaleR green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    
}
#endif

#if 1
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
//    NSLog(@"offsetX :%f", offsetX);
    
    // 获取角标
    NSUInteger i = offsetX / ScreenW;
//    NSLog(@"%zd", i);
    
    NSUInteger nextI = i + 1;
    
    // 这里我是使用视图的最大x值与 偏移量进行比较
    // 这个里的最大偏移量在最后的时候会变成375，也就是屏幕的宽度，所以会有错误
    // 而上面的方法用的是scrollView.contentOffset.x与屏幕宽度的比值，不会出现数据错误
    
    // 因为我使用的是先偏移，再加载视图所以无法拿到下一个view的最大X值
    // 但是在打印的时候，在倒数第二次打印的值是我想要
//    CGFloat maxX = CGRectGetMaxX(self.childViewControllers[i].view.frame);
    
    // 利用角标求出最大的X值
    CGFloat maxX = nextI * ScreenW;
    
    
//    NSLog(@"maxX :%f", maxX);
    
    // 缩放比例其实就是 1.3 －> 1; 0.3 对应 offsetX 到maxX
    
    // offsetX / maxX 最大是1 最小是0
    // 这个的maxX最后总会变成375，会把缩放率变得很大，不能这样使用
//    CGFloat scale = 1.3 - 0.3 * offsetX / maxX;

    // 尽量获得一个1～0区间的值
    
    CGFloat scale = (maxX - offsetX) / ScreenW;
    
//    NSLog(@"scale :%f", scale);
    
    // 0～1区间
    CGFloat nextS = 1 - scale;
    
//    NSLog(@"nextS :%f", nextS);
    
    // 缩小 1.3~1.0
    _TitleView.subviews[i].transform = CGAffineTransformMakeScale(scale * 0.3 + 1, scale * 0.3 + 1);

    // 颜色渐变
    [_TitleView.subviews[i] setTitleColor:[UIColor colorWithRed:scale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    // 防止角标越界
    if (nextI < _TitleView.subviews.count)
    {
        // 放大 1.0～1.3
        _TitleView.subviews[nextI].transform = CGAffineTransformMakeScale(nextS * 0.3 + 1, nextS * 0.3 + 1);
        [_TitleView.subviews[nextI] setTitleColor:[UIColor colorWithRed:nextS green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    }
    
    
    
}
#endif




#pragma mark -
#pragma mark - 设置标题
- (void)setUpAllTitle
{
    
    // 得通过子视图到数量才知道btn的个数
    NSUInteger j = self.childViewControllers.count;
    
    
    CGFloat w = ScreenW / 3;

    CGFloat x = 0;
    
    for (NSUInteger i = 0; i < j; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 设置btn的Tag
        btn.tag = i;
        
//        NSLog(@"%@", self.childViewControllers[i].title);
        
        // 设置文字
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
//        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        
        // 设置位置
        x = i * w;
        
        btn.frame = CGRectMake(x, 0, w, self.TitleView.bounds.size.height);
        
        // 添加点击事件
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 节目加载进来默认选择第一个
        // 在这里就有一次点击了，但是_TitleView.contentSize还没有设置
        // 所以在上面打印的结果为负值
        if (i == 0)
        {
            [self btnClick:btn];
        }
        
        
//        NSLog(@"%@", btn.currentTitle);
       
//        NSLog(@"%@", NSStringFromCGRect(btn.frame));
        
        // 添加子视图
        [_TitleView addSubview:btn];
    }
    
    
//    NSLog(@"-----%zd", _TitleView.subviews.count);
    
    // 设置视图的滚动范围
    _TitleView.contentSize = CGSizeMake(j * w, 0);
    
    // 关闭弹簧效果
//    _TitleView.bounces = NO;
    
    // 隐藏导航条
    _TitleView.showsVerticalScrollIndicator = NO;
    
    _TitleView.showsHorizontalScrollIndicator = NO;

    // 设置内容视图
    _ContentView.contentSize = CGSizeMake(j * ScreenW, 0);


    
}

#pragma mark -
#pragma mark - 按钮点击事件
- (void)btnClick:(UIButton *)button
{
//    NSLog(@"点了");
    // 改变Button颜色
    [self changeButtonTitle:button];

    // 切换屏幕显示
    
    UIView *subView = self.childViewControllers[button.tag].view;
    
//    CGFloat y = CGRectGetMaxY(_TitleView.frame);

    CGFloat x = button.tag * ScreenW;
    
    subView.frame = CGRectMake(x, 0, ScreenW, _ContentView.bounds.size.height);
//
//    [self.view addSubview: self.childViewControllers[button.tag].view];

    // button居中
//    [self buttonCenter:button];
    
    //iOS9之前的办法，判断是否有加载
    if (subView.superview)
    {
        // 偏移量还是要设置
        _ContentView.contentOffset = CGPointMake(button.tag * ScreenW, 0);
        return;
    }
    
    
    [_ContentView addSubview:subView];
    
    
    _ContentView.contentOffset = CGPointMake(button.tag * ScreenW, 0);
    
}

#pragma mark -
#pragma mark - 修改button的字体
- (void)changeButtonTitle:(UIButton *)button
{
    // 设置一个属性用来保存button字体的属性
    
    [_SelectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 还原设置
    _SelectedButton.transform = CGAffineTransformIdentity;
    
    // 改变标题颜色
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // button进行缩放，会导致文字不清晰
    button.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    _SelectedButton = button;
    
    
    // 在这里调用button居中更好
    [self buttonCenter:button];
        
    
}

#pragma mark -
#pragma mark - 添加title的scrollView
- (void)setUpTitleView
{
    // 创建一个scrollerView
    UIScrollView *view = [[UIScrollView alloc] init];
    
//    view.backgroundColor = [UIColor redColor];
    
    // 要获取导航条的frame
    
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
   
//    NSLog(@"%f", y);
    
    view.frame = CGRectMake(0, y, ScreenW, 40);
    
    _TitleView = view;
    // 添加视图
    [self.view addSubview:_TitleView];
}

#pragma mark -
#pragma mark -添加content的scrollView
- (void)setUpContentView
{
    // 创建一个scrollerView
    UIScrollView *view = [[UIScrollView alloc] init];
    
    view.backgroundColor = [UIColor greenColor];
    
    // 要获取导航条的frame
    
    CGFloat y = CGRectGetMaxY(_TitleView.frame);
    
//    NSLog(@"%f", y);
    
    view.frame = CGRectMake(0, y, ScreenW, ScreenH - y);
    
    _ContentView = view;
    
    
    _ContentView.showsVerticalScrollIndicator = NO;
    
    _ContentView.showsHorizontalScrollIndicator = NO;
    
    // 关闭弹簧效果
    _ContentView.bounces = NO;
    
    // 打开翻页效果
    _ContentView.pagingEnabled = YES;
    
    // 这里进行了一次强引用
    [self.view addSubview:_ContentView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
