//
//  SelectColorEasyView.m
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import "SelectColorEasyView.h"


@interface SelectColorEasyView ()
@property (nonatomic,strong) NSMutableArray *colors;
@property (nonatomic,strong) UIButton *btnClose;
@property (nonatomic,strong) UIButton *lastBthSelected;
@end

@implementation SelectColorEasyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _colors = [NSMutableArray arrayWithObjects:@"#000000",@"#555555",@"#7788ee",@"#fff444",@"#3ef888", nil];
        [self initUI];
    }
    return self;
}
- (void)initUI{
    for (int i = 0; i<_colors.count; i++) {
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [UIColor ColorWithHex:_colors[i]];
        view.center = CGPointMake(20 + i*(30+15)+15, 22);
        [self addSubview:view];
        view.tag = i + 1000;
        [view addTarget:self action:@selector(colorSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    _btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    [_btnClose setTitle:@"×" forState:UIControlStateNormal];
    [_btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnClose.titleLabel.font = [UIFont systemFontOfSize:40];
    [_btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnClose];
}
- (void)closeView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, 0, self.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1.0;
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _btnClose.frame = CGRectMake(self.width - self.height, 0, self.height, self.height);
}
- (void)colorSelect:(UIButton *)sender{
    UIColor *color = [UIColor ColorWithHex:_colors[sender.tag - 1000]];
    // 选中效果
    sender.layer.borderColor = [UIColor redColor].CGColor;
    sender.layer.borderWidth = 2;
    if (_lastBthSelected) {
        _lastBthSelected.layer.borderWidth = 0;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectColorEasyViewDidSelectColor:)]) {
        [self.delegate SelectColorEasyViewDidSelectColor:color];
    }
    
    _lastBthSelected = sender;
}

@end
