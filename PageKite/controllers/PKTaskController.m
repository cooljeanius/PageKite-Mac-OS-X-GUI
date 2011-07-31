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
@synthesize running, delegate;

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}


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
    NSLog(@"Launched PageKite task");
    running = TRUE;
    [delegate taskStatusChanged];
}

- (void)disablePageKite
{
    [pkTask terminate];
    [pkTask release];
    running = FALSE;
}

- (void)pageKiteEnded: (NSNotification *)aNotification
{
    NSLog(@"PageKite terminated");
    [delegate taskStatusChanged];
}


@end
