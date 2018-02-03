//
//  HuaBanViewController.m
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import "HuaBanViewController.h"
#import "huabanView.h"

@interface HuaBanViewController ()
@property (nonatomic,strong) huabanView *huaban;
@end

@implementation HuaBanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"画板";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.huaban];
    // Do any additional setup after loading the view.
}
#pragma mark - 属性创建
- (huabanView *)huaban{
    if (!_huaban) {
        _huaban = [[huabanView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    }
    return _huaban;
}

@end
