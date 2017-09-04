//
//  PostView.h
//  InstagDown
//
//  Created by Luka on 2017/9/1.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGPost.h"

@class PostView;
typedef void (^CompleteBlock)(void);

@protocol PostViewDelegate <NSObject>
- (void)postViewDidClickMore:(PostView *)postView;
- (void)postViewDidClickShare:(PostView *)postView withActivityItems:(NSArray *)items;
- (void)postViewDidClickSave:(PostView *)postView;
- (void)postView:(PostView *)postView didTapProfileImag:(UIImageView *)profileImageView;

@end

@interface PostView : UIView
@property (nonatomic, strong) IGPost *post;
@property (nonatomic, weak) id <PostViewDelegate> delegate;

- (void)showPostWithBlock:(CompleteBlock)block;
- (void)hidePostWithBlock:(CompleteBlock)block;


@end
