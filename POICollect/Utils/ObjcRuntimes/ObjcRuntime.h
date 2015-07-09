//
//  ObjcRuntime.h
//  POICollect
//
//  Created by 常敏 on 15/7/9.
//  Copyright (c) 2015年 cm. All rights reserved.
//

/**
 *  获取一个类的所有的属性的名字：类型的名字，具有@property的，父类的获取不了
 *
 *  @param object 类
 *
 *  @return 属性的字典
 */
NSDictionary* GetPropertyListOfObject(NSObject* object);
NSDictionary* GetPropertyListOfClass(Class cls);

/**
 *  交换方法
 *
 *  @param c       类
 *  @param origSEL 原来的方法
 *  @param newSEL  新的方法
 */
void Swizzle(Class c, SEL origSEL, SEL newSEL);
