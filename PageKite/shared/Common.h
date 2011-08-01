//
//  Common.h
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

#define PAGEKITE_MACOSX_GUI_VERSION     @"0.4"

#define PAGEKITE_VERSION                @"0.4"
#define PAGEKITE_WEBSITE                @"http://pagekite.net"
#define PAGEKITE_RC_FILE_PATH           [@"~/.pagekite.rc" stringByExpandingTildeInPath]
#define PAGEKITE_FILENAME               @"pagekite.py"

// user interface
#define PAGEKITE_LOG_FONT               [NSFont fontWithName: @"Monaco" size: 10.0f]
#define PAGEKITE_RC_COMMENT_COLOR       [NSColor colorWithDeviceRed: 0.7 green: 0 blue:0 alpha: 1.0]
#define PAGEKITE_RC_END_COLOR           [NSColor colorWithDeviceRed: 0 green: 0.55 blue:0 alpha: 1.0]
#define PAGEKITE_RC_CONFIG_COLOR        [NSColor colorWithDeviceRed: 0 green: 0 blue: 0.5 alpha: 1]
#define PAGEKITE_ERR_COLOR              [NSColor redColor]
#define PAGEKITE_GOOD_COLOR             [NSColor colorWithDeviceRed: 0 green: 0.75 blue:0 alpha: 1.0]