//
//  PKLogController.m
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PKLogController.h"

@implementation PKLogController

- (IBAction)showLogWindow: (id)sender
{
    NSLog(@"Showign log window");
    
    // Configure text view
    [logTextView setFont: [NSFont fontWithName: @"Monaco" size: 10.0]];
    
    [STUtil forceFront];
    [window makeKeyAndOrderFront: self];
}

- (void)clearLog
{
    [logTextView setString: @""];
}

- (void)setLog: (NSString *)string
{
    [logTextView setString: string];
}

- (void)appendToLog: (NSString *)string
{
    // append the ouput to the text storage in the text field
    // this is the fastest way
	NSTextStorage *text = [logTextView textStorage];
	[text replaceCharactersInRange: NSMakeRange([text length], 0) withString: string];
    [logTextView setFont: [NSFont fontWithName: @"Monaco" size: 10.0]];
    [logTextView scrollRangeToVisible: NSMakeRange([text length], 0)];
}

- (void)taskOutputReceived: (NSString *)string
{
    [self appendToLog: string];
}

- (void)taskRunningChanged
{
    NSString *buttonTitle = [taskController running] ? @"Stop PageKite" : @"Start PageKite";
    [launchButton setTitle: buttonTitle];
    NSString *runningStr = [taskController running] ? @"YES" : @"NO";
    [runningTextField setStringValue: runningStr];
}

- (void)taskConnectedChanged
{
    NSString *connectedStr = [taskController connected] ? @"YES" : @"NO";
    [connectedTextField setStringValue: connectedStr];
}


@end
