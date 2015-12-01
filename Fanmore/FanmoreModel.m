//
//  FanmoreModel.m
//  Fanmore
//
//  Created by Cai Jiang on 2/20/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FanmoreModel.h"
#import <objc/runtime.h>
#import "NSString+Fanmore.h"


@class Task;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation FanmoreModel


+(NSString*)tryAgain:(NSString*)oriName dict:(NSDictionary*)dict class:(Class)class{
    static NSArray* InsensitiveParameters;
    if (InsensitiveParameters==NULL) {
//        LOG(@"init InsensitiveParameters");
        InsensitiveParameters = @[@"updateUrl",@"TaskBrowseScore",@"TaskLinkScore",@"TaskTurnScore",@"IsBindMobile",@"openId",@"isFav",@"isSend"];
    }
    
    for (int i=0; i<InsensitiveParameters.count; i++) {
        NSString* str = InsensitiveParameters[i];
        if ([str caseInsensitiveCompare:oriName]==NSOrderedSame && dict[str]!=Nil) {
            return str;
        }
    }
    Method method = class_getClassMethod([self class], @selector(ownerWorkhard:dict:class:));
    
    if (method!=Nil) {
        NSString* newName = [self ownerWorkhard:oriName dict:dict class:class];
        if ($safe(newName)) {
            return newName;
        }
    }
    
//    if ($eql(@"updateURL",oriName)) {
//        return ...;
//    }
    return nil;
}

+(instancetype)modelFromDict:(NSDictionary*)dict{
    // public pool support todo
    return [self modelFromDict:dict model:$new(self)];
}

+(instancetype)modelFromDict:(NSDictionary*)dict model:(FanmoreModel*)model{
#ifdef FanmoreDebug
    dict = [NSMutableDictionary dictionaryWithDictionary:dict];
#endif
    static NSDictionary* mainBundle;
    
    if (mainBundle==Nil) {
        mainBundle = @{@"NSNumber":[NSNumber class],@"NSString":[NSString class],@"NSDate":[NSDate class]};
    }
    
    uint psize = 0;
    //Ivar * class_copyIvarList(Class cls, unsigned int *outCount)
    Ivar* property = class_copyIvarList(self,&psize);
    for (int i=0; i<psize; i++) {
        Ivar p = property[i];
        const char* name = ivar_getName(p);
//        printf("%s\n",name);
        const char* type = ivar_getTypeEncoding(p);
//        LOG(@"%s : %s",name,type);
        if (type[0]=='@') {
            char* newtype = malloc(strlen(type));
            strcpy(newtype, type);
            newtype[strlen(type)-1]=0;
//            LOG(@"%s",newtype+2);
//            Class targetClass = [NSKeyedUnarchiver classForClassName:[NSString stringWithCString:newtype+2 encoding:NSUTF8StringEncoding]];
            NSString* typeName =[NSString stringWithCString:newtype+2 encoding:NSUTF8StringEncoding];
            newtype[strlen(type)-1]='\"';
            free(newtype);
            
            Class targetClass = [[NSBundle mainBundle]classNamed:typeName];
            if (targetClass==NULL) {
                targetClass = mainBundle[typeName];
            }
            if (targetClass!=NULL) {
//                LOG(@"%@ %s",targetClass,class_getName(self));
                //取目标数据
                NSString* nameo = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                id value = dict[nameo];
                if (value==Nil) {
                    nameo = [self tryAgain:nameo dict:dict class:targetClass];
                    value = dict[nameo];
                }
                if (value!=Nil) {
//                    LOG(@"数据%@ 数据的class:%@  d:%d",value,[value class],[[value class]isSubclassOfClass:targetClass]);
                    if ([[value class]isSubclassOfClass:targetClass]) {
                        //数据匹配
                            object_setIvar(model, p, value);
#ifdef FanmoreDebug
                            NSMutableDictionary* mdict = (NSMutableDictionary*)dict;
                            [mdict removeObjectForKey:nameo];
#endif
                    }else if([targetClass isSubclassOfClass:[FanmoreModel class]] && [value isKindOfClass:[NSDictionary class]]){
                        NSDictionary* dicValue = value;
                        id modelValue = [targetClass modelFromDict:dicValue];
                        object_setIvar(model, p, modelValue);
#ifdef FanmoreDebug
                        NSMutableDictionary* mdict = (NSMutableDictionary*)dict;
                        [mdict removeObjectForKey:nameo];
#endif
                    }else if(targetClass==[NSDate class] && [value isKindOfClass:[NSString class]]){
                        NSDate* dtValue = [value fmToDate];
                        object_setIvar(model, p, dtValue);
#ifdef FanmoreDebug
                        NSMutableDictionary* mdict = (NSMutableDictionary*)dict;
                        [mdict removeObjectForKey:nameo];
#endif
                    }else{
                        LOG(@"%@的%s找到不匹配的数据源",self,name);
                    }
                }else{
//                    LOG(@"没找到数据源%s在%@",name,self);
                }
            }else{
                NSString* nameo = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                id value = dict[nameo];
                if (value==Nil) {
                    nameo = [self tryAgain:nameo dict:dict class:targetClass];
                    value = dict[nameo];
                }
                LOG(@"未知的类别%s %s在%@ 数据:%@",type,name,self,value);
            }
        }else{
            NSString* nameo = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = dict[nameo];
            if (value==Nil) {
                nameo = [self tryAgain:nameo dict:dict class:Nil];
                value = dict[nameo];
            }
//            if (value!=nil && strcmp(type, "c")==0 && [value isKindOfClass:[NSNumber class]]) {
//                object_setIvar(model, p, value);
//#ifdef FanmoreDebug
//                NSMutableDictionary* mdict = (NSMutableDictionary*)dict;
//                [mdict removeObjectForKey:nameo];
//#endif
//            }else
                LOG(@"未知的类别%s %s在%@ 数据%@",type,name,self,value);
        }
    }
    free(property);
    
    if (dict.count>0) {
        Method method = class_getClassMethod([self class], @selector(hasMoreData:dict:));
        if (method!=Nil) {
            [self hasMoreData:model dict:dict];
        }else{
#ifdef FanmoreDebug
            NSMutableDictionary* mdict = (NSMutableDictionary*)dict;
            [mdict removeObjectForKey:@"favoriteList"];
            [mdict removeObjectForKey:@"incomeList"];
            [mdict removeObjectForKey:@"industryList"];
#endif
            LOG(@"%@",dict);
        }
        
    }
    
    return model;
}

#ifdef FanmoreDebug
//-(BOOL) respondsToSelector:(SEL)aSelector {
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
//    return [super respondsToSelector:aSelector];
//}
#endif

@end

#pragma clang diagnostic pop