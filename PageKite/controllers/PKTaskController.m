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
@synthesize taskDelegate, logDelegate;

#pragma mark -

- (id)init
{
    self = [super init];
    if (self) 
    {
        running = FALSE;
        connected = FALSE;
    }
    return self;
}

#pragma mark -
#pragma mark Start/stop PageKite task

- (IBAction)togglePageKite: (id)sender
{
    if (running)
        [self stopPageKite];
    else
        [self startPageKite];
}


- (void)startPageKite
{
    NSLog(@"Launching PageKite task");
    
    // Create task
    pkTask = [[NSTask alloc] init];
    NSString *pkPath = [[NSBundle mainBundle] pathForResource: @"pagekite.py" ofType: nil]; 
    
    [pkTask setLaunchPath: @"/usr/bin/python"]; // default python interpreter path in Mac OS X
    [pkTask setArguments: [NSArray arrayWithObject: pkPath]];
    
    // Register to receive notification on task output to stdout and stderr
    
        //stdout
        stdoutPipe = [NSPipe pipe];
        [pkTask setStandardOutput: stdoutPipe];
       
        stdoutReadHandle = [stdoutPipe fileHandleForReading];
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(receivedTaskOutput:) 
                                                     name: NSFileHandleReadCompletionNotification 
                                                   object: stdoutReadHandle];
        [stdoutReadHandle readInBackgroundAndNotify];
        
        // stderrr
        stderrPipe = [NSPipe pipe];
        [pkTask setStandardError: stderrPipe];
        
        stderrReadHandle = [stderrPipe fileHandleForReading];
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(receivedTaskOutput:) 
                                                     name: NSFileHandleReadCompletionNotification 
                                                   object: stderrReadHandle];
        [stderrReadHandle readInBackgroundAndNotify];
        
    // Register to receive notifications on task termination
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(taskEnded:)
												 name: NSTaskDidTerminateNotification
											   object: NULL];
	
	//set it off
    [pkTask launch];
    
    [self setRunning: TRUE];
}

- (void)stopPageKite
{
    if (running)
        [pkTask terminate];
}

#pragma mark -
#pragma mark Receiving task notifications

- (void)taskEnded: (NSNotification *)aNotification
{
    NSLog(@"PageKite task terminated");
    [self setRunning: FALSE];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    if (pkTask)
        [pkTask release];
}

//  read from the file handle 
- (void)receivedTaskOutput: (NSNotification *)aNotification
{
	//get the data from notification
	NSData *data = [[aNotification userInfo] objectForKey: NSFileHandleNotificationDataItem];
	
	//make sure there's actual data
	if ([data length]) 
	{
		// we decode the script output as UTF8 string
        NSString *outputString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        
        if (outputString)
        {
            NSLog(outputString);
            // send output string to log delegate
            if ([aNotification object] == stderrReadHandle)
            {
                [logDelegate taskOutputSTDERRReceived: outputString];
                [outputString writeToFile: @"/dev/stdout" atomically: YES encoding: NSUTF8StringEncoding error: nil];
            }
            else
            {
                [logDelegate taskOutputSTDOUTReceived: outputString];
                [outputString writeToFile: @"/dev/stderr" atomically: YES encoding: NSUTF8StringEncoding error: nil];
            }
            
            //[outputString release];
        }
        
		// we schedule the file handle to go and read more data in the background again.
		[[aNotification object] readInBackgroundAndNotify];
	}
}

#pragma mark -
#pragma mark Running

- (BOOL)running
{
    return running;
}

- (void)setRunning: (BOOL)r
{
    running = r;
    [taskDelegate taskRunningChanged];
    [logDelegate taskRunningChanged];
}

#pragma mark -
#pragma mark Connected

- (BOOL)connected
{
    return connected;
}

- (void)setConnected: (BOOL)r
{
    connected = r;
    [taskDelegate taskConnectedChanged];
    [logDelegate taskConnectedChanged];
}

@end
