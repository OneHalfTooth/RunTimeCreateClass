//
//  ViewController.m
//  RunTimeCreateClass
//
//  Created by 马少洋 on 16/5/7.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import "ViewController.h"
#import "RunTimeTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    //调用一个参数个数不限的方法
    [RunTimeTools xSelect:NSSelectorFromString(@"didReceiveMemoryWarning") Tag:self par:@"1",@[@"1",@"1"],@{@"1":@"1"},@"1",@(2),@(3),@(4),@(5),nil];

    //调用一个方法创建一个类
    [RunTimeTools createAClass:[NSObject class] AndClassName:@"woshiyigeclass"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
