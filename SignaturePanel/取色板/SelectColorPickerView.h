//
//  SelectColorPickerView.h
//  SignaturePanel
//
//  Created by zwj on 2018/2/3.
//  Copyright © 2018年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectColorPickerViewDelegate <NSObject>

- (void)getCurrentColor:(UIColor *)color;
@end

@interface SelectColorPickerView : UIView

@property (nonatomic,assign) id<SelectColorPickerViewDelegate> delegate;

@end
