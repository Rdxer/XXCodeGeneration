//
//  OCProperty.h
//  NSRegularExpressionDemo_Cocao
//
//  Created by LXF on 16/1/3.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCProperty : NSObject

///   $(pType)
@property (nonatomic, copy) NSString *type;

///   $(pName)
@property (nonatomic, copy) NSString *name;

+(instancetype)propertyWithType:(NSString *)type name:(NSString *)name;

-(NSString *)makeOCLazyCode;

@end
