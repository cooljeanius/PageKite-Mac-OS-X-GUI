//
//  PrefsController.m
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

#import "PKPrefsController.h"

@implementation PKPrefsController

- (IBAction)showPreferences: (id)sender
{    
    if ([window isVisible])
    {
        [STUtil forceFront];
        [window makeKeyAndOrderFront: self];
    }
        
    // Read config file
    NSString *rcFileContents = [NSString stringWithContentsOfFile: PAGEKITE_RC_FILE_PATH usedEncoding: nil error: nil];
    
    // Configure text view
    [configTextView setFont: PAGEKITE_LOG_FONT];
    [configTextView setString: rcFileContents];
    
    // update controls
    [startOnLoginCheckbox setIntValue: [DEFAULTS boolForKey: @"StartOnLogin"]];
    [connectOnLoginCheckbox setIntValue: [DEFAULTS boolForKey: @"ConnectOnLogin"]];
    [showLogOnStartCheckbox setIntValue: [DEFAULTS boolForKey: @"ShowLogOnStart"]];
    
    // show restore defaults button if we have a default config saved
    if ([DEFAULTS objectForKey: @"DefaultConfig"] != nil)
        [restoreDefaultsButton setEnabled: YES]; 
    
    // hack to force LSUIElement==1 apps to the front
    [STUtil forceFront];
    
    // show window
    [window makeKeyAndOrderFront: self];
}

- (IBAction)restoreDefaults:(id)sender
{
    if ([STUtil proceedConfirmation: @"Restore defaults?" subText: @"This will overwrite any changes you may have made." withAction: @"Restore"])
    {
        // do something
    }
}

- (IBAction)applyPrefs:(id)sender
{    
    // set control states
    [DEFAULTS setObject: [NSNumber numberWithBool: [startOnLoginCheckbox intValue]] forKey: @"StartOnLogin"];
    [DEFAULTS setObject: [NSNumber numberWithBool: [connectOnLoginCheckbox intValue]] forKey: @"ConnectOnLogin"];
    [DEFAULTS setObject: [NSNumber numberWithBool: [showLogOnStartCheckbox intValue]] forKey: @"ShowLogOnStart"];
    
    // If config string has changed, write it to disk and save into defaults
    NSString *configFileStr = [DEFAULTS objectForKey: @"ConfigFile"]; 
    
    NSString *configStr = [configTextView string];
    if (![configStr isEqualToString: configFileStr])
    {
        // save a copy of config file to defaults
        [DEFAULTS setObject: configStr forKey: @"ConfigFile"];
        
        // write changed string to config file
        NSError* error = nil;
        [configStr writeToFile: PAGEKITE_RC_FILE_PATH atomically: YES encoding:NSUTF8StringEncoding error: &error];
        if (error)
        {
            NSLog(@"error = %@", [error description]);
            [STUtil alert: @"Error" subText: [NSString stringWithFormat: @"Error: %s", [error description]]];
        }
    }
    
    // add to login items
    if ([DEFAULTS boolForKey: @"StartOnLogin"])
        [STRunAppOnLogin addAppToLoginItems];
    else
        [STRunAppOnLogin removeAppFromLoginItems];
    
    // make sure defaults are saved to disk
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [window orderOut: self];
}

- (void)textDidChange:(NSNotification *)aNotification
{
    //[restartCheckbox setHidden: (TRUE && TRUE)];
    [(RCTextView *)configTextView updateSyntaxColoring];
}


@end
