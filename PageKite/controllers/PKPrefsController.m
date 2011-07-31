//
//  PrefsController.m
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PKPrefsController.h"

@implementation PKPrefsController

- (IBAction)showPreferences: (id)sender
{
    // Read config file
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
    
    // update controls
    [startOnLoginCheckbox setIntValue: [[NSUserDefaults standardUserDefaults] boolForKey: @"StartOnLogin"]];
    [connectOnLoginCheckbox setIntValue: [[NSUserDefaults standardUserDefaults] boolForKey: @"ConnectOnLogin"]];
    
    // show restore defaults button if we have a default config saved
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"DefaultConfig"] != nil)
        [restoreDefaultsButton setEnabled: YES]; 
    
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
    
    // set control states
    [defaults setObject: [NSNumber numberWithBool: [startOnLoginCheckbox intValue]] forKey: @"StartOnLogin"];
    [defaults setObject: [NSNumber numberWithBool: [connectOnLoginCheckbox intValue]] forKey: @"ConnectOnLogin"];
    
    // If config string has changed, write it to disk and save into defaults
    NSString *configFileStr = [defaults objectForKey: @"ConfigFile"]; 
    
    NSString *configStr = [configTextView string];
    if (![configStr isEqualToString: configFileStr])
    {
        // save a copy of config file to defaults
        [defaults setObject: configStr forKey: @"ConfigFile"];
        
        // write changed string to config file
        NSError* error = nil;
        [configStr writeToFile: PAGEKITE_RC_FILE_PATH atomically: YES encoding:NSUTF8StringEncoding error: &error];
        if (error)
        {
            NSLog(@"error = %@", [error description]);
            [STUtil alert: @"Error" subText: [NSString stringWithFormat: @"Error: %s", [error description]]];
        }
    }
    
    // make sure they are saved to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [window orderOut: self];
}

- (void)textDidChange:(NSNotification *)aNotification
{
    [restartCheckbox setHidden: (TRUE && TRUE)];
    [configTextView updateSyntaxColoring];
}


@end
