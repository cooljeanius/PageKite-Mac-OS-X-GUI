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

#pragma mark -
#pragma mark App Delegate functions

// called first time application is run
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

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    // create status item
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
	[statusItem setHighlightMode: TRUE];
	[statusItem setImage: [NSImage imageNamed: @"pagekite-disabled.png"]];
	[statusItem setMenu: menu];
	[statusItem setEnabled: YES];
    
    // add to login items
    if ([DEFAULTS boolForKey: @"StartOnLogin"])
        [STRunAppOnLogin addAppToLoginItems];
    else
        [STRunAppOnLogin removeAppFromLoginItems];

    // connect if settings dictate thus
    if ([DEFAULTS boolForKey: @"ConnectOnLogin"])
        [taskController startPageKite];
}

- (void)applicationWillTerminate: (NSNotification *)aNotification
{
    [taskController stopPageKite];
}

#pragma mark -
#pragma mark PageKite control

- (void)updateInterface
{
    NSString *runningStr = [taskController running] ? @"PageKit is running" : @"PageKit is not running";
    [runningMenuItem setTitle: runningStr];
    
    NSString *enableDisable = [taskController running] ? @"Turn PageKite Off" : @"Turn PageKite On";
    [toggleMenuItem setTitle: enableDisable];
    
    NSString *iconName = [taskController running] ? @"pagekite-enabled.png" : @"pagekite-disabled.png";
    [statusItem setImage: [NSImage imageNamed: iconName]];
}

#pragma mark -
#pragma mark Task delegate methods

- (void)taskRunningChanged;
{
    [self updateInterface];
}

- (void)taskConnectedChanged;
{
    [self updateInterface];
}

#pragma mark -
#pragma mark Menu

- (void)menuWillOpen: (NSMenu *)menu
{
    [self updateInterface];
}

@end
