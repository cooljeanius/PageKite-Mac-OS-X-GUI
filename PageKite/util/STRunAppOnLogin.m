//
//  STAppLoginLaunch.m
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



#import "STRunAppOnLogin.h"


@implementation STRunAppOnLogin

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

+ (BOOL)removeAppFromLoginItems
{
	//if ([self loginItemExistsWithLoginItemReference: 
	
	return YES;
}

+ (NSArray *)getLoginItemsListArray
{
	// Some seed data
	UInt32 seedValue;
	
	// Let's create reference to shared file list
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	// Then just pop values from referenced list into array
	NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
	
	return loginItemsArray;
}

+ (BOOL)loginItemExistsWithLoginItemReference:(LSSharedFileListRef)theLoginItemsRefs forPath:(CFURLRef)thePath 
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
