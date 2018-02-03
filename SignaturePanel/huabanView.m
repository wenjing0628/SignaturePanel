//
//  huabanView.m
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import "huabanView.h"
#import "SelectColorEasyView.h"
#import "SelectColorPickerView.h"
#import "YJBezierPath.h"

@interface huabanView ()<SelectColorEasyViewDelegate,SelectColorPickerViewDelegate>
@property (nonatomic,strong) SelectColorPickerView  *selectColorView;
@property (nonatomic,strong) SelectColorEasyView  *selectColorEasyView;
@property (nonatomic,strong) YJBezierPath *bezierPath;
@property (nonatomic,strong) UIButton  *btnSelectColor;
@property (nonatomic,strong) NSMutableArray  *beziPathArrM;
@end

@implementation huabanView{
    UIView *headView;
    UIView *buttomView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.lineColor = [UIColor redColor];
        
        [self addHeadBar];
        [self addBottomBar];
    }
    return self;
}
- (void)addHeadBar{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headView];
    
    NSArray *array = @[@"选色方案1",@"选色方案2"];
    for (NSInteger i = 0; i < array.count; i++) {
        self.btnSelectColor = [[UIButton alloc]initWithFrame:CGRectMake(headView.width/2 * i, 0, headView.width/2 - 1, 44)];
        self.btnSelectColor.tag = 100 + i;
        [self.btnSelectColor setTitle:array[i] forState:UIControlStateNormal];
        [self.btnSelectColor addTarget:self action:@selector(selectColorClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btnSelectColor.backgroundColor = [UIColor orangeColor];
        [headView addSubview:self.btnSelectColor];
    }
}
- (void)addBottomBar{
    buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-49, self.width, 49)];
    buttomView.backgroundColor = [UIColor blackColor];
    [self addSubview:buttomView];
    
    NSArray *array = @[@"撤销",@"清空",@"橡皮擦",@"保存"];
    CGFloat btnW = self.width/4;
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *btnAction = [[UIButton alloc] initWithFrame:CGRectMake(btnW * i, 0, btnW, buttomView.height)];
        btnAction.tag = 1000 + i;
        [btnAction setTitle:array[i] forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(btnActionClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:btnAction];
    }
}
#pragma mark - 选色方案
- (void)selectColorClick:(UIButton *)sender{
    if (sender.tag == 100) {
        self.selectColorView.hidden = NO;
        self.selectColorView.frame = CGRectMake(0, 0, self.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            self.selectColorView.frame = CGRectMake(0, 0, self.width, self.width);
        }];
    }else if (sender.tag == 101){
        self.selectColorEasyView.hidden = NO;
        self.selectColorEasyView.frame = CGRectMake(0, 0, 0, 44);
        [UIView animateWithDuration:0.3 animations:^{
            self.selectColorEasyView.frame = CGRectMake(0, 0, self.width, 44);
        }];
    }
}
#pragma mark - 操作栏方法
- (void)btnActionClick:(UIButton *)sender{
    switch (sender.tag - 1000) {
        case 0:
        {
            if(self.beziPathArrM.count>0){
                [self.beziPathArrM removeObjectAtIndex:self.beziPathArrM.count-1];
                [self setNeedsDisplay];
            }
        }
            break;
        case 1:
            [self.beziPathArrM removeAllObjects];
            [self setNeedsDisplay];
            break;
        case 2:
            self.isErase = YES;
            break;
        case 3:
        {
            //如果打开了选色1，先关闭
            if (!self.selectColorView.hidden) {
                self.selectColorView.hidden = YES;
            }
            [self showHeadAndBottom:NO];
            
            UIImage *currentImg = [self captureImageFromView:self];
            UIImageWriteToSavedPhotosAlbum(currentImg, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
            
            [self showHeadAndBottom:YES];
        }
            break;
        default:
            break;
    }
}
-(void)showHeadAndBottom:(BOOL)isShow{
    headView.hidden = !isShow;
    buttomView.hidden = !isShow;
}
#pragma mark - 保存图片
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}
#pragma view 转图片
-(UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = view.bounds;////CGRectMake(0, 108, KScreenWidth, KScreenHeight - 108 - 49);
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
#pragma mark - 画画
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    self.bezierPath = [[YJBezierPath alloc]init];
    self.bezierPath.lineColor = self.lineColor;
    self.bezierPath.isErase = self.isErase;
    [self.bezierPath moveToPoint:currentPoint];
    [self.beziPathArrM addObject:self.bezierPath];
}
static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint midP = midpoint(previousPoint,currentPoint);
    //  这样写不会有尖头
    [self.bezierPath addQuadCurveToPoint:currentPoint controlPoint:midP];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint midP = midpoint(previousPoint,currentPoint);
    [self.bezierPath addQuadCurveToPoint:currentPoint   controlPoint:midP];
    // touchesMoved
    [self setNeedsDisplay];
    
}
#pragma mark - 画线
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.beziPathArrM.count) {
        for (YJBezierPath *path in self.beziPathArrM) {
            if (path.isErase) {
                [self.backgroundColor setStroke];
            }else{
                [path.lineColor setStroke];
            }
            path.lineCapStyle = kCGLineCapRound;
            path.lineJoinStyle = kCGLineCapRound;
            if (path.isErase) {
                path.lineWidth = 10;
                [path strokeWithBlendMode:kCGBlendModeDestinationIn alpha:1.0];
            }else{
                path.lineWidth = 3;
                [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
            }
            [path stroke];
        }
    }
   
}
#pragma  mark - 选择颜色代理
- (void)getCurrentColor:(UIColor *)color{
    self.isErase = NO;
    self.lineColor = color;
}
- (void)SelectColorEasyViewDidSelectColor:(UIColor *)color{
    self.isErase = NO;
    self.lineColor = color;
}

#pragma mark - 属性创建

-(SelectColorPickerView *)selectColorView{
    if(!_selectColorView){
        _selectColorView=[[SelectColorPickerView alloc] init];
        _selectColorView.delegate = self;
        [self addSubview:_selectColorView];
    }
    return  _selectColorView;
}

-(SelectColorEasyView *)selectColorEasyView{
    if(!_selectColorEasyView){
        _selectColorEasyView=[[SelectColorEasyView alloc] init];
        _selectColorEasyView.delegate = self;
        [self addSubview:_selectColorEasyView];
    }
    return  _selectColorEasyView;
}

-(NSMutableArray *)beziPathArrM{
    if(!_beziPathArrM){
        _beziPathArrM=[NSMutableArray array];
    }
    return  _beziPathArrM;
}

@end
