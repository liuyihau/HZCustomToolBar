//
//  MyWorkCircleCommentToolBar.h
//  czjxw
//
//  Created by zhangy on 15/11/17.
//  Copyright © 2015年 mariocmy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHMessageTextView.h"


#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kHorizontalPadding 8
#define kVerticalPadding 5


@protocol MyWorkCircleCommentToolBarDelegate <NSObject>

@optional

/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;


@required
/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

@end


@interface MyWorkCircleCommentToolBar : UIView

@property (nonatomic, weak) id <MyWorkCircleCommentToolBarDelegate> delegate;

/**
 *  操作栏背景图片
 */
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;

/**
 *  背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) UIView *faceView;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) XHMessageTextView *inputTextView;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

/**
 *  初始化方法
 *
 *  @param frame      位置及大小
 *
 *  @return DXMessageToolBar
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

- (void)finishSendMessage;

-(void)becomeFirstResponderForTextField;

@end
