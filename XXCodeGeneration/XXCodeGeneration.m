//
//  XXCodeGeneration.m
//  XXCodeGeneration
//
//  Created by LXF on 16/1/19.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "XXCodeGeneration.h"

#import "StringFormater.h"
#import "StringHelper.h"
#import "XLazySettings.h"

#import "XLazySettingsWindowController.h"

@interface XXCodeGeneration()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic, strong) NSMenuItem *actionMenuItem;

@property (nonatomic, strong) XLazySettingsWindowController *lazySettingsWC;

@end

@implementation XXCodeGeneration

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];

    
    //增加一个"Plugins"菜单到"Window"菜单前面
    NSMenu *mainMenu = [NSApp mainMenu];
    NSMenuItem *pluginsMenuItem = [mainMenu itemWithTitle:@"Plugins"];
    if (!pluginsMenuItem) {
        pluginsMenuItem = [[NSMenuItem alloc] init];
        pluginsMenuItem.title = @"Plugins";
        pluginsMenuItem.submenu = [[NSMenu alloc] initWithTitle:pluginsMenuItem.title];
        NSInteger windowIndex = [mainMenu indexOfItemWithTitle:@"Window"];
        [mainMenu insertItem:pluginsMenuItem atIndex:windowIndex];
    }
    /// 添加懒加载 action
    if (pluginsMenuItem) {
        [[pluginsMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"生成懒加载代码" action:@selector(makeLazyCode) keyEquivalent:@"L"];
        [actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[pluginsMenuItem submenu] addItem:actionMenuItem];
        
        self.actionMenuItem = actionMenuItem;
    }
    if (pluginsMenuItem) {
        [[pluginsMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"懒加载代码格式配置" action:@selector(jump2LazyFormatSettingWindow) keyEquivalent:@""];
        //        [actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[pluginsMenuItem submenu] addItem:actionMenuItem];
    }
}

#pragma mark - 事件响应

- (void)makeLazyCode{
    
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    NSString *selectedText = [pasteBoard stringForType:NSPasteboardTypeString];

    if (selectedText.length <= 0) {
        [self showErrorAlert:@"选定文本太短."];
        return;
    }
    
    StringFormater *sf = [[StringFormater alloc]initWithRegularPattern:[XLazySettings lazySettings].regularText];
    [sf matchesString:selectedText completed:^(NSArray<TextCheckingResult *> *results, NSError *error) {
        if (error) {
            printE(@"%@",error.description);
            [self showErrorAlert:error.domain];
            return ;
        }
        
        printD(@"结果 %zd 条:",results.count);
        if (results.count <= 0) {
            [self showErrorAlert:[NSString stringWithFormat:@"识别属性数量为 %zd.",results.count]];
            return;
        }
        
        NSString *string = [StringHelper makeLazyCode:results];
        if (string.length <= 0) {
            printE(@"%@",@"懒加载代码生成失败!");
            [self showErrorAlert:@"懒加载代码生成失败!"];
            return;
        }
        
        // 保存当前内容到粘贴板
        NSPasteboard *_pasteBoard = [NSPasteboard generalPasteboard];
        [_pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
        [_pasteBoard setString:string forType:NSStringPboardType];
        
    }];
}


- (void)jump2LazyFormatSettingWindow{
    XLazySettingsWindowController *wc =[[XLazySettingsWindowController alloc] initWithWindowNibName:@"XLazySettingsWindowController"];
    [wc showWindow:wc];
    self.lazySettingsWC = wc;
}

- (void)showErrorAlert:(NSString *)msg{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText: [NSString stringWithFormat:@"生成代码失败..\n选定的代码文本格式错误或者其他原因.\n%@",msg]];
    [alert runModal];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
