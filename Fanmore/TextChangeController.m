//
//  TextChangeController.m
//  Fanmore
//
//  Created by Cai Jiang on 3/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "TextChangeController.h"

@interface TextChangeController ()

@end

@implementation TextChangeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    if ([self.delegate respondsToSelector:@selector(initText:andHint:)]) {
        [self.delegate initText:self.textText andHint:self.labelHint];
    }
    
    [self.textText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)toSubmit{
    if ([self.delegate respondsToSelector:@selector(textChanged:OnHint:)]) {
        if ([self.delegate textChanged:self.textText OnHint:self.labelHint]) {
            [self.delegate submitText:self.textText.text];
            [self doBack];
        }else{
//            [self.textText shake];
        }
    }else{
        [self.delegate submitText:self.textText.text];
        [self doBack];
    }
}

- (IBAction)doDone:(id)sender {
    [self toSubmit];
}
- (IBAction)textEditted:(UITextField *)sender {
    if ([self.delegate respondsToSelector:@selector(textUpdated:andHint:)]) {
        [self.delegate textUpdated:self.textText andHint:self.labelHint];
    }
}

- (IBAction)textDone:(id)sender {
    [self toSubmit];
}
@end
