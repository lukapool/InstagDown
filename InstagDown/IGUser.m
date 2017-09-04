//
//  IGUser.m
//  InstagDown
//
//  Created by Luka on 2017/9/2.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "IGUser.h"
    //"owner": {
    //    "id": "179488660",
    //    "profile_pic_url": "https://scontent-hkg3-1.cdninstagram.com/t51.2885-19/s150x150/18444025_768304116685079_5142245798108463104_a.jpg",
    //    "username": "admiringscarlett",
    //    "blocked_by_viewer": false,
    //    "followed_by_viewer": true,
    //    "full_name": "Scarlett Ingrid Johansson",
    //    "has_blocked_viewer": false,
    //    "is_private": false,
    //    "is_unpublished": false,
    //    "is_verified": false,
    //    "requested_by_viewer": false
    //}

@implementation IGUser

+ (instancetype)userWithDic:(NSDictionary *)dict {
    NSString *username = dict[@"username"];
    NSString *fullname = dict[@"full_name"];
    NSString *profilePicURL = dict[@"profile_pic_url"];
    NSString *userID = dict[@"id"];
    return [[[self class] alloc] initWithUserID:userID username:username profilePicURL:profilePicURL fullname:fullname];
}

- (instancetype)initWithUserID:(NSString *)userID username:(NSString *)username profilePicURL:(NSString *)profilePicURL fullname:(NSString *)fullname {
    self = [super init];
    if (self) {
        _userID = userID;
        _username = username;
        _fullname = fullname;
        _profilePicURL = profilePicURL;
        _fullname = fullname;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NSString *username = [self.username copy];
    NSString *fullname = [self.fullname copy];
    NSString *profilePicURL = [self.profilePicURL copy];
    NSString *userID = [self.userID copy];
    
    IGUser *user = [[[self class] allocWithZone:zone] initWithUserID:userID username:username profilePicURL:profilePicURL fullname:fullname];
    return user;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[User]\n\tUserID: %@\n\tUserName:%@\n\tFullname:%@\t\nProfilePicURL:%@", _userID, _username, _fullname, _profilePicURL];
}
@end

