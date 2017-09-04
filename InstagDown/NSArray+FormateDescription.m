//
//  NSArray+FormateDescription.m
//  InstagDown
//
//  Created by Luka on 2017/9/3.
//  Copyright © 2017年 Luka. All rights reserved.
//

#import "NSArray+FormateDescription.h"

@implementation NSArray (FormateDescription)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *description = [NSMutableString string];
    [description appendString:@"[\n\t"];
    for (id object in self) {
        NSString *string = [NSString stringWithFormat:@"%@", object];
        [description appendString:string];
        [description appendString:@"\n\t"];
    }
    [description appendString:@"]\n]"];
    return description;
}
@end
