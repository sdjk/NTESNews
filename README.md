# NTESNews
NTESNews
> 使用代码布局两个`scrollerView`，分别是标题滚动视图和内容滚动视图

- 遇到问题一，要找到导航条的frame才能把标题滚动视图进行布局
>可以通过`self.navigationController.navigationBar.frame`来获得

```objectivec
// 要获取导航条的frame

CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
```

- 遇到问题二，标题滚动视图中添加button的文字无法显示，其实就是整个button无法显示

> 这是因为，在iOS7之后，导航控制器中`scrollView`顶部会自动偏移64。

```objectivec
// 关闭自动校正
self.automaticallyAdjustsScrollViewInsets = NO;
```

## 注意点
> 设置子控制器的背景颜色，最好在子控制`viewDidLoad`方法中设置。
> 因为view都是懒加载，在外部设置就会调用，直接实例化了。

```objectivec
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
}
```
> 判断视图是否已经加载过

1. iOS9及之后的方法

```objectivec
// 如果加载过就不继续加载,控制器方法
if (childController.viewIfLoaded)
{
    return;
}
```
2. iOS9之前的方法，通过是否有superView判断

```objectivec
//iOS9之前的办法，判断是否有加载，视图方法
if (subView.superview)
{
    return;
}
```

>标题居中添加动画

```objectivec
[_TitleView setContentOffset:CGPointMake(button.frame.origin.x - x, 0) animated:YES];
```
>标题字体大小的修改，使用缩放比直接修改字体大小更好，可以有渐变效果

```objectivec
// button进行缩放，会导致文字不清晰
button.transform = CGAffineTransformMakeScale(1.3, 1.3);
```

>监听屏幕滚动对button进行缩放，最好是获得一个[0,1]区间的缩放值

1. 视频中的方法
```objectivec
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
}
```

2. 改造我自己的代码

```objectivec
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSLog(@"offsetX :%f", offsetX);
    
    // 获取角标
    NSUInteger i = offsetX / ScreenW;
    NSLog(@"%zd", i);
    
    NSUInteger nextI = i + 1;
    
    // 这里我是使用视图的最大x值与 偏移量进行比较
    // 这个里的最大偏移量在最后的时候会变成375，也就是屏幕的宽度，所以会有错误
    // 而上面的方法用的是scrollView.contentOffset.x与屏幕宽度的比值，不会出现数据错误
    
    // 因为我使用的是先偏移，再加载视图所以无法拿到下一个view的最大X值
    // 但是在打印的时候，在倒数第二次打印的值是我想要
//    CGFloat maxX = CGRectGetMaxX(self.childViewControllers[i].view.frame);
    
    // 利用角标求出最大的X值
    CGFloat maxX = nextI * ScreenW;
    
    
    NSLog(@"maxX :%f", maxX);
    
    // 缩放比例其实就是 1.3 －> 1; 0.3 对应 offsetX 到maxX
    
    // offsetX / maxX 最大是1 最小是0
    // 这个的maxX最后总会变成375，会把缩放率变得很大，不能这样使用
//    CGFloat scale = 1.3 - 0.3 * offsetX / maxX;

    // 尽量获得一个1～0区间的值
    
    CGFloat scale = (maxX - offsetX) / ScreenW;
    
    NSLog(@"scale :%f", scale);
    
    // 0～1区间
    CGFloat nextS = 1 - scale;
    
    NSLog(@"nextS :%f", nextS);
    
    // 缩小 1.3~1.0
    _TitleView.subviews[i].transform = CGAffineTransformMakeScale(scale * 0.3 + 1, scale * 0.3 + 1);

    // 防止角标越界
    if (nextI < _TitleView.subviews.count)
    {
        // 放大 1.0～1.3
        _TitleView.subviews[nextI].transform = CGAffineTransformMakeScale(nextS * 0.3 + 1, nextS * 0.3 + 1);
    }
    
}
```

>字体颜色渐变，利用颜色的RGB通道设置

```objectivec
// 颜色渐变
[_TitleView.subviews[i] setTitleColor:[UIColor colorWithRed:scale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
```
