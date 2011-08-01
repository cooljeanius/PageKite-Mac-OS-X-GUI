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
    [logTextView setFont: PAGEKITE_LOG_FONT];
    
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
    [logTextView setFont: PAGEKITE_LOG_FONT]; //make sure
    
    // scroll to bottom
    [logTextView scrollRangeToVisible: NSMakeRange([text length], 0)];
}

#pragma mark -
#pragma mark Respond to task notifications

- (void)taskOutputSTDOUTReceived: (NSString *)string;
{    
    [self appendToLog: [self logString: string withColor: [NSColor blackColor]]];
}

- (void)taskOutputSTDERRReceived: (NSString *)string;
{
    [self appendToLog: [self logString: string withColor: [NSColor redColor]]];
}

- (void)taskRunningChanged
{
    NSColor *color = [taskController running] ? PAGEKITE_GOOD_COLOR : PAGEKITE_ERR_COLOR;
    
    NSString *buttonTitle = [taskController running] ? @"Stop PageKite" : @"Start PageKite";
    [launchButton setTitle: buttonTitle];

    NSString *runningStr = [taskController running] ? @"YES" : @"NO";
    [runningTextField setAttributedStringValue: [self logString: runningStr withColor: color]];
    
    NSString *runningLogStr = [taskController running] ? @"PageKite running\n" : @"PageKite terminated\n";
    [self appendToLog: [self logString: runningLogStr withColor: color]];
}

- (void)taskConnectedChanged
{
    NSColor *color = [taskController connected] ? PAGEKITE_GOOD_COLOR : PAGEKITE_ERR_COLOR;
    
    NSString *connectedStr = [taskController connected] ? @"YES" : @"NO";
    [connectedTextField setAttributedStringValue: [self logString: connectedStr withColor: color]];
    
    NSString *connectedLogStr = [taskController connected] ? @"PageKite connected\n" : @"PageKite disconnected\n";
    [self appendToLog: [self logString: connectedLogStr withColor: color]];
}

#pragma mark -
#pragma mark Utility methods

- (NSAttributedString *)logString: (NSString *)string withColor: (NSColor *)color
{
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys: 
                          color,                            NSForegroundColorAttributeName,
                          PAGEKITE_LOG_FONT,                NSFontAttributeName,
                          nil];
    
    return [[NSAttributedString alloc] initWithString: string attributes: attr];
}



@end
