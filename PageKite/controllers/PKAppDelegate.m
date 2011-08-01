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
    [defaultPrefs setValue: [NSNumber numberWithBool: NO] forKey: @"ShowLogOnStart"];
    
    // register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults: defaultPrefs];
    
    // user already has a pagekite rc file
    if ([[NSFileManager defaultManager] fileExistsAtPath: [PAGEKITE_RC_FILE_PATH stringByExpandingTildeInPath]])
    {
        
    }
}

// called on launch completion
- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    // add to login items
    if ([DEFAULTS boolForKey: @"StartOnLogin"])
        [STRunAppOnLogin addAppToLoginItems];
    else
        [STRunAppOnLogin removeAppFromLoginItems];

    // connect if settings dictate thus
    if ([DEFAULTS boolForKey: @"ConnectOnLogin"])
        [taskController startPageKite];
}

// called on application termination
- (void)applicationWillTerminate: (NSNotification *)aNotification
{
    [taskController stopPageKite];
}

@end
