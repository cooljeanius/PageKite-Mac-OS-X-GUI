//
//  PageKiteAppDelegate.m
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/29/11.
//  Copyright 2011 PageKite. All rights reserved.
//

#import "PageKiteAppDelegate.h"

@implementation PageKiteAppDelegate

+ (void)initialize 
{ 
	// create the user defaults here if none exists
    NSMutableDictionary *defaultPrefs = [NSMutableDictionary dictionary];
    [defaultPrefs setValue: [NSNumber numberWithBool: YES] forKey: @"StartOnLogin"];
    [defaultPrefs setValue: [NSNumber numberWithBool: YES] forKey: @"ConnectOnLogin"];
    
    // register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults: defaultPrefs];
    
    [STAppOnLogin addAppToLoginItems];
    
    // user already has a pagekite rc file
    if ([[NSFileManager defaultManager] fileExistsAtPath: [PAGEKITE_RC_FILE_PATH stringByExpandingTildeInPath]])
    {
        
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    running = FALSE;
    
    // Create status item
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
    
    // Create icons and set menu
    disabledIcon = [NSImage imageNamed: @"pagekite-disabled.png"];	
    enabledIcon = [NSImage imageNamed: @"pagekite-enabled.png"];
    
	[statusItem setHighlightMode: TRUE];
	[statusItem setImage: disabledIcon];
	[statusItem setMenu: menu];

    // enable it
	[statusItem setEnabled: YES];
}


- (IBAction)togglePageKite: (id)sender
{
    if (running)
    {
        [self disablePageKite];
    }
    else
    {
        [self enablePageKite];
    }
    running = !running;
    [self updateInterface];
}

- (void)updateInterface
{
    NSString *runningStr = running ? @"PageKit is running" : @"PageKit is not running";
    [runningMenuItem setTitle: runningStr];
    
    NSString *enableDisable = running ? @"Turn PageKite Off" : @"Turn PageKite On";
    [toggleMenuItem setTitle: enableDisable];
    
    NSImage *icon = running ? enabledIcon : disabledIcon;
    [statusItem setImage: icon];
}

- (void)enablePageKite
{
    // Register to receive notifications on task termination
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(pageKiteEnded:)
												 name: NSTaskDidTerminateNotification
											   object: NULL];
        
    pkTask = [[NSTask alloc] init];
    
    NSString *pkPath = [[NSBundle mainBundle] pathForResource: @"pagekite.py" ofType: nil]; 
    
    [pkTask setLaunchPath: @"/usr/bin/python"];
    [pkTask setArguments: [NSArray arrayWithObject: pkPath]];
    [pkTask launch];
}

- (void)disablePageKite
{
    [pkTask terminate];
    [pkTask release];
}

- (void)pageKiteEnded: (NSNotification *)aNotification
{
    
}

#pragma -
#pragma Utility functions

- (void)alert: (NSString *)message subText: (NSString *)subtext
{
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText: message];
	[alert setInformativeText: subtext];
	[alert setAlertStyle:NSWarningAlertStyle];
	
	[alert runModal]; 
	[alert release];
}

- (BOOL) proceedConfirmation: (NSString *)message subText: (NSString *)subtext withAction: (NSString *)action
{
    BOOL confirmed = FALSE;

	NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle: action];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setMessageText: message];
	[alert setInformativeText: subtext];
	[alert setAlertStyle: NSWarningAlertStyle];
	
	if ([alert runModal] == NSAlertFirstButtonReturn) 
        confirmed = YES;
    
    [alert release];
	return confirmed;
}


@end
