//
//  PKSetupController.m
//  PageKite
//
//  Created by Sveinbjorn Thordarson on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PKSetupController.h"

@implementation PKSetupController

- (id)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

-(IBAction)continueSetup:(id)sender
{
    
}

-(IBAction)showTermsOfService:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: PAGEKITE_TERMS_OF_SERVICE_URL]];
}
@end
