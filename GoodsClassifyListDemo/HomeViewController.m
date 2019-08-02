//
//  HomeViewController.m
//  GoodsClassifyListDemo
//
//  Created by 惠上科技 on 2019/8/1.
//  Copyright © 2019 ZD. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resultButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resultButton setTitle:@"紫瓶子草" forState:UIControlStateNormal];
    self.resultButton.titleLabel.text = @"紫瓶子草";
}

- (IBAction)selectClick:(UIButton *)sender {
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.nameBlock = ^(NSString *name) {
        [self.resultButton setTitle:name forState:UIControlStateNormal];
        self.resultButton.titleLabel.text = name;
    };
    vc.nameStr = self.resultButton.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
