//
//  TextChangeController.h
//  Fanmore
//
//  Created by Cai Jiang on 3/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TextChangeDelegate <NSObject>

@required
-(void)submitText:(NSString*)str;
@optional
-(void)initText:(UITextField*)text andHint:(UILabel*)label;
-(void)textUpdated:(UITextField*)text andHint:(UILabel*)label;
-(BOOL)textChanged:(UITextField*)text OnHint:(UILabel*)label;
@end

@interface TextChangeController : UIViewController
@property(weak) id<TextChangeDelegate> delegate;

- (IBAction)doDone:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textText;
@property (weak, nonatomic) IBOutlet UILabel *labelHint;
- (IBAction)textEditted:(UITextField *)sender;
- (IBAction)textDone:(id)sender;

@end


