//
//  PKLogController.h
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PKTaskController.h"
#import "STUtil.h"

@interface PKLogController : NSObject <PKTaskLogDelegate>
{
    IBOutlet id     window;
    IBOutlet id     launchButton;
    IBOutlet id     runningTextField;
    IBOutlet id     connectedTextField;
    IBOutlet id     logTextView;
    IBOutlet id     runningProgressIndicator;
    IBOutlet id     taskController;
}
- (IBAction)showLogWindow: (id)sender;
- (IBAction)clearLog: (id)sender;
- (void)setLog: (NSString *)string;
- (void)appendToLog: (NSAttributedString *)string;

- (NSAttributedString *)logString: (NSString *)string withColor: (NSColor *)color;
@end
