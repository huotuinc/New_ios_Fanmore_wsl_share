//
//  LoaderController.m
//  Fanmore
//
//  Created by Cai Jiang on 1/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LoaderController.h"
#import "FFCircularProgressView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "FMUtils.h"
#import "LoadingState+Ext.h"
#import "WeiChatAuthorize.h"
#import "NavController.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )




@interface LoaderController ()

@end

@implementation LoaderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)doLoad:(NSNumber*)delay{
    __weak LoaderController* wself = self;
    AppDelegate* ad = [AppDelegate getInstance];
    
    NSLog(@"%@",ad.loadingState.userData.loginCode);
    [[ad getFanOperations]loading:[FFFanOpertationDelegate DelegateForFFCircularProgressView:self.pview] block:^(UIImage *image,NSError* error) {
        
        LOG(@"========%@",error);
        if (error!=Nil) {
            
            LOG(@"on loading %@",error);
            [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                //每次+3 10以后每次+ 5 30以后每次+10 50以后每次60
                NSTimeInterval t = [delay doubleValue];
                if (t>50) {
                    t+= 60;
                }else if(t>30){
                    t+= 10;
                }else if(t>10){
                    t+= 5;
                }else{
                    t+= 2;
                }
                [wself performSelector:@selector(doLoad:) withObject:$double(t) afterDelay:t];
            }];
            return;
        }
        LOG(@"zzzzzzzzzz   Response from init");
        //        LOG(@"return %@ image:%@",ls,ls.image);
        if ([ad.loadingState fmShowCurrent]) {
            wself.backgroundImage.image = image;
        }else{
            //已过去 则删除
            wself.backgroundImage.image = nil;
        }
        
        
        if ([ad.loadingState.loginStatus integerValue]) {
            UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* vc = [main instantiateInitialViewController];
            
            UIWindow * wind = [UIApplication sharedApplication].keyWindow;
            wind.rootViewController = vc;
            [wind makeKeyAndVisible];
//            [wself presentViewController:vc animated:YES completion:^(){
//                [wself removeFromParentViewController];
//                [wself.backgroundImage removeFromSuperview];
//                wself.backgroundImage = nil;
//                [wself.view removeFromSuperview];
//                wself.view = nil;
//            }];
        }else{
            UIStoryboard * mainS = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WeiChatAuthorize * WeiChart = [mainS instantiateViewControllerWithIdentifier:@"WeiChatAuthorize"];
            WeiChart.loginType = 1;
            NavController * nav = [[NavController alloc] initWithRootViewController:WeiChart];
//            [wself presentViewController:nav animated:YES completion:nil];
            UIWindow * wind = [UIApplication sharedApplication].keyWindow;
            wind.rootViewController = nav;
            [wind makeKeyAndVisible];
            
        }
        
    } userName:[ad getLastUsername] password:[ad getLastPassword]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    LOG(@"start loading");
//    [self.view setBackgroundColor:fmMainColor];
    [self doLoad:@1];
    
    
    NSLog(@"xxxxxxxxx-------");
    
    LoadingImg* li  = $new(LoadingImg);
    li.showTime = [[AppDelegate getInstance] getLastImageShowtime];
    
    if (!$safe(li.showTime) || $eql(@"",li.showTime)) {
        return;
    }
    
    LoadingState* ls = $new(LoadingState);
    ls.loadingImg = li;
    
    if ([ls fmShowCurrent]) {
        NSString* localImageFile = [[AppDelegate getInstance].resoucesHome stringByAppendingPathComponent:@"loadingimg"];
        NSData* localImageData = [NSData dataWithContentsOfFile:localImageFile];
        UIImage* localImage = [UIImage imageWithData:localImageData];
        LOG(@"file:%@   image:%@",localImageFile,localImage);
        self.backgroundImage.image = localImage;
        //[self.view bringSubviewToFront:[self.view viewWithTag:1]];
    }else{
        UIScreen* screen = [UIScreen mainScreen];
        CGSize size = screen.bounds.size;
        // 480 3.5
        // 1024 pad?
        // other is 4
        LOG(@"screen height:%f",size.height);
        if(size.height==480){
            self.backgroundImage.image =[UIImage imageNamed:@"LaunchImage-35"];
        }else if(size.height==1024){
            self.backgroundImage.image =[UIImage imageNamed:@"LaunchImage-other"];
        }else{
            self.backgroundImage.image =[UIImage imageNamed:@"LaunchImage-4"];
        }
        
        LOG(@"frame: %f,%f size %f,%f  scale:%f",self.backgroundImage.frame.size.width,self.backgroundImage.frame.size.height,self.backgroundImage.image.size.width,self.backgroundImage.image.size.height,self.backgroundImage.image.scale);
    }
    
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
