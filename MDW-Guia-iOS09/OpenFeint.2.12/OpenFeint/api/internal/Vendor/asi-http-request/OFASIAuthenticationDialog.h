//
//  ASIAuthenticationDialog.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 21/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OFASIHTTPRequest;

typedef enum _OFASIAuthenticationType {
	OFASIStandardAuthenticationType = 0,
    OFASIProxyAuthenticationType = 1
} OFASIAuthenticationType;
	
@interface OFASIAuthenticationDialog : NSObject <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	OFASIHTTPRequest *request;
	UIActionSheet *loginDialog;
	OFASIAuthenticationType type;
}
+ (void)presentAuthenticationDialogForRequest:(OFASIHTTPRequest *)request;
+ (void)presentProxyAuthenticationDialogForRequest:(OFASIHTTPRequest *)request;

@property (retain) OFASIHTTPRequest *request;
@property (retain) UIActionSheet *loginDialog;
@property (assign) OFASIAuthenticationType type;
@end
