//
//  FeedbackController.m
//  Fanmore
//
//  Created by Cai Jiang on 3/15/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FeedbackController.h"
#import "FMUtils.h"
#import "AppDelegate.h"

@interface FeedbackController ()
@property BOOL isEmpty;
@property BOOL process;
@end

@implementation FeedbackController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.textContent resignFirstResponder];
    [self.textName resignFirstResponder];
    [self.textContact resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];

    
    self.textContent.backgroundColor = [UIColor clearColor];
    self.textContent.layer.masksToBounds = YES;
    self.textContent.layer.borderWidth = 0.7;
    self.textContent.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.textContent.layer.cornerRadius = 5.0f;
    
//    self.textContent.layer.borderColor = [UIColor grayColor].CGColor;
//    self.textContent.inputAccessoryView = toolBar;
    
    self.textContent.text = @"请留下您的宝贵意见(500字内)";
    self.textContent.textColor = [UIColor lightGrayColor];
    self.isEmpty = YES;
    
    [self.btSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchDown];
}

- (BOOL)textViewShouldBeginEditing:(UITextView*)textView {
    if (self.isEmpty ) {
        self.textContent.text = @"";
        self.textContent.textColor = [UIColor blackColor];
        self.isEmpty  = NO;
    }
    return YES;
}

- (void) textViewDidEndEditing:(UITextView*)textView {
    if(self.textContent.text.length == 0){
        self.textContent.textColor = [UIColor lightGrayColor];
        self.textContent.text = @"请留下您的宝贵意见(500字内)";
        self.isEmpty  = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textDid:(UITextField *)sender {
    if (sender==self.textName) {
        [self.textContact becomeFirstResponder];
    }
    if (sender==self.textContact) {
        [self.textContent becomeFirstResponder];
    }
}
- (IBAction)submit:(id)sender {
    __weak FeedbackController* wself = self;
    if (!$safe(self.textName.text) || self.textName.text.length==0 || self.textName.text.length>10) {
        [FMUtils alertMessage:self.view msg:@"请输入联系人" block:^{
            [wself.textName shake];
            [wself.textName becomeFirstResponder];
        }];
        return;
    }
    if (!$safe(self.textContact.text) || self.textContact.text.length==0 || self.textContact.text.length>20) {
        [FMUtils alertMessage:self.view msg:@"请输入联系方式" block:^{
            [wself.textContact shake];
            [wself.textContact becomeFirstResponder];
        }];
        return;
    }
    if (self.isEmpty || !$safe(self.textContent.text) || self.textContent.text.length==0 || self.textContent.text.length>500) {
        [FMUtils alertMessage:self.view msg:@"请输入您的宝贵意见" block:^{
            [wself.textName shake];
            [wself.textName becomeFirstResponder];
        }];
        return;
    }
    
    if (wself.process) {
        return;
    }
    
    wself.process = YES;
    [[[AppDelegate getInstance] getFanOperations] feedback:Nil block:^(NSString *msg, NSError *error) {
//        wself.process = NO;
        if ($safe(error)) {
            if (safeController(wself)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            }
            return;
        }
        NSString* toshow;
        if ($safe(msg) && msg.length>0) {
            toshow = msg;
        }else{
            toshow = @"感谢您的反馈！";
        }
        
        [FMUtils alertMessage:wself.view msg:toshow block:^{
            if (safeController(wself)) {
                [wself doBack];
            }
        }];
    } name:self.textName.text contact:self.textContact.text content:self.textContent.text];
}
@end
