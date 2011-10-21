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

#import "OFApplicationDescriptionService.h"
#import "OFApplicationDescription.h"
#import "OFService+Private.h"
#import "OFResource+ObjC.h"
#import "OFDependencies.h"

OPENFEINT_DEFINE_SERVICE_INSTANCE(OFApplicationDescriptionService);

@implementation OFApplicationDescriptionService

OPENFEINT_DEFINE_SERVICE(OFApplicationDescriptionService);

- (void) populateKnownResourceMap:(NSMutableDictionary*)namedResourceMap
{
	[namedResourceMap setObject:[OFApplicationDescription class] forKey:[OFApplicationDescription getResourceName]];
}

+ (void) getShowWithId:(NSString*)resourceId onSuccessInvocation:(OFInvocation*)_onSuccess onFailureInvocation:(OFInvocation*)_onFailure
{
	[[self sharedInstance] getAction:[NSString stringWithFormat:@"client_applications/%@/application_descriptions.xml", resourceId]
                  withParameterArray:nil
               withSuccessInvocation:_onSuccess
               withFailureInvocation:_onFailure
                     withRequestType:OFActionRequestForeground
		 withNotice:[OFNotificationData foreGroundDataWithText:@"Downloaded Application Description"]];
}

@end
