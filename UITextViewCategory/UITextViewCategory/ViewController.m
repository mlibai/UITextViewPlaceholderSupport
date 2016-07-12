//
//  ViewController.m
//  UITextViewCategory
//
//  Created by MJH on 16/4/13.
//  Copyright © 2016年 MXZ. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+JWZPlaceholderSupport.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 只设置 placeholder
    CGRect frame = {{10, 20}, {300, 100}};
    UITextView *textView1 = [[UITextView alloc] initWithFrame:frame];
    textView1.xz_placeholder = @"只设置 placeholder";
    [self.view addSubview:textView1];
    
    // 设置 placeholder 后设置字体大小
    frame.origin.y += 105;
    UITextView *textView2 = [[UITextView alloc] initWithFrame:frame];
    textView2.xz_placeholder = @"设置 placeholder 后设置字体大小";
    textView2.font = [UIFont systemFontOfSize:28.0];
    [self.view addSubview:textView2];
    
    // 设置 placeholder 后设置字体大小
    frame.origin.y += 105;
    UITextView *textView3 = [[UITextView alloc] initWithFrame:frame];
    textView3.font = [UIFont systemFontOfSize:6.0];
    textView3.xz_placeholder = @"设置 placeholder 后设置字体大小";
    [self.view addSubview:textView3];
    
    // 设置 placeholder 前设置文字
    frame.origin.y += 105;
    UITextView *textView4 = [[UITextView alloc] initWithFrame:frame];
    textView4.text = @"设置 placeholder 前设置文字";
    textView4.xz_placeholder = @"设置 placeholder 前设置文字";
    [self.view addSubview:textView4];
    
    // 设置 placeholder 后设置文字
    frame.origin.y += 105;
    UITextView *textView5 = [[UITextView alloc] initWithFrame:frame];
    textView5.xz_placeholder = @"设置 placeholder 后设置文字";
    textView5.text = @"设置 placeholder 后设置文字";
    textView5.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:textView5];
    
    // 限制文字个数10。
    frame.origin.y += 105;
    UITextView *textView6 = [[UITextView alloc] initWithFrame:frame];
    textView6.xz_placeholder = @"限制文字个数10。";
    textView6.xz_maximumTextLength = 10;
    [self.view addSubview:textView6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
