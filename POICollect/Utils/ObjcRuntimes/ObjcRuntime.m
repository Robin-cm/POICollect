//
//  ObjcRuntime.m
//  POICollect
//  运行时工具类
//  Created by 常敏 on 15/7/9.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "ObjcRuntime.h"
#import <objc/runtime.h>

NSDictionary* GetPropertyListOfObject(NSObject* object)
{
    return GetPropertyListOfClass([object class]);
}

NSDictionary* GetPropertyListOfClass(Class cls)
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t* properties = class_copyPropertyList(cls, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char* propName = property_getName(property);
        const char* propType = property_getAttributes(property);
        if (propName && propType) {
            NSArray* anAttribute = [[NSString stringWithUTF8String:propType] componentsSeparatedByString:@","];
            NSString* aType = anAttribute[0];
            [dict setObject:aType forKey:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
    return dict;
}

/**
 *  交换方法
 *
 *  @param c       类
 *  @param origSEL 原来的方法
 *  @param newSEL  新的方法
 */
void Swizzle(Class c, SEL origSEL, SEL newSEL)
{
    Method oriMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = nil;
    if (!oriMethod) {
        oriMethod = class_getClassMethod(c, origSEL);
        if (!oriMethod) {
            return;
        }
        newMethod = class_getClassMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
    }
    else {
        newMethod = class_getInstanceMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
    }

    if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }
    else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}
