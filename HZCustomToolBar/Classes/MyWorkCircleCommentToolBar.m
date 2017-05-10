//
//  MyWorkCircleCommentToolBar.m
//  czjxw
//
//  Created by zhangy on 15/11/17.
//  Copyright © 2015年 mariocmy. All rights reserved.
//

#import "MyWorkCircleCommentToolBar.h"

#define EmotionDidSelectNotification @"EmotionDidSelectNotification"
#define EmotionDidDeleteNotification @"EmotionDidDeleteNotification"
// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface MyWorkCircleCommentToolBar()<UITextViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;


/**
 *  toolbarView、按钮、线条
 */
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIView * lineView;

@end

@implementation MyWorkCircleCommentToolBar


- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfigure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return _backgroundImageView;
}

- (UIImageView *)toolbarBackgroundImageView
{
    if (_toolbarBackgroundImageView == nil) {
        _toolbarBackgroundImageView = [[UIImageView alloc] init];
        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _toolbarBackgroundImageView;
}

- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [UIColor clearColor];
    }
    
    return _toolbarView;
}

#pragma mark - setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setToolbarBackgroundImage:(UIImage *)toolbarBackgroundImage
{
    _toolbarBackgroundImage = toolbarBackgroundImage;
    self.toolbarBackgroundImageView.image = toolbarBackgroundImage;
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:self.inputTextView.fullText];
            self.inputTextView.text = @"";

            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (self.inputTextView.fullText.length > 0) {
        
        [self.sendButton setTitleColor:RGBColor(101, 200, 52)forState:UIControlStateNormal];
        self.sendButton.layer.borderColor = RGBColor(101, 200, 52).CGColor;
        self.sendButton.userInteractionEnabled = YES;
        
    }else{
        
        [self.sendButton setTitleColor:RGBColor(180, 180, 180)forState:UIControlStateNormal];
        self.sendButton.layer.borderColor = RGBColor(180, 180, 180).CGColor;
        self.sendButton.userInteractionEnabled = NO;
        
    }
    
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    self.backgroundImageView.image = [[self toolBar_imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    [self addSubview:self.toolbarView];
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    

}



-(UIButton *)sendButton{
    
    if (!_sendButton) {
        //发送按钮
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40 - kVerticalPadding * 2, kVerticalPadding * 2,44, kInputTextViewMinHeight - kVerticalPadding * 2)];
        _sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        

        
        [_sendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _sendButton.layer.borderWidth = 1;
        _sendButton.layer.cornerRadius = 5.0;
        
        [_sendButton setTitleColor:RGBColor(180, 180, 180)forState:UIControlStateNormal];
        _sendButton.layer.borderColor = RGBColor(180, 180, 180).CGColor;
        _sendButton.userInteractionEnabled = NO;
        
            }
    return _sendButton;
}

-(XHMessageTextView *)inputTextView{
    
    if (!_inputTextView) {
        
        CGFloat allButtonWidth = 0.0;
        CGFloat textViewLeftMargin = 6.0;
        
        allButtonWidth += CGRectGetWidth(self.sendButton.frame) + kHorizontalPadding * 1.5;
        CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));

        _inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
        _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _inputTextView.scrollEnabled = YES;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES;
        _inputTextView.placeHolder = @"新建任务";
        _inputTextView.font = [UIFont systemFontOfSize:17];
        _inputTextView.delegate = self;
        _inputTextView.backgroundColor = [UIColor clearColor];
        _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
        
      
    }
    return _inputTextView;
}

-(UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView= [[UIView alloc]init];
        
        _lineView.backgroundColor = RGBColor(101, 200, 52);
    }
    return _lineView;
}

- (void)setupSubviews
{
    
    [self.toolbarView addSubview:self.sendButton];
    [self.toolbarView addSubview:self.inputTextView];
    [self.toolbarView  addSubview:self.lineView];

}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    

    self.frame = toFrame;
    

}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:toFrame.size.height];
        
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
        
    }
    if (toHeight > self.maxTextInputViewHeight) {
        
        toHeight = self.maxTextInputViewHeight;
        
    }
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
        
    }else{
        
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;

        [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];

        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            
            [_delegate didChangeFrameToHeight:self.frame.size.height];
                
        }
    }
    
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{

    CGFloat height = 0.0f;
    
    height =  ceilf([textView sizeThatFits:textView.frame.size].height);
    
    if (height > 200) {
    
        height = 203;
    }
    
    self.lineView.frame = CGRectMake(kVerticalPadding,height + 1, CGRectGetWidth(self.inputTextView.frame), 2);
    
    
    return height;
}

#pragma mark - action

- (void)buttonAction:(id)sender
{

    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:self.inputTextView.fullText];
        self.inputTextView.text = @"";
        
        [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
    }

    
}

#pragma mark - public

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

- (void)finishSendMessage{
    
    [self.inputTextView resignFirstResponder];
    
    self.hidden = YES;
    
}

-(void)becomeFirstResponderForTextField{
    
    [self.inputTextView becomeFirstResponder];
    
    self.hidden = NO;
    
}

#pragma mark - 获取本Bundle中的图片资源
- (NSBundle *)HZCustomToolBarBundle
{
    static NSBundle *CustomToolBarBundle = nil;
    
    if (nil == CustomToolBarBundle) {
        
        CustomToolBarBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZCustomToolBar" ofType:@"bundle"]];
        
        if (nil == CustomToolBarBundle) {
            CustomToolBarBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"HZCustomToolBar" ofType:@"bundle"]];
        }
    }
    return CustomToolBarBundle;
}

- (UIImage *)toolBar_imageNamed:(NSString *)name
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    name = 3.0 == scale ? [NSString stringWithFormat:@"%@@3x.png", name] : [NSString stringWithFormat:@"%@@2x.png", name];
    UIImage *image = [UIImage imageWithContentsOfFile:[[[self HZCustomToolBarBundle] resourcePath] stringByAppendingPathComponent:name]];
    return image;
}

@end
