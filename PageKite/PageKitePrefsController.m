//
//  PrefsController.m
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageKitePrefsController.h"

@implementation PageKitePrefsController

- (IBAction)showPreferences: (id)sender
{
    NSString *rcFileContents = [NSString stringWithContentsOfFile: PAGEKITE_RC_FILE_PATH usedEncoding: nil error: nil];
    
    if (rcFileContents)
    {
        [configTextView setFont: [NSFont fontWithName: @"Monaco" size: 10.0]];
        [configTextView setString: rcFileContents];
    }
    
    // force us to be front process if we run in background
	// This is so that apps that are set to run in the background will still have their
	// window come to the front.  It is to my knowledge the only way to make an
	// application with app bundle property LSUIElement set to true come to the front
	ProcessSerialNumber process;
	GetCurrentProcess(&process);
	SetFrontProcess(&process);
    
    //show window
    [window makeKeyAndOrderFront: self];
}

- (IBAction)restoreDefaults:(id)sender
{
    if ([self proceedConfirmation: @"Restore defaults?" subText: @"This will overwrite any changes you may have made." withAction: @"Restore"])
    {
        // do something
    }
}

- (IBAction)applyPrefs:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue: [NSNumber numberWithBool: YES] forKey: @"StartOnLogin"];
    [defaults setValue: [NSNumber numberWithBool: YES] forKey: @"ConnectOnLogin"];
    
    
    // If config string has changed, write it to disk and save into defaults
    NSString *configFileStr = [[NSUserDefaults standardUserDefaults] objectForKey: @"ConfigFile"]; 
    
    NSString *configStr = [configTextView string];
    if (![configStr isEqualToString: configFileStr])
    {
        // set defaults
        [[NSUserDefaults standardUserDefaults] setObject: configStr forKey: @"ConfigFile"];
        // write changed string to config file
        NSError* error = nil;
        [configStr writeToFile: PAGEKITE_RC_FILE_PATH atomically: YES encoding:NSUTF8StringEncoding error: &error];
        if (error)
        {
            NSLog(@"error = %@", [error description]);
            [self alert: @"Error" subText: [NSString stringWithFormat: @"Error: %s", [error description]]];
        }
    }
    
    [window orderOut: self];
}

- (void)textDidChange:(NSNotification *)aNotification
{
    [restartCheckbox setHidden: (TRUE && TRUE)];
    [configTextView updateSyntaxColoring];
}


@end
