//
//  PageKiteTaskController.m
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

#import "PKTaskController.h"

@implementation PKTaskController
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) 
    {
        running = FALSE;
    }
    return self;
}

#pragma mark -
#pragma Start/stop PageKite task

- (void)startPageKite
{
    NSLog(@"Launching PageKite task");
    
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
    
    [self setRunning: TRUE];
}

- (void)stopPageKite
{
    [pkTask terminate];
}

- (void)pageKiteEnded: (NSNotification *)aNotification
{
    NSLog(@"PageKite task terminated");
    [self setRunning: FALSE];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark -
#pragma Running

- (BOOL)running
{
    return running;
}

- (void)setRunning: (BOOL)r
{
    running = r;
    [delegate taskStatusChanged];
}

#pragma mark -
#pragma Connected

- (BOOL)connected
{
    return connected;
}

- (void)setConnected: (BOOL)r
{
    connected = r;
    [delegate taskStatusChanged];
}

@end
