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

#pragma mark -
#pragma mark Manipulate log contents

- (IBAction)clearLog: (id)sender;
{
    [logTextView setString: @""];
}

- (void)setLog: (NSString *)string
{
    [logTextView setString: string];
}

- (void)appendToLog: (NSAttributedString *)string
{
    // append the ouput to the text storage in the text field
    // this is by far the fastest way
	NSTextStorage *text = [logTextView textStorage];
	[text replaceCharactersInRange: NSMakeRange([text length], 0) withAttributedString: string];
    [logTextView setFont: [NSFont fontWithName: @"Monaco" size: 10.0]];
    
    // scroll to bottom
    [logTextView scrollRangeToVisible: NSMakeRange([text length], 0)];
}

#pragma mark -
#pragma mark Respond to task notifications

- (void)taskOutputSTDOUTReceived: (NSString *)string;
{
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys: 
                          [NSColor blackColor],             NSForegroundColorAttributeName,
                          [NSFont menuFontOfSize: 10.0f],    NSFontAttributeName,
                          nil];
    
    NSAttributedString *attrStr = [[[NSAttributedString alloc] initWithString: string attributes: attr] autorelease];
    
    NSLog(@"Received stdout");
    [self appendToLog: attrStr];
}

- (void)taskOutputSTDERRReceived: (NSString *)string;
{
    // if stderr, we make the string red
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys: 
                          [NSColor redColor],               NSForegroundColorAttributeName,
                          [NSFont menuFontOfSize: 10.0f],    NSFontAttributeName,
                          nil];
    
    NSAttributedString *attrStr = [[[NSAttributedString alloc] initWithString: string attributes: attr] autorelease];
    
    NSLog(@"Received stderr");
    [self appendToLog: attrStr];
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
