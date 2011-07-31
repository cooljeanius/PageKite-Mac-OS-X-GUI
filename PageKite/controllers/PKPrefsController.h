//
//  PrefsController.h
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 PageKite. All rights reserved.
//

#import "Common.h"
#import "STUtil.h"

@interface PKPrefsController : NSObject
{
    IBOutlet id     window;
    IBOutlet id     configTextView;
    IBOutlet id     restartCheckbox;
    IBOutlet id     startOnLoginCheckbox;
    IBOutlet id     connectOnLoginCheckbox;
    IBOutlet id     restoreDefaultsButton;
}
- (IBAction)showPreferences: (id)sender;
- (IBAction)applyPrefs: (id)sender;

@end
