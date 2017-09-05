//
//  SDImageCache+GetCacheImagePath.h
//  InstagDown
//
//  Created by Luka on 2017/9/5.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <SDImageCache.h>

@interface SDImageCache (GetCacheImagePath)
- (NSString *)defaultCachePathForKey:(NSString *)key;
- (NSString *)cachedFileNameForKey:(NSString *)key;
@end
