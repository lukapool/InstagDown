//
//  ExtractView.h
//  InstagDown
//
//  Created by Luka on 2017/8/30.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKATextField.h"
@class ExtractView;

@protocol ExtractViewDelegate <NSObject>

@optional
- (void)extractViewDidCallExtract:(ExtractView *)extractView withValidURL:(NSURL *)postURL;
- (void)extractViewDidCallExtractWithInvalidURL:(ExtractView *)extractView;
- (void)extractViewDidCallExtractWithEmptyURL:(ExtractView *)extractView;

@end

@interface ExtractView : UIView

@property (nonatomic, weak) id<ExtractViewDelegate> delegate;
@property (nonatomic, assign, getter=isExtracting) BOOL extracting;
@property (nonatomic, strong) LKATextField *inputTextField;
- (void)cancellLoading;

@end
