//
//  PKLogController.m
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PKLogController.h"

@implementation PKLogController

-(void)updateInterface
{
    
}

-(void)clearLog
{
    [logTextView setString: @""];
}

-(void)appendToLog: (NSString *)string
{
    
}

-(void)setLog: (NSString *)string
{
    [logTextView setString: string];
}

@end
