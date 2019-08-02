//
//  ViewController.h
//  GoodsClassifyListDemo
//
//  Created by zd on 2019/4/19.
//  Copyright © 2019 ZD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectNameBlock)(NSString *name);
@interface ViewController : UIViewController
@property (nonatomic,copy)NSString *nameStr;
@property (nonatomic,copy)SelectNameBlock nameBlock;
@end

