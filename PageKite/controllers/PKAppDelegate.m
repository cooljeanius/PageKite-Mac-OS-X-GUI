//
//  PageKiteAppDelegate.m
//  PageKite.app - Mac OS X GUI for PageKite
//
//  Copyright 2011 Sveinbjorn Thordarson.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//


#import "PKAppDelegate.h"

@implementation PKAppDelegate

+ (void)initialize 
{ 
	// create the user defaults here if none exists
    NSMutableDictionary *defaultPrefs = [NSMutableDictionary dictionary];
    [defaultPrefs setValue: [NSNumber numberWithBool: YES] forKey: @"StartOnLogin"];
    [defaultPrefs setValue: [NSNumber numberWithBool: YES] forKey: @"ConnectOnLogin"];
    
    // register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults: defaultPrefs];
    
    // user already has a pagekite rc file
    if ([[NSFileManager defaultManager] fileExistsAtPath: [PAGEKITE_RC_FILE_PATH stringByExpandingTildeInPath]])
    {
        
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    running = FALSE;
    
    // create status item
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
    
    // create icons and set menu
    disabledIcon = [NSImage imageNamed: @"pagekite-disabled.png"];	
    enabledIcon = [NSImage imageNamed: @"pagekite-enabled.png"];
    
	[statusItem setHighlightMode: TRUE];
	[statusItem setImage: disabledIcon];
	[statusItem setMenu: menu];

    // enable it
	[statusItem setEnabled: YES];
    
    // add to login items
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"StartOnLogin"])
        [STAppOnLogin addAppToLoginItems];
    else
        [STAppOnLogin removeAppFromLoginItems];

    // connect if settings dictate thus
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"ConnectOnLogin"])
        [self enablePageKite];
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

@end
