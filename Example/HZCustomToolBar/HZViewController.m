//
//  HZViewController.m
//  HZCustomToolBar
//
//  Created by liuyihua2015@sina.com on 05/09/2017.
//  Copyright (c) 2017 liuyihua2015@sina.com. All rights reserved.
//

#import "HZViewController.h"
#import "MyWorkCircleCommentToolBar.h"

@interface HZViewController ()<MyWorkCircleCommentToolBarDelegate>
@property (strong, nonatomic) MyWorkCircleCommentToolBar *commentToolBar;
@end

@implementation HZViewController

- (MyWorkCircleCommentToolBar *)commentToolBar
{
    if (_commentToolBar == nil) {
        _commentToolBar = [[MyWorkCircleCommentToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [MyWorkCircleCommentToolBar defaultHeight], self.view.frame.size.width, [MyWorkCircleCommentToolBar defaultHeight])];
        _commentToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _commentToolBar.delegate = self;
    }
    
    return _commentToolBar;
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //注销通知
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    [self.commentToolBar endEditing:YES];
    
    
    [self.commentToolBar finishSendMessage];
}

- (IBAction)createTask:(UIButton *)sender {
    
    
    
    
    self.commentToolBar.inputTextView.placeHolder = @"新建任务";
    [self.commentToolBar becomeFirstResponderForTextField];
    
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.commentToolBar];
    
    self.commentToolBar.hidden = YES;
    
    
}

#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        //self.tableView.frame = rect;
    }];
    //    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text
{
    NSLog(@"%@",text);
    
    if (text.length == 0) {
        NSLog(@"请输入任务清单");
        return;
    }
    
    [self.commentToolBar finishSendMessage];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
