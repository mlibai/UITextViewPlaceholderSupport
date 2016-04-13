//
//  UITextView+JWZPlaceholderSupport.h
//  UITextView
//
//  Created by MJH on 16/4/12.
//  Copyright © 2016年 MXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UITextView 类目，增加对placeholder的支持。本类目修改了 UITextView 的属性 .text .font .attributedText 的 setter 方法的实现。
 */
@interface UITextView (JWZPlaceholderSupport)

@property (nonatomic, copy) NSString *placeholder;  // 占位符
@property (nonatomic) NSUInteger maximumTextLength; // 限制文本长度，默认 NSUIntegerMax。

@end
