//
//  RCTextView.m
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 PageKite. All rights reserved.
//

#import "RCTextView.h"

@implementation RCTextView

- (void)setString:(NSString *)string
{
    [super setString: string];
    [self updateSyntaxColoring];
}

- (void)updateSyntaxColoring
{
    [self removeSyntaxColoring];
    
    // default blue
    [self setTextColor: [NSColor colorWithDeviceRed: 0 green: 0 blue: 0.5 alpha: 1] range: NSMakeRange(0, [[self string] length])];
    
    NSScanner* scanner = [NSScanner scannerWithString: [self string]];
    NSInteger start = 0, end = 0;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString: @"#" intoString: nil];
        start = [scanner scanLocation];
        [scanner scanUpToString: @"\n" intoString: nil];
        end = [scanner scanLocation];
        [self setTextColor: [NSColor colorWithDeviceRed: 0.7 green: 0 blue:0 alpha: 1.0] range: NSMakeRange(start, end-start)];
    }
    
    [scanner setScanLocation: 0];
    [scanner scanUpToString: @"\nEND\n" intoString: nil];
    start = [scanner scanLocation];
    
    [self setTextColor: [NSColor colorWithDeviceRed: 0 green: 0.55 blue:0 alpha: 1.0] range: NSMakeRange(start, [[self string] length]-start)];
}

- (void)removeSyntaxColoring
{
    [self setTextColor: nil range: NSMakeRange(0, [[self string] length])];
}

@end
