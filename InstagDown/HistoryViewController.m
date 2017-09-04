//
//  HistoryViewController.m
//  InstagDown
//
//  Created by Luka on 2017/8/29.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "HistoryViewController.h"
#import "MACRO.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"history_normal"] selectedImage:[UIImage imageNamed:@"history_highlight"]];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_BACKGROUND;
}


@end
