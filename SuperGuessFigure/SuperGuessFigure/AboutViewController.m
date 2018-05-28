//
//  AboutViewController.m
//  汤姆猫
//
//  Created by 淡淡Taurus on 15/6/26.
//  Copyright (c) 2015年 淡淡Taurus. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

- (IBAction)close;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)close {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
