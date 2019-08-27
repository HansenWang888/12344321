//
//  ViewController.m
//  Project
//
//  Created by Mike on 2019/1/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)initUI {
}
- (void)testAction {
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
