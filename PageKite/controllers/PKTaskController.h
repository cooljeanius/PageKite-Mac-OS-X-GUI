//
//  PageKiteTaskController.h
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

@protocol PKTaskDelegate <NSObject>
- (void)taskRunningChanged;
- (void)taskConnectedChanged;
@end

@protocol PKTaskLogDelegate <NSObject>
- (void)taskRunningChanged;
- (void)taskConnectedChanged;
- (void)taskOutputReceived: (NSString *)string;
@end


@interface PKTaskController : NSObject
{
    BOOL                running;
    BOOL                connected;
    NSTask              *pkTask;
    id                  taskDelegate;
    id                  logDelegate;
}
@property (readwrite, assign) id taskDelegate;
@property (readwrite, assign) id logDelegate;

- (void)startPageKite;
- (void)stopPageKite;

- (BOOL)running;
- (void)setRunning: (BOOL)r;
- (BOOL)connected;
- (void)setConnected: (BOOL)r;

@end
