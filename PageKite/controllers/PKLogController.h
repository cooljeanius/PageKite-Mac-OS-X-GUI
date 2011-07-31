//
//  PKLogController.h
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PKTaskController.h"

@interface PKLogController : NSObject <PKTaskLogDelegate>
{
    IBOutlet id     window;
    IBOutlet id     launchButton;
    IBOutlet id     runningTextField;
    IBOutlet id     connectedTextField;
    IBOutlet id     logTextView;
}
-(void)updateInterface;
-(void)clearLog;
-(void)appendToLog: (NSString *)string;
-(void)setLog: (NSString *)string;
@end
