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

- (void)restartPageKite
{
    [self stopPageKite];
    [self performSelector: @selector(startPageKite) withObject: nil afterDelay: 0.4];
}

- (void)startPageKite
{
    NSLog(@"Launching PageKite task");
    
    // Create task
    pkTask = [[NSTask alloc] init];
    NSString *pkPath = [[NSBundle mainBundle] pathForResource: PAGEKITE_FILENAME ofType: nil]; 
    if (!pkTask || !pkPath)
        [STUtil alert: @"Error launching task" subText: [NSString stringWithFormat: @"Couldn't execute '%s'", PAGEKITE_FILENAME]];
    
    [pkTask setLaunchPath: @"/usr/bin/python"];
    [pkTask setArguments: [NSArray arrayWithObjects: pkPath, @"--remoteui", nil]];
    
    // Capture all program output in filehandles
    // Then register to receive notification on task output to stdout and stderr
    
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
    
    // Register for termination notification
    [[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(taskEnded:)
												 name: NSTaskDidTerminateNotification
											   object: NULL];
	//set it off
    [self setRunning: TRUE];
    [pkTask launch];
}

- (void)stopPageKite
{
    if (running)
    {
        NSLog(@"Stopping PageKite");
        [pkTask terminate];
    }
}

#pragma mark -
#pragma mark Receiving task notifications

- (void)taskEnded: (NSNotification *)aNotification
{
    NSLog(@"PageKite task terminated");
    [self setRunning: FALSE];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
	// We make sure to clear the output filehandles of any remaining data
    if (stdoutReadHandle != NULL)
	{
		NSData *data;
		while ((data = [stdoutReadHandle availableData]) && [data length])
			[self sendOutputToLogDelegate: data forFileHandle: stdoutReadHandle];
	}
    
	if (stderrReadHandle != NULL)
	{
		NSData *data;
		while ((data = [stderrReadHandle availableData]) && [data length])
			[self sendOutputToLogDelegate: data forFileHandle: stderrReadHandle];
	}
    
    if (pkTask)
        [pkTask release];
}

//  read from the file handle 
- (void)receivedTaskOutput: (NSNotification *)aNotification
{
	//get the data from notification
	NSData *data = [[aNotification userInfo] objectForKey: NSFileHandleNotificationDataItem];
	
    // notify delegate and send it data
    [self sendOutputToLogDelegate: data forFileHandle: [aNotification object]];
        
    // we schedule the file handle to go and read more data in the background again.
    [[aNotification object] readInBackgroundAndNotify];
}

- (void)sendOutputToLogDelegate: (NSData *)data forFileHandle: (NSFileHandle *)fh
{
    // make sure we're receiving something we can work with
    if (!data || (fh != stderrReadHandle && fh != stdoutReadHandle))
        return;
    
    // we decode the output as UTF8 string
    NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    // send output string to log delegate
    // dump to /dev/stdout or /dev/stderr to be good citizens
    if (fh == stderrReadHandle)
    {
        [logDelegate taskOutputSTDERRReceived: string];
        [string writeToFile: @"/dev/stdout" atomically: YES encoding: NSUTF8StringEncoding error: nil];
    }
    else if (fh == stdoutReadHandle)
    {
        [logDelegate taskOutputSTDOUTReceived: string];
        [string writeToFile: @"/dev/stderr" atomically: YES encoding: NSUTF8StringEncoding error: nil];
    }
    
    [string release];
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
