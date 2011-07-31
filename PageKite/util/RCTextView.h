//
//  RCTextView.h
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 PageKite. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface RCTextView : NSTextView
{
    
}
- (void)updateSyntaxColoring;
- (void)removeSyntaxColoring;

@end
