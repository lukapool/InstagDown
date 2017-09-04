//
//  LKAYoutubeLikeLoadingIndicatorView
//  youtube-like-spinner
//
//  Created by Luka on 2017/8/11.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAYoutubeLikeLoadingIndicatorView : UIView

/**
 Set the Indicator line width , default is 5;
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 Set the colors of spinner color , defalult is a UIColor array contained four colors;
 */
@property (nonatomic, copy) NSArray *spinnerColors;
/**
 if you set this property YES, the indicator will hide when you stop the animation. default is NO.
 */
@property (nonatomic, assign) BOOL hidesWhenStopped;

/**
 start animating
 */
- (void)startAnimating;

/**
 stop animating
 */
- (void)stopAnimating;

@end
