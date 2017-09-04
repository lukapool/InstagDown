//
//  IGUser.h
//  InstagDown
//
//  Created by Luka on 2017/9/2.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGUser : NSObject <NSCopying>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *profilePicURL;
@property (nonatomic, copy) NSString *fullname;

+ (instancetype)userWithDic:(NSDictionary *)dict;
- (instancetype)initWithUserID:(NSString *)userID username:(NSString *)username profilePicURL:(NSString *)profilePicURL fullname:(NSString *)fullname;

@end
