//
//  MainTabBarController.m
//  InstagDown
//
//  Created by Luka on 2017/8/29.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customTabBar];

}

/**
 custom tab bar property
 1. background image
 2. shaw image 
 3. select/unselect tint color
 */
- (void)customTabBar {
    UIImage *barBackgroundImage = [[UIImage imageNamed:@"Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 187, 24, 187)];
    [self.tabBar setBackgroundImage: barBackgroundImage];
    self.tabBar.shadowImage = nil;
    self.tabBar.tintColor = [UIColor blackColor];
    self.tabBar.unselectedItemTintColor = [UIColor blackColor];
}




@end
