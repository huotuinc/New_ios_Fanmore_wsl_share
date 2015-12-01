//
//  WebController.h
//  Fanmore
//
//  Created by Cai Jiang on 3/1/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebController : UIViewController

+(instancetype)openURL:(NSString*)url;

@property NSString* targetURL;
-(void)viewWeb:(NSString*)url;
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end
