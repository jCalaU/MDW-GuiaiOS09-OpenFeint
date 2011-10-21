//  Copyright 2009-2010 Aurora Feint, Inc.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  	http://www.apache.org/licenses/LICENSE-2.0
//  	
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "OFFacebookAccountLoginController.h"

#import "OFProvider.h"
#import "OFISerializer.h"
#import "OFProvider.h"
#import "OFControllerLoaderObjC.h"
#import "OFShowMessageAndReturnController.h"

#import "OpenFeint+Private.h"
#import "OpenFeint+UserOptions.h"
#import "OFImageLoader.h"
#import "OFFormControllerHelper+Overridables.h"
#import "OFFormControllerHelper+Submit.h"
#import "OFDependencies.h"

@implementation OFFacebookAccountLoginController

@synthesize findFriendsLabel, controllerToPopTo, successfulExtendedCredentialsDialog;

- (void)viewWillAppear:(BOOL)animated
{
	if (!self.addingAdditionalCredential)
	{
		CGRect disclosureRect = self.privacyDisclosure.frame;
		disclosureRect.origin.y = self.findFriendsLabel.frame.origin.y;
		self.privacyDisclosure.frame = disclosureRect;
		findFriendsLabel.hidden = YES;
	}
	
	[super viewWillAppear:animated];
}

- (void)populateViewDataMap:(NSMutableDictionary*)dataMap
{	
}

- (void)addHiddenParameters:(NSObject<OFISerializer>*)parameterStream
{
	[super addHiddenParameters:parameterStream];
	
	NSString* facebookUId = [NSString stringWithFormat:@"%lld", self.fbuid];
	NSString* facebookSessionKey = [self.fbSession sessionKey];
	if(self.fbSession == nil)
	{
		facebookSessionKey = @"";
	}

	[parameterStream ioNSStringToKey:@"credential[fbuid]" object:facebookUId];
    [parameterStream ioNSStringToKey:@"credential[session_key]" object:facebookSessionKey];
	
	if (self.addingAdditionalCredential)
	{
		//The user now has to press the send button for every notification, so stream integration should always be on
        [parameterStream ioNSStringToKey:@"enable_stream_integration" object:@"true"];
	}
}

- (NSString*)singularResourceName
{
	return self.addingAdditionalCredential ? @"users_credential" : @"credential";
}

- (NSString*)_getFormSubmissionUrl
{
	return self.addingAdditionalCredential ? @"users_credentials.xml" : @"session.xml";
}

- (void)_session:(OFFBSession*)session didLogin:(FBUID)uid
{
	[self onSubmitForm:nil];
}

- (NSString*)getLoadingScreenText
{
	return self.addingAdditionalCredential ? @"Connecting To Facebook" : @"Logging In To OpenFeint";
}

- (OFShowMessageAndReturnController*)controllerToPushOnCompletion
{
	// Can assume that facebook authorization was successful.
	[OpenFeint setLoggedInUserHasFbconnectCredential:YES];  // Update the local option flag to reflect success.  [Joe]
	
	OFShowMessageAndReturnController* nextController;
	if (self.addingAdditionalCredential)
	{
		nextController =  (OFShowMessageAndReturnController*)[[OFControllerLoaderObjC loader] load:@"ShowMessageAndReturn"];// load(@"ShowMessageAndReturn");
		nextController.messageTitleLabel.text = OFLOCALSTRING(@"Connected to Facebook");
		nextController.messageLabel.text = OFLOCALSTRING(@"Your OpenFeint account is now connected to Facebook. Any of your Facebook friends with OpenFeint will be added to your My Friends list.");
		nextController.title = OFLOCALSTRING(@"Finding Friends");
	}
	else
	{
		nextController = [super getStandardLoggedInController];
	}	
	return nextController;
}

- (BOOL)isComplete
{
	return isComplete;
}

- (void)onAfterFormSubmitted
{
	isComplete = self.getPostingPermission ? updateServerPostingPermissions : YES;
	[super onAfterFormSubmitted];
}

- (void)dialogDidSucceed:(OFTFBDialog*)dialog
{
	if(loginDialog == dialog)
		return;
	
	if(initialFormHasBeenSubmitted)
	{
		[super dialogDidSucceed:dialog];
	}
	else
	{
		self.successfulExtendedCredentialsDialog = dialog;
		wantToUpdatePostingPermissions = YES;	
	}
}

- (void)onFormSubmitted:(id)resources
{
	[super onFormSubmitted:resources];
	if(wantToUpdatePostingPermissions)
	{
		wantToUpdatePostingPermissions = NO;
		[super dialogDidSucceed:self.successfulExtendedCredentialsDialog];
		self.successfulExtendedCredentialsDialog = nil;
	}
	initialFormHasBeenSubmitted = YES;
}

- (UIViewController*)getControllerToPopTo
{
	return self.controllerToPopTo ? self.controllerToPopTo : [super getControllerToPopTo];
}

- (void)dialogDidCancel:(OFTFBDialog*)dialog
{
	[super dialogDidCancel:dialog];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)dealloc
{
	self.findFriendsLabel = nil;
	self.controllerToPopTo = nil;
	[super dealloc];
}
@end
