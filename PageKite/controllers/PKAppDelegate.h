//
//  PageKiteAppDelegate.h
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Common.h"
#import "STAppOnLogin.h"
#import "RCTextView.h"

@interface PKAppDelegate : NSObject
{
    // interface builder outlets
    IBOutlet id     runningMenuItem;
    IBOutlet id     toggleMenuItem;
    IBOutlet id     menu;
    
    BOOL            running;
    NSStatusItem    *statusItem;
    

    NSImage         *disabledIcon;
    NSImage         *enabledIcon;
    
    NSTask          *pkTask;
}

- (IBAction)togglePageKite: (id)sender;

- (void)updateInterface;

- (void)enablePageKite;
- (void)disablePageKite;

- (void)alert: (NSString *)message subText: (NSString *)subtext;
- (BOOL) proceedConfirmation: (NSString *)message subText: (NSString *)subtext withAction: (NSString *)action;

@end
