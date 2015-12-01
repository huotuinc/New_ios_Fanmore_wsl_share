//
//  FanOperationsTester.m
//  Fanmore
//
//  Created by Cai Jiang on 2/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "FanOperationsTester.h"
#import "HttpFanOperations.h"


id getblock(FanOperationsTester* self,SEL _cmd,void (^block)(id,NSError*)){
//    LOG(@" invoked %s in %@",sel_getName(_cmd),self);
    [self.dholder setDone:NO];
    return ^(id data,NSError* error){
        block(data,error);
        [self.dholder setDone:YES];
    };
}

void checkfinish(FanOperationsTester* self){
    while(![self.dholder isDone]){
        sleep(1);
    }
}

void mymethodimp0(FanOperationsTester* self,SEL _cmd,id delegate,void (^block)(id,NSError*)){
    objc_msgSend(self.imps,_cmd,delegate,getblock(self, _cmd, block));
    checkfinish(self);
}

void mymethodimp1(FanOperationsTester* self,SEL _cmd,id delegate,void (^block)(id,NSError*),id v1){
    objc_msgSend(self.imps,_cmd,delegate,getblock(self, _cmd, block),v1);
    checkfinish(self);
}

void mymethodimp2(FanOperationsTester* self,SEL _cmd,id delegate,void (^block)(id,NSError*),id v1,id v2){
    objc_msgSend(self.imps,_cmd,delegate,getblock(self, _cmd, block),v1,v2);
    checkfinish(self);
}

void mymethodimp3(FanOperationsTester* self,SEL _cmd,id delegate,void (^block)(id,NSError*),id v1,id v2,id v3){
    objc_msgSend(self.imps,_cmd,delegate,getblock(self, _cmd, block),v1,v2,v3);
    checkfinish(self);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation FanOperationsTester

+(instancetype)tester:(id<FanOperations>)imp holder:(id<DonetagHolder>)holder{
    //class_addMethod([self class], @selector(resolveThisMethodDynamically), (IMP) myMethodIMP, "v@:");
    Protocol* pro = objc_getProtocol("FanOperations");
//    LOG(@"Protocol:%@",pro);
    
    uint methodCount = 0;
    Method * methods = class_copyMethodList([imp class],&methodCount);
    for (int i=0; i<methodCount; i++) {
        Method method = methods[i];
        SEL mname = method_getName(method);
        const char* types = method_getTypeEncoding(method);
        struct objc_method_description md = protocol_getMethodDescription(pro, mname, YES, YES);
        if (md.name!=NULL && md.types!=NULL) {
//            LOG(@"%s:%s",sel_getName(mname),types);
            
            //loading:block:userName:password::  v24@0:4@8@?12@16@20
            //listTask:block:screenType:paging:: v24@0:4@8@?12I16@20
            //detailTask:block:task::            v20@0:4@8@?12@16
            const char* methodName = sel_getName(mname);
            uint hits = 0;
            for (int i=0; ; i++) {
                if (methodName[i]==0) {
                    break;
                }
                if (methodName[i]==':') {
                    hits++;
                }
            }
            hits -= 2;
            switch (hits) {
                case 0:
                    class_addMethod(self, mname, (IMP)mymethodimp0,types);
                    break;
                case 1:
                    class_addMethod(self, mname, (IMP)mymethodimp1,types);
                    break;
                case 2:
                    class_addMethod(self, mname, (IMP)mymethodimp2,types);
                    break;
                case 3:
                    class_addMethod(self, mname, (IMP)mymethodimp3,types);
                    break;
                default:
                    LOG(@"还无法支持太多参数的接口");
            }
            
        }
    }
    free(methods);

    
    FanOperationsTester* value = $new(self);
    value.imps = imp;
    value.dholder = holder;
    return value;
}

@end

#pragma clang diagnostic pop
