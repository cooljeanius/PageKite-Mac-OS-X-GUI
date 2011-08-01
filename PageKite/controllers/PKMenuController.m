//
//  PKMenuController.m
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

#import "PKMenuController.h"

@implementation PKMenuController

- (id)init
{
    self = [super init];
    if (self) 
    {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    // create status item
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
    [statusItem setHighlightMode: TRUE];
    [statusItem setImage: [NSImage imageNamed: @"pagekite-disabled.png"]];
    [statusItem setMenu: menu];
    [statusItem setEnabled: YES];
}

-(void)dealloc
{
    [statusItem release];
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
#pragma mark Setup

- (IBAction)showSetup: (id)sender
{
    
}

- (IBAction)showPreferences:(id)sender
{
    NSLog(@"Showing prefs");
    [[PKPrefsController alloc] initWithWindowNibName: @"Preferences"];
}

#pragma mark -
#pragma mark Task delegate methods

- (void)taskRunningChanged
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
