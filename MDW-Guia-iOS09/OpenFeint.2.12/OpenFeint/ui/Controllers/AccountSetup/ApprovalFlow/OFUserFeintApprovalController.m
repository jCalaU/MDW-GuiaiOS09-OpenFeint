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

#import "OFUserFeintApprovalController.h"
#import "OpenFeint+UserOptions.h"
#import "OpenFeint+Private.h"
#import "OpenFeint+Settings.h"
#import "OFLoadingController.h"
#import "UIView+OpenFeint.h"
#import "OFContentFrameView.h"
#import "OFPatternedGradientView.h"
#import "OFIntroNavigationController.h"
#import "OFCommonWebViewController.h"
#import "OFControllerLoaderObjC.h"

@implementation OFUserFeintApprovalController

@synthesize appNameLabel;
@synthesize approvedInvocation = mApprovedInvocation;
@synthesize deniedInvocation = mDeniedInvocation;

- (void)viewDidLoad
{
    UIButton *declineButton = (UIButton*)[self.view findViewByTag:1];
    UIImage *declineBackground = [[declineButton backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    [declineButton setBackgroundImage:declineBackground forState:UIControlStateNormal];
    
    appNameLabel.text = [NSString stringWithFormat:@"%@ is OpenFeint Enabled!", [OpenFeint applicationDisplayName]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[OpenFeint allowErrorScreens:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"OFNSNotificationFullscreenFrameOff" object:nil];
	[super viewWillAppear:animated];
}

- (void)dismiss
{
	[OpenFeint allowErrorScreens:YES];
	[OpenFeint dismissRootControllerOrItsModal];
}

-(IBAction)clickedUseFeint
{
	[OpenFeint userDidApproveFeint:YES accountSetupCompleteInvocation:self.approvedInvocation];
}

-(IBAction)clickedDontUseFeint 
{
	[OpenFeint userDidApproveFeint:NO];
	[self dismiss];
    [self.deniedInvocation invoke];
}

- (IBAction)onTerms
{
    OFCommonWebViewController* webController = (OFCommonWebViewController*)[[OFControllerLoaderObjC loader] load:@"CommonWebView"];
    webController.title = @"Terms of Service";
    [webController loadUrl:@"http://openfeint.com/tos.iphone"];
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:webController] autorelease];
    [[OpenFeint getRootController] presentModalViewController:navController animated:YES];
}

- (void)dealloc
{
    self.approvedInvocation = nil;
    self.deniedInvocation = nil;
    self.appNameLabel = nil;
	[super dealloc];
}

@end
