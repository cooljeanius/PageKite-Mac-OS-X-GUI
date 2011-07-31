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
    [STUtil forceFront];
    [window makeKeyAndOrderFront: self];
}

- (void)updateInterface
{
    
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
    
}

-(void)taskOutputReceived: (NSString *)string
{
    [self appendToLog: string];
}

- (void)taskRunningChanged
{
    NSString *buttonTitle = [taskController running] ? @"Stop PageKite" : @"Start PageKite";
    [launchButton setTitle: buttonTitle];
    NSString *runningStr = [taskController running] ? @"YES" : @"NO";
    [runningTextField setString: runningStr];
}

- (void)taskConnectedChanged
{
    NSString *connectedStr = [taskController connected] ? @"YES" : @"NO";
    [connectedTextField setString: connectedStr];
}


@end
