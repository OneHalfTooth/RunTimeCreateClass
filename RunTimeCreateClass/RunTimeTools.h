//
//  RunTimeTools.h
//  RunTimeCreateClass
//
//  Created by 马少洋 on 16/5/7.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunTimeTools : NSObject


+ (void)xSelect:(SEL)selector Tag:(id)obj par:(NSString *)firstPar ,...;


/**
 *  创建一个类
 *
 *  @param classSpuer 父类，如果是根类的话那么父类填写nil
 *  @param className  创建类的类名
 */
+ (void)createAClass:(Class)classSpuer AndClassName:(NSString *)className;
@end
