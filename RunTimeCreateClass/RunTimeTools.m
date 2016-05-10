//
//  RunTimeTools.m
//  RunTimeCreateClass
//
//  Created by 马少洋 on 16/5/7.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import "RunTimeTools.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation RunTimeTools


/**
 *  执行一个函数
 *
 *  @param selector 选择器
 */
+ (void)xSelect:(SEL)selector Tag:(id)obj par:(NSString *)firstPar ,...{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    va_list params;//定义一个指针列表
    id argument;
    if (firstPar) {
        //使参数列表指针arg_ptr指向函数参数列表中的第一个可选参数，说明：argN是位于第一个可选参数之前的固定参数，（或者说，最后一个 固定参数；…之前的一个参数），函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的。如果有一va函数的声明是void va_test(char a, char b, char c, …)，则它的固定参数依次是a,b,c，最后一个固定参数argN为c，因此就是va_start(arg_ptr, c)。
        va_start(params, firstPar);
        while ((argument = va_arg(params, id))) {//返回参数列表中指针arg_ptr所指的参数，返回类型为type，并使指针arg_ptr指向参数列表中下一个参数
            [array addObject:argument];
        }
        va_end(params);//释放列表指针
    }
    objc_msgSend(obj, selector);
}

//创建一个类
+ (void)createAClass:(Class)classSpuer AndClassName:(NSString *)className{
    Class classObj = objc_allocateClassPair(classSpuer, [className UTF8String], 0);//第一个参数表示父类的名字如果是ji类的话  第一个参数传nil 第二个参数便是类名，utf8string 表示将oc字符串转换成c字符串 第三个参数表示分配的字节数，一般传0就可以了
    id obj = [[classObj alloc]init];
    size_t size = class_getInstanceSize(classObj);
    NSLog(@"类创建所占的的空间大小%zu",size);
    const char * name = class_getName([obj class]);//获取类名
    Class supperClass = class_getSuperclass([obj class]);//获取父类
    const char * superName = class_getName(supperClass);//获取父类名
    NSLog(@"%@----%@------%@",obj,[NSString stringWithUTF8String:name],[NSString stringWithUTF8String:superName]);



//    objc_removeAssociatedObjects(obj);//解除所有的关联关系
//    objc_disposeClassPair([obj class]);//销毁一个类
#warning 类已经被销毁了，所以不能再获取对象大小。如果强行获取crash
//    size = class_getInstanceSize(classObj);
//    NSLog(@"类销毁所占的的空间大小%zu",size);



    /**
     *  创建实例变量必须在注册类之前创建，否则创建失败，类注册过之后就可以使用了
     */
    NSUInteger size1 ;
    NSUInteger aligument1;
    NSGetSizeAndAlignment("@", &size1, &aligument1);
    class_addIvar([obj class], "_proName", size1, aligument1, "@");


    objc_registerClassPair([obj class]);//在oc中注册一个objc_allocateClassPair实例化的类
    size = class_getInstanceSize(classObj);
    NSLog(@"类注册所占的的空间大小%zu",size);

    objc_property_attribute_t type = {"T","@\"NSString\""};//属性的类型
    objc_property_attribute_t own = {"C"," "};//unknow
    objc_property_attribute_t value = {"V","_proName"};//属性的值
    objc_property_attribute_t att[] = {type,own,value,};//属性数组
    class_addProperty([obj class], "proName", att, 3);//添加一个属性 添加的对象，属性的名字，属性数组，属性数组的个数
    //创建成员属性，必须先有对用的成员变量，成员变量用来存储值，给他添加一个set get方法，就可以像property调用了
    class_addMethod([obj class], NSSelectorFromString(@"proName"), (IMP)getTest, "@@:");
    class_addMethod([obj class], NSSelectorFromString(@"setProName:"), (IMP)setTest, "v@:@");



    Ivar ivar = class_getInstanceVariable([obj class], "_proName");
    object_setIvar(obj, ivar, @"好不容易啊");
    id objTemp = object_getIvar(obj, ivar);
    NSLog(@"%@",objTemp);
    [obj setValue:@"好不容易" forKey:@"proName"];
    NSString * temp = [obj valueForKey:@"proName"];
    NSLog(@"%@",temp);
    [RunTimeTools getObjivar:obj];//获取对象属性和属性的值；

}
void setTest(id obj,SEL method,NSString * argument){
    Ivar ivar = class_getInstanceVariable([obj class], "_proName");
//    objc_property_t property = class_getProperty([obj class], "proName");
    object_setIvar(obj, ivar, argument);
}

NSString* getTest(id obj,SEL method){
    Ivar ivar = class_getInstanceVariable([obj class], "_proName");
    return object_getIvar(obj, ivar);
}


//获取对象的属性
+ (void)getObjivar:(id)obj{
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([obj class], &count);
    for (int i = 0; i < count; i++) {
        const char * name = ivar_getName(ivars[i]);
        NSLog(@"%@:%@", [NSString stringWithUTF8String:name],[obj valueForKey:[NSString stringWithUTF8String:name]]);
    }
    free(ivars);

    unsigned int countPro = 0;
    objc_property_t * propertys = class_copyPropertyList([obj class], &countPro);
    for (int i = 0; i < countPro; i++) {
        const char * name = property_getName(propertys[i]);
        NSLog(@"property名字：%s",name);
    }
    free(propertys);

    unsigned int methodCount = 0;
    Method * methods = class_copyMethodList([obj class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        NSString * methodName = NSStringFromSelector(method_getName(methods[i]));
        NSLog(@"方法名:%@",methodName);
    }
    free(methods);
}

@end
