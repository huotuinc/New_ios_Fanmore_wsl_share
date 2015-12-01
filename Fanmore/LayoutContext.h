//
//  LayoutContext.h
//  Fanmore
//
//  Created by Cai Jiang on 2/12/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutContext : NSObject

@property(weak) UIView* parent;
@property(readonly) NSMutableDictionary* views;
@property(readonly) NSMutableDictionary* metrics;

+(instancetype)contextByView:(UIView*)view;

-(instancetype)addMetrics:(NSDictionary *)metrics;
-(instancetype)addMetirc:(NSString*)name number:(NSNumber*)number;
-(instancetype)addViews:(NSDictionary *)views;
-(instancetype)addView:(NSString*)name view:(UIView*)view;
-(instancetype)addLayoutConstraint:(NSLayoutConstraint*)constraint;
-(instancetype)addLayoutConstraint:(NSString*)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(NSString*)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
-(instancetype)visualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts;
-(void)commit;


-(instancetype)equalsRight:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsTop:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsBottom:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsLeft:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsLeading:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsTrailing:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsWidth:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsHeight:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsCenterY:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsCenterX:(NSString*)view1 view2:(NSString*)view2;
-(instancetype)equalsBaseline:(NSString*)view1 view2:(NSString*)view2;


@end
