//
//  GettingHeader.m
//  Fanmore
//
//  Created by Cai Jiang on 6/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "GettingHeader.h"
#import "ScorePerDay.h"


CGFloat _gettingHeader_gap=8;
int _getterHeader_maxcount = 8;

void _CGContextMoveToPoint(CGContextRef context,ScorePerDay* sd,int index,CGFloat width,CGFloat pxperscore,int minscore,CGFloat regionHeight){
    CGFloat x = 320.0f - (CGFloat)(_gettingHeader_gap+width*(index+1));
    CGFloat y =regionHeight-_gettingHeader_gap-([sd.score intValue]-minscore)*pxperscore;
    CGContextMoveToPoint(context, x, y);
}

@interface GettingHeader ()

@property NSMutableArray* list;

@property(weak) UILabel* scoreLabel;
@property(weak) UILabel* dateLabel;
@property(weak) UIImageView* imageView;
@property CGFloat regionHeight;
@property CGFloat pxperscore;
@property  NSUInteger selectedIndex;
@property  NSUInteger oldSelectedIndex;
@property CGFloat minscore;

-(void)drawRegion:(CGFloat)completed findex:(NSUInteger)findex context:(CGContextRef)context;

@end

@implementation GettingHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = fmMainColor;
        self.list = $marrnew;
        // Initialization code
        // 55 % 图
        // 45 % 字
        
       self.regionHeight = self.frame.size.height*0.5f;
        
        UILabel* label1 = [[UILabel alloc] init];
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont boldSystemFontOfSize:40.0f];
        label1.backgroundColor = [UIColor clearColor];
        [self addSubview:label1];
        self.scoreLabel = label1;
        
        label1 = [[UILabel alloc] init];
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
        label1.backgroundColor = [UIColor clearColor];
        [self addSubview:label1];
        self.dateLabel = label1;
        
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, self.regionHeight)];
        [self addSubview:image];
        self.imageView = image;
    }
    
    if (!_getterHeader_gh_queue) {
        _getterHeader_gh_queue = dispatch_queue_create("com.huotu.gettingheader", NULL);
    }
    
    return self;
}

-(void)updateLabels{
    if (!self.list || self.list.count==0 || self.list.count<self.selectedIndex) {
        return;
    }
    ScorePerDay* day = self.list[self.selectedIndex];
    if(day){
        NSString* totext = [day.score currencyStringMax2Digits];
        CGSize scoresize = [totext sizeWithFont:self.scoreLabel.font];
        
        [self.scoreLabel setText:totext];
        [self.scoreLabel setFrame:CGRectMake((320.0f-scoresize.width)/2.0f, self.regionHeight, scoresize.width, scoresize.height)];
        
        NSString*  str = $str(@"时间 ● %@",[day.time fmStandStringDateOnlyChinese]);
        
        CGSize timesize = [str sizeWithFont:self.dateLabel.font];
        
        [self.dateLabel setText:str];
        [self.dateLabel setFrame:CGRectMake((320.0f-timesize.width)/2.0f, self.regionHeight+scoresize.height, timesize.width, timesize.height)];
    }
}


-(void)updateScores:(NSArray*)scores max:(NSNumber*)max min:(NSNumber*)min{
    HashAddArray(self.list,scores)
    
    if (max && min && [max floatValue]!=0) {
        CGFloat value = [max floatValue]-[min floatValue];
        
        self.minscore = [min floatValue];
        self.pxperscore  = (self.regionHeight - _gettingHeader_gap*2.0f)/value;
        
        if (self.pxperscore==INFINITY) {
            self.minscore = self.minscore - 1;
            self.pxperscore = self.regionHeight/2.0f-_gettingHeader_gap;
        }
        
        [self updateLabels];
    }
    
    [self drawRegion:0 findex:self.selectedIndex context:nil];
//    [self setNeedsDisplay];
//    [self drawRegion];
}


-(void)selectDate:(NSDate*)date{
    //年月日 对上即可
    
    NSString* str = [date fmStandStringDateOnly];
    for (int i=0; i<self.list.count; i++) {
        if( $eql([[self.list[i] time] fmStandStringDateOnly],str)){
            if (self.selectedIndex!=i) {
                self.oldSelectedIndex = self.selectedIndex;
                self.selectedIndex = i;
                [self updateLabels];
                [self drawRegion:0 findex:self.selectedIndex context:nil];
//                [self setNeedsDisplay];
            }
//            [self drawRegion];
            break;
        }
    }
}

int _getterHeader_fps = 10;
NSTimeInterval _getterHeader_duration = 0.5;
dispatch_queue_t _getterHeader_gh_queue;

/**
 需要几个参数 第二个原来index 还有一个百分比
 **/
