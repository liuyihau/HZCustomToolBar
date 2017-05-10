//
//  UITextView+Extension.m
//  华仔微博2期
//
//  Created by tarena on 15/8/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)


-(void)insertAttributedText:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *attributedText))settingBlock
{
    
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
    
        //拼接之前的文字（图片和普通文字）
        [attributedText appendAttributedString:self.attributedText];
        
        //拼接其他文字
        NSUInteger loc = self.selectedRange.location;
//        [attributedText insertAttributedString:text atIndex:loc];
    //替换
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    
        //调用外面传进来的代码
    if (settingBlock) {
        settingBlock(attributedText);
    }
    
        self.attributedText = attributedText;
    
    
        //移动光标到表情的后面
        self.selectedRange = NSMakeRange(loc + 1, 0);
   
}

    //selectedRange:
    //1.控制textView的文字选中范围
    //2.如果selecetedRange.length为0 ,selectedRange.location就是textView的光标位置
    
    //关于textView文字的字体
    //1.如果是普通文字（text）,文字大小是由textView.font控制
    //2.如果是属性文字（attributedText）,文字大小不受textView.font控制，应该利用NSMutableAttributedString的 [attributedText addAttribute:(NSString *) value:(id) range:(NSRange)]:方法设置字体


@end
