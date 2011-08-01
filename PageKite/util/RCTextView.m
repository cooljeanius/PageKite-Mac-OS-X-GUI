//
//  RCTextView.m
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
    [self setTextColor: PAGEKITE_RC_CONFIG_COLOR range: NSMakeRange(0, [[self string] length])];
    
    NSScanner* scanner = [NSScanner scannerWithString: [self string]];
    NSInteger start = 0, end = 0;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString: @"#" intoString: nil];
        start = [scanner scanLocation];
        [scanner scanUpToString: @"\n" intoString: nil];
        end = [scanner scanLocation];
        [self setTextColor: PAGEKITE_RC_COMMENT_COLOR range: NSMakeRange(start, end-start)];
    }
    
    [scanner setScanLocation: 0];
    [scanner scanUpToString: @"\nEND\n" intoString: nil];
    start = [scanner scanLocation];
    
    [self setTextColor: PAGEKITE_RC_END_COLOR range: NSMakeRange(start, [[self string] length]-start)];
}

- (void)removeSyntaxColoring
{
    [self setTextColor: nil range: NSMakeRange(0, [[self string] length])];
}

@end
