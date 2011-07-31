//
//  STAppLoginLaunch.m
//  MenuSmith
//
//  Created by Sveinbjorn Thordarson on 6/13/10.
//  Copyright 2010 Sveinbjorn Thordarson. All rights reserved.
//

#import "STAppOnLogin.h"


@implementation STAppOnLogin

+ (NSString *)appPath
{
	return [[NSBundle mainBundle] bundlePath];
}

+ (BOOL)addAppToLoginItems
{
	// Reference to shared file list
	LSSharedFileListRef theLoginItemsRefs = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	// CFURLRef to the insertable item.
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath: [self appPath]];
	
	// Actual insertion of an item.
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(theLoginItemsRefs, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
	
	// Clean up in case of success
	if (item) 
		CFRelease(item);
	
	return YES;
}

- (BOOL)removeAppFromLoginItems
{
	//if ([self loginItemExistsWithLoginItemReference: 
	
	return YES;
}

- (NSArray *)getLoginItemsListArray
{
	// Some seed data
	UInt32 seedValue;
	
	// Let's create reference to shared file list
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	// Then just pop values from referenced list into array
	NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
	
	return loginItemsArray;
}

- (BOOL)loginItemExistsWithLoginItemReference:(LSSharedFileListRef)theLoginItemsRefs forPath:(CFURLRef)thePath 
{
	BOOL exists = NO;  
	UInt32 seedValue;
	
	// We're going to grab the contents of the shared file list (LSSharedFileListItemRef objects)
	// and pop it in an array so we can iterate through it to find our item.
	NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);  
	for (id item in loginItemsArray) 
	{    
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
			if ([[(NSURL *)thePath path] hasPrefix:@"/Applications/MyApp.app"])
				exists = YES;
		}
		
	}
	return exists;
}	
@end
