//
//  STUtil.m
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


/*
 
 A Swiss Army Knife class with a plethora of generic utility functions
 
 */
#import "STUtil.h"
#import <CoreServices/CoreServices.h>

@implementation STUtil

+ (BOOL)runningSnowLeopardOrLater
{
    SInt32 major = 0;
    SInt32 minor = 0;   
    
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    
    if ((major >= 10 && minor >= 6))
        return TRUE;
        
    return FALSE;
}

+ (void)forceFront
{
    // force us to be front process if we run in background
	// This is so that apps that are set to run in the background will still have their
	// window come to the front.  It is to my knowledge the only way to make an
	// application with app bundle property LSUIElement set to true come to the front
	ProcessSerialNumber process;
	GetCurrentProcess(&process);
	SetFrontProcess(&process);
}

+ (void)alert: (NSString *)message subText: (NSString *)subtext
{
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText: message];
	[alert setInformativeText: subtext];
	[alert setAlertStyle:NSWarningAlertStyle];
	
	[alert runModal]; 
	[alert release];
}

+ (void)fatalAlert: (NSString *)message subText: (NSString *)subtext
{
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText: message];
	[alert setInformativeText: subtext];
	[alert setAlertStyle: NSCriticalAlertStyle];
	[alert runModal];
	[alert release];
	[[NSApplication sharedApplication] terminate: self];
}

+ (void)sheetAlert: (NSString *)message subText: (NSString *)subtext forWindow: (NSWindow *)window
{
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText: message];
	[alert setInformativeText: subtext];
	[alert setAlertStyle:NSCriticalAlertStyle];
	
	[alert beginSheetModalForWindow: window modalDelegate:self didEndSelector: nil contextInfo:nil];
	[alert release];
}

+ (BOOL)proceedConfirmation: (NSString *)message subText: (NSString *)subtext withAction: (NSString *)action;
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
