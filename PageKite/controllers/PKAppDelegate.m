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

- (id)init
{
    self = [super init];
    if (self) 
    {
        taskController = [[PKTaskController alloc] init];
        [taskController setDelegate: self];
    }
    return self;
}

- (void)dealloc
{
    [taskController release];
}

#pragma mark -
#pragma App Delegate functions

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
        [taskController startPageKite];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [taskController stopPageKite];
}

#pragma mark -
#pragma mark PageKite control

- (IBAction)togglePageKite: (id)sender
{
    if ([taskController running])
    {
        [taskController stopPageKite];
    }
    else
    {
        [taskController startPageKite];
    }
    [self updateInterface];
}

- (void)updateInterface
{
    NSString *runningStr = [taskController running] ? @"PageKit is running" : @"PageKit is not running";
    [runningMenuItem setTitle: runningStr];
    
    NSString *enableDisable = [taskController running] ? @"Turn PageKite Off" : @"Turn PageKite On";
    [toggleMenuItem setTitle: enableDisable];
    
    NSImage *icon = [taskController running] ? enabledIcon : disabledIcon;
    [statusItem setImage: icon];
}

- (void)taskStatusChanged: (int)status;
{
    NSLog(@"Task status changed");
    [self updateInterface];
}

#pragma mark -
#pragma mark Menu

- (void)menuWillOpen:(NSMenu *)menu
{
    [self updateInterface];
}

@end
