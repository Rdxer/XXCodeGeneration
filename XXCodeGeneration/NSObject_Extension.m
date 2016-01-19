//
//  NSObject_Extension.m
//  XXCodeGeneration
//
//  Created by LXF on 16/1/19.
//  Copyright © 2016年 LXF. All rights reserved.
//


#import "NSObject_Extension.h"
#import "XXCodeGeneration.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[XXCodeGeneration alloc] initWithBundle:plugin];
        });
    }
}
@end
