//
//  PageKiteAppDelegate.h
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

#import <Cocoa/Cocoa.h>
#import "Common.h"
#import "STAppOnLogin.h"
#import "RCTextView.h"
#import "PKTaskController.h"

@interface PKAppDelegate : NSObject <PKTaskDelegate>
{
    // interface builder outlets
    IBOutlet id         runningMenuItem;
    IBOutlet id         toggleMenuItem;
    IBOutlet id         menu;
    
    NSStatusItem        *statusItem;
    IBOutlet id         taskController;

    NSImage             *disabledIcon;
    NSImage             *enabledIcon;    
}

- (IBAction)togglePageKite: (id)sender;
- (void)updateInterface;
@end
