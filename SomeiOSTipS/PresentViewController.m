//
//  PresentViewController.m
//  SomeiOSTipS
//
//  Created by tunsuy on 10/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "PresentViewController.h"

@interface PresentViewController ()

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 80, [UIScreen mainScreen].bounds.size.width-60, 30)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor orangeColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius = 10;
    [self.view addSubview:backBtn];
    
}

- (void)backBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
