////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 
///  Copyright 2009 Aurora Feint, Inc.
/// 
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///  
///  	http://www.apache.org/licenses/LICENSE-2.0
///  	
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
/// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "OFInviteNotificationController.h"
#import "OpenFeint.h"
#import "OpenFeint+Private.h"
#import "OFControllerLoaderObjC.h"
#import "OFImageView.h"

@implementation OFInviteNotificationController

@synthesize headerText, notificationText, userIcon, bgImage;

- (void)viewDidLoad
{
	UIImage* orig = bgImage.image;
	bgImage.image = [orig stretchableImageWithLeftCapWidth:orig.size.width/2.0f topCapHeight:orig.size.height/2.0f];
	bgImage.contentMode = UIViewContentModeScaleToFill;
}

- (IBAction)dismiss
{
	[OpenFeint dismissDashboard];
}

- (void)dealloc {
	headerText = nil;
	notificationText = nil;
	userIcon = nil;
	bgImage = nil;
    [super dealloc];
}

+ (void)showInviteNotification:(NSString*)notificationText withUser:(OFUser*)user withHeaderText:(NSString*)headerText
{
	OFInviteNotificationController* controller = (OFInviteNotificationController*)[[OFControllerLoaderObjC loader] load:@"InviteNotification"];// load(@"InviteNotification");
	
	controller.headerText.text = headerText;
	controller.notificationText.text = notificationText;
	[controller.userIcon useProfilePictureFromUser:user];
	
	[OpenFeint presentModalOverlay:controller];
}

@end