-(void)drawRegion:(CGFloat)completed findex:(NSUInteger)findex  context:(CGContextRef)context{
    if (!self.superview) {
        return;
    }
    if(!self.pxperscore)
        return;
    if(self.list.count<=0)
        return;
    if (findex!=self.selectedIndex) {
        return;
    }
    
    completed += (CGFloat)1.0f/(CGFloat)(_getterHeader_fps*_getterHeader_duration);
    
    if(self.oldSelectedIndex==self.selectedIndex){
        //马上完成
        completed = 1;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(nil, 320.0f, self.regionHeight, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        LOG(@"0 context");
        return;
    }
    
//    context = cgcon
    
//    CGContextRestoreGState(context);
    
    //从右 到 左
    //根据selectedIndex -_maxcount/2 和 0 的最大值
    NSUInteger first = MAX(self.oldSelectedIndex- floor(_getterHeader_maxcount/2),0);
    NSUInteger newFirst = MAX(self.selectedIndex- floor(_getterHeader_maxcount/2),0);
    
    //    NSUInteger count =  MIN(self.list.count,_maxcount);
    NSUInteger count =  _getterHeader_maxcount;
    
    CGFloat width = (320.0f)/(count+1);
    
    CGFloat moveWidth = width*(CGFloat)((CGFloat)newFirst-(CGFloat)first);
    CGFloat offsetWidth = moveWidth*(completed);
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"9BF7FE"].CGColor);
    
    __weak GettingHeader* wself = self;
    CGFloat(^xgetter)(int) = ^(int indexFromRight) {
        return 320.0f - (CGFloat)(width*(1+indexFromRight))+offsetWidth;
    };
    
//    LOG(@"offset:%f xgetter(0):%f moveWidth:%f",offsetWidth,xgetter(0),moveWidth);
    
    CGFloat(^ygetter)(ScorePerDay*) = ^(ScorePerDay* perday) {
//        return wself.regionHeight-_gap-([perday.score intValue]-wself.minscore)*wself.pxperscore;
        return _gettingHeader_gap+([perday.score floatValue]-wself.minscore)*wself.pxperscore;
    };
    
//    ScorePerDay* sd = self.list[first];
//    //如果存在first-1 则多绘制一个
//    if (first>0) {
//        CGContextMoveToPoint(context,xgetter(-1),ygetter(self.list[first-1]));
//        CGContextAddLineToPoint(context,xgetter(0),ygetter(sd));
//    }
//    CGContextMoveToPoint(context,xgetter(0),ygetter(sd));
    
    BOOL pointed  = NO;
//    CGContextMoveToPoint(context,400,self.regionHeight+100);
    
    for (int i=0; i<count+5; i++) {
        int newi = i-3;
        int iindex = newi+(int)first+1;
        if(self.list.count<=iindex || iindex<0)
            continue;
        ScorePerDay* sd = self.list[iindex];
        CGFloat x = xgetter(newi+1);
        CGFloat y = ygetter(sd);
        if (pointed) {
            CGContextAddLineToPoint(context, x, y);
        }
        CGContextMoveToPoint(context,x,y);
        pointed = YES;
        NSLog(@"draw %fd,%fd ",x,y);
    }
    
    CGContextStrokePath(context);
//    LOG(@"xgetter(0)%f",xgetter(0));
    
    for (int i=0; i<count+4; i++) {
        int newi = i-2;
        if(self.list.count<=newi+(int)first || newi+(int)first<0)
            continue;
        ScorePerDay* sd = self.list[newi+(int)first];
        if (newi+(int)first==self.selectedIndex) {
            CGContextAddArc(context, xgetter(newi), ygetter(sd), 9.0f, 0, 2*M_PI, 1);
            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"65E2EB" alpha:0.3].CGColor);
            CGContextDrawPath(context, kCGPathFill);
            
            CGContextAddArc(context, xgetter(newi), ygetter(sd), 5.0f, 0, 2*M_PI, 1);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextDrawPath(context, kCGPathFill);
        }else{
            CGFloat x = xgetter(newi);
            if( abs(320.0f-x)<5 || abs(x)<5 )
                continue;
            CGContextAddArc(context, xgetter(newi), ygetter(sd), 5.0f, 0, 2*M_PI, 1);
            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"9BF7FE"].CGColor);
            CGContextDrawPath(context, kCGPathFill);
        }
        
    }
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage* image2 = [UIImage imageWithCGImage:image];
    
    self.imageView.image = image2;
//    [image2 drawInRect:CGRectMake(0, 0, 320, self.regionHeight)];
    
    
    if (completed<1.0f) {
//        UIGraphicsPushContext(context);
        dispatch_async(_getterHeader_gh_queue, ^{
            [NSThread sleepForTimeInterval:(NSTimeInterval)1/_getterHeader_fps];
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself drawRegion:completed findex:findex context:nil];
            });
        });
    }
    
}

@end
