//
//  LKATextField.m
//  InstagDown
//
//  Created by Luka on 2017/8/30.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "LKATextField.h"
#import "MACRO.h"

@implementation LKATextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleNone;
        self.layer.cornerRadius = INPUT_FIELD_CORNER_RADIUS;
//        self.layer.masksToBounds = YES; 中文会下移
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectZero];
        coverView.backgroundColor = [UIColor whiteColor];
        coverView.layer.cornerRadius = INPUT_FIELD_CORNER_RADIUS ;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"url"]];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame = CGRectMake(INPUT_FIELD_CORNER_RADIUS - 12, 5, INPUT_FIELD_CORNER_RADIUS + 10, INPUT_FIELD_CORNER_RADIUS + 10);
        [coverView addSubview:imageView];
        self.leftView = coverView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.tintColor = [UIColor blackColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.keyboardType = UIKeyboardTypeURL;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, INPUT_FIELD_CORNER_RADIUS * 2, 0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
   return CGRectInset(bounds, INPUT_FIELD_CORNER_RADIUS * 2, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, INPUT_FIELD_CORNER_RADIUS * 2, 0);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
//    return CGRectMake(INPUT_FIELD_CORNER_RADIUS - 12, 5, INPUT_FIELD_CORNER_RADIUS + 10, INPUT_FIELD_CORNER_RADIUS + 10);
        return CGRectMake(0, 0, INPUT_FIELD_CORNER_RADIUS * 2, INPUT_FIELD_CORNER_RADIUS * 2);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIScrollView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            CGPoint offset = view.contentOffset;
//            NSLog(@"%lf", offset);
            if (offset.y != 0) {
                offset.y = 0;
                view.contentOffset = offset;
            }
            break;
        }
    }
}

//- (void)drawTextInRect:(CGRect)rect {
//    NSLog(@"%@", NSStringFromCGRect(rect));
//    [self.text drawInRect:rect withAttributes:self.defaultTextAttributes];
//}
@end
