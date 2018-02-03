//
//  SelectColorPickerView.m
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import "SelectColorPickerView.h"
#define  My_Width self.bounds.size.width
#define  My_Height self.bounds.size.width
#define  My_Center CGPointMake(self.bounds.size.width * 0.5,self.bounds.size.height * 0.5)

@interface SelectColorPickerView ()
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIButton *btnClose;
@end

@implementation SelectColorPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        _btnClose = [[UIButton alloc] initWithFrame:CGRectMake(My_Width - 50, 0, 50, 50)];
        [_btnClose setTitle:@"×" forState:UIControlStateNormal];
        [_btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnClose.titleLabel.font = [UIFont systemFontOfSize:40];
        [_btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnClose];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.btnClose.frame = CGRectMake(My_Width - 50, 0, 50, 50);
}
// 隐藏取色板
- (void)closeView{
    self.hidden = YES;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect: rect];
    UIImage *backImage = [UIImage imageNamed:@"ColorPalette.png"];
    [backImage drawInRect:CGRectMake(20, (My_Height - (My_Width - 40))/2, My_Width - 40, My_Height - 40)];
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(My_Center.x - 15, My_Center.y - 15, 30, 30)];
    self.centerImageView.image = [UIImage imageNamed:@"point.png"];
    [self addSubview:self.centerImageView];
}

// 获取开始点击的颜色
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGFloat chassRadius = (My_Width - 20)*0.5;
    [self getColorWithTouch:touch width:chassRadius];
    
}
// 在取色板上移动时获取取色板上面的颜色
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGFloat chassRadius = (My_Width - 20)*0.5;
    [self getColorWithTouch:touch width:chassRadius];
}
// 数据处理 代理回调
- (void)getColorWithTouch:(UITouch *)touch width:(CGFloat)width{
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat absDistanceX = fabs(currentPoint.x - My_Center.x);
    CGFloat absDistanceY = fabs(currentPoint.y - My_Center.y);
    CGFloat currentToPointRadius = sqrtf(absDistanceX * absDistanceX + absDistanceY * absDistanceY);
    
    if (currentToPointRadius < width) {
        self.centerImageView.center = currentPoint;
        UIColor *color = [self getPixelColorAtLocation:currentPoint];
        if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentColor:)]) {
            [self.delegate getCurrentColor:color];
        }
    }
}
// 选择完颜色之后自动掩藏
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //这句话可以去掉，去掉的话就必须点击右上角叉叉关闭
    self.hidden = YES;
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point
{
    UIColor* color = nil;
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef inImage = viewImage.CGImage;
    
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil;
    }
    
    size_t w = self.bounds.size.width;
    size_t h = self.bounds.size.height;
    
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void * bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = self.bounds.size.width;
    size_t pixelsHigh = self.bounds.size.height;
    
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8, bitmapBytesPerRow,
                                     colorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

@end
