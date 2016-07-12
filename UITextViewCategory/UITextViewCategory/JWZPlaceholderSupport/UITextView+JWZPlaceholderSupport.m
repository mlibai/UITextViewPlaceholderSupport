//
//  UITextView+JWZPlaceholderSupport.m
//  UITextView
//
//  Created by MJH on 16/4/12.
//  Copyright © 2016年 MXZ. All rights reserved.
//

#import "UITextView+JWZPlaceholderSupport.h"
#import <objc/runtime.h>

static const void *const kJWZPlaceholderSupportKeyOfPlaceholder = &kJWZPlaceholderSupportKeyOfPlaceholder;
static const void *const kJWZPlaceholderSupportKeyOfMaximumTextLength = &kJWZPlaceholderSupportKeyOfMaximumTextLength;

/**
 *  私有类显示占位符的 label，该 label 同时负责监听 textView 的文字数量。
 */
@interface _JWZTextViewPlaceholder : UILabel

@property (nonatomic, weak) UITextView *textView;

- (void)textViewTextDidChange:(NSNotification *)notification;

@end

/**
 *  UITextView 类目，增加对placeholder的支持。
 */
@implementation UITextView (JWZPlaceholderSupport)

+ (void)load {
    /**
     *  1. 为了能实时的让占位符字体大小textView实际字体大小一致，替换了 [UITextView setFont:] 的原始方法的实现。
     *  2. 为了能实时控制占位符的显示或隐藏，替换了 [UITextView setText:]、[UITextView setAttributedText:] 的原始方法的实现。
     *  3. 替换操作发生在类载入的时候，对所有 UITextView 及其子类都会产生影响。
     */
    [self _JWZTextViewPlaceholderSupportExchangeSelectorImplementation:@selector(setFont:) toSelectorImplementation:@selector(_JWZPlaceholderSupportSetFont:)];
    [self _JWZTextViewPlaceholderSupportExchangeSelectorImplementation:@selector(setText:) toSelectorImplementation:@selector(_JWZPlaceholderSupportSetText:)];
    [self _JWZTextViewPlaceholderSupportExchangeSelectorImplementation:@selector(setAttributedText:) toSelectorImplementation:@selector(_JWZPlaceholderSupportSetAttributedText:)];
}

- (void)setXz_placeholder:(NSString *)placeholder {
    if (placeholder != nil) {
        [[self _JWZTextViewPlaceholder] setText:placeholder];
    } else {
        [[self _JWZTextViewPlaceholderIfLoaded] setText:placeholder];
    }
}

- (NSString *)xz_placeholder {
    return [self _JWZTextViewPlaceholderIfLoaded].text;
}

#pragma mark - Label

- (_JWZTextViewPlaceholder *)_JWZTextViewPlaceholderIfLoaded {
    return objc_getAssociatedObject(self, kJWZPlaceholderSupportKeyOfPlaceholder);
}

- (_JWZTextViewPlaceholder *)_JWZTextViewPlaceholder {
    _JWZTextViewPlaceholder *placeholderLabel = [self _JWZTextViewPlaceholderIfLoaded];
    if (placeholderLabel == nil) {
        placeholderLabel = [[_JWZTextViewPlaceholder alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.font = (self.font != nil ? self.font : [UIFont systemFontOfSize:12.f]);
        placeholderLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self addSubview:placeholderLabel];
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[placeholderLabel]" options:(NSLayoutFormatAlignAllLeft) metrics:nil views:NSDictionaryOfVariableBindings(placeholderLabel)];
        [self addConstraints:constraints1];
        NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[placeholderLabel]" options:(NSLayoutFormatAlignAllLeft) metrics:nil views:NSDictionaryOfVariableBindings(placeholderLabel)];
        [self addConstraints:constraints2];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:placeholderLabel attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeWidth) multiplier:1.0 constant:-16.0];
        constraint1.priority = UILayoutPriorityDefaultHigh;
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:placeholderLabel attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeHeight) multiplier:1.0 constant:-16.0];
        constraint2.priority = UILayoutPriorityDefaultLow;
        [self addConstraint:constraint1];
        [self addConstraint:constraint2];
        
        [self _setJWZTextViewPlaceholder:placeholderLabel];
        
        placeholderLabel.textView = self;
    }
    return placeholderLabel;
}

- (void)_setJWZTextViewPlaceholder:(_JWZTextViewPlaceholder *)textViewPlaceholder {
    objc_setAssociatedObject(self, kJWZPlaceholderSupportKeyOfPlaceholder, textViewPlaceholder, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 替换方法

- (void)_JWZPlaceholderSupportSetFont:(UIFont *)font {
    [[self _JWZTextViewPlaceholderIfLoaded] setFont:font];
    [self _JWZPlaceholderSupportSetFont:font];
}

- (void)_JWZPlaceholderSupportSetText:(NSString *)text {
    [[self _JWZTextViewPlaceholderIfLoaded] setHidden:(text.length > 0)];
    [self _JWZPlaceholderSupportSetText:text];
}

- (void)_JWZPlaceholderSupportSetAttributedText:(NSAttributedString *)attributedText {
    [[self _JWZTextViewPlaceholderIfLoaded] setHidden:(attributedText.length > 0)];
    [self _JWZPlaceholderSupportSetAttributedText:attributedText];
}

#pragma mark - 字数限制

- (void)setXz_maximumTextLength:(NSUInteger)maximumTextLength {
    objc_setAssociatedObject(self, kJWZPlaceholderSupportKeyOfMaximumTextLength, [NSNumber numberWithInteger:maximumTextLength], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)xz_maximumTextLength {
    NSUInteger max = [objc_getAssociatedObject(self, kJWZPlaceholderSupportKeyOfMaximumTextLength) integerValue];
    return (max > 0 ? max : NSUIntegerMax);
}

#pragma mark - 交换两个方法的执行语句

+ (void)_JWZTextViewPlaceholderSupportExchangeSelectorImplementation:(SEL)oldSelector toSelectorImplementation:(SEL)newSelector {
    Class aClass = [self class];
    Method oldMethod = class_getInstanceMethod(aClass, oldSelector);
    Method newMethod = class_getInstanceMethod(aClass, newSelector);
    if (!class_addMethod(aClass, oldSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

@end

#pragma mark - JWZTextViewPlaceholder

@implementation _JWZTextViewPlaceholder

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewTextDidChange:(NSNotification *)notification {
    if (notification.object == _textView) {
        NSUInteger length = _textView.text.length;
        if (length > 0) {
            self.hidden = YES;
            NSUInteger max = _textView.xz_maximumTextLength;
            if (length > max) {
                NSString *text = [_textView.text substringToIndex:NSMaxRange([_textView.text rangeOfComposedCharacterSequenceAtIndex:(max - 1)])];
                [_textView _JWZPlaceholderSupportSetText:text]; // 这里调用的实际上是 [UITextView setText:] 的原始方法。
            }
        } else {
            self.hidden = NO;
        }
    }
}

- (void)setTextView:(UITextView *)textView {
    if (_textView != textView) {
        _textView = textView;
        if (_textView != nil) {
            self.hidden = (_textView.text.length > 0);
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        }
    }
}

@end


