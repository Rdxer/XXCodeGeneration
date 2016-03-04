//
//  OCProperty.m
//  NSRegularExpressionDemo_Cocao
//
//  Created by LXF on 16/1/3.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "OCProperty.h"

#import "XLazySettings.h"

@implementation OCProperty

+(instancetype)propertyWithType:(NSString *)type name:(NSString *)name{
    OCProperty *p = [[self alloc]init];
    p.type = type;
    p.name = name;
    return p;
}

-(NSString *)makeOCLazyCode{
    
    NSString *format = [[XLazySettings lazySettings] formatStringWithType:self.type];
    
    format = [format stringByReplacingOccurrencesOfString:pType withString:self.type];
    format = [format stringByReplacingOccurrencesOfString:pName withString:self.name];
    
    format = [format stringByAppendingString:@"\n"];
    
    return format;
}

@end
