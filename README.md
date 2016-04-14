# UITextViewPlaceholderSupport
为 UITextView 添加了 placeholder 的属性支持，同时增加了对字数限制的支持。
使用方法
```objective-c
    UITextView *textView6 = [[UITextView alloc] initWithFrame:frame];
    textView6.placeholder = @"限制文字个数10。";
    textView6.maximumTextLength = 10;
