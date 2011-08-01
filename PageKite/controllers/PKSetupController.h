//
//  PKSetupController.h
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

@interface PKSetupController : NSWindowController
{
    IBOutlet id     emailTextField;
    IBOutlet id     pageNameTextField;
    IBOutlet id     termsOfServiceCheckbox;
    IBOutlet id     actionRadioButtons;
}
-(IBAction)continueSetup:(id)sender;
-(IBAction)showTermsOfService:(id)sender;

@end
