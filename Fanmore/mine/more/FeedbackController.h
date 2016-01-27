//
//  FeedbackController.h
//  Fanmore
//
//  Created by Cai Jiang on 3/15/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textName;
- (IBAction)textDid:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textContact;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btSubmit;

@end
