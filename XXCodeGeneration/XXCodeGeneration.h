//
//  XXCodeGeneration.h
//  XXCodeGeneration
//
//  Created by LXF on 16/1/19.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import <AppKit/AppKit.h>

@class XXCodeGeneration;

static XXCodeGeneration *sharedPlugin;

@interface XXCodeGeneration : NSObject

+ (instancetype)sharedPlugin;

- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;

@end