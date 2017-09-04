//
//  OpenInInstagramTool.h
//  InstagDown
//
//  Created by Luka on 2017/8/30.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenInInstagramTool : NSObject

+ (void)openIGApp;

+ (void)openIGAppByMediaID:(NSString *)mediaID;

+ (void)openIGAppByUserName:(NSString *)userName;

@end
