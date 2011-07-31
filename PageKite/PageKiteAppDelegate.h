//
//  PageKiteAppDelegate.h
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STAppLoginLaunch.h"

#define PAGEKITE_RC_FILE_PATH [@"~/.pagekite.rc" stringByExpandingTildeInPath]


@interface PageKiteAppDelegate : NSObject
{
    // interface builder outlets
    IBOutlet id     runningMenuItem;
    IBOutlet id     toggleMenuItem;
    IBOutlet id     menu;
    IBOutlet id     window;
    IBOutlet id     configTextField;
    IBOutlet id     restartCheckbox;
    
    BOOL            running;
    NSStatusItem    *statusItem;
    

    NSImage         *disabledIcon;
    NSImage         *enabledIcon;
    
    NSTask          *pkTask;
}
- (IBAction)showPreferences: (id)sender;

- (IBAction)togglePageKite: (id)sender;

- (IBAction)applyPrefs: (id)sender;


- (void)updateInterface;

- (void)enablePageKite;
- (void)disablePageKite;

- (void)alert: (NSString *)message subText: (NSString *)subtext;
- (BOOL) proceedConfirmation: (NSString *)message subText: (NSString *)subtext withAction: (NSString *)action;

@end
