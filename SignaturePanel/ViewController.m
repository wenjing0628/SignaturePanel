//
//  ViewController.m
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import "ViewController.h"
#import "HuaBanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setTitle:@"签名画板" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(methodSignatureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)methodSignatureClick{
    HuaBanViewController *huabanVC = [[HuaBanViewController alloc]init];
    [self.navigationController pushViewController:huabanVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
