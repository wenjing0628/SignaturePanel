//
//  huabanView.h
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface huabanView : UIView

//画笔的颜色
@property (nonatomic,copy) UIColor *lineColor;
//是否是橡皮擦
@property (nonatomic,assign) BOOL isErase;
@end
