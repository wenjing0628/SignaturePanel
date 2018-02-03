//
//  SelectColorEasyView.h
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectColorEasyViewDelegate <NSObject>
-(void)SelectColorEasyViewDidSelectColor:(UIColor *)color;
@end

@interface SelectColorEasyView : UIView
@property (nonatomic,weak) id<SelectColorEasyViewDelegate>  delegate;
@end
