//
//  LKKeychainAppDelegate.h
//  LKKeychain
//
//  Created by Hiroshi Hashiguchi on 11/05/13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKKeychainAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITextField* usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField* passwordTextField;
@property (nonatomic, retain) IBOutlet UITableView* itemTable;
@property (nonatomic, retain) NSArray* itemList;

- (IBAction)update:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)dump:(id)sender;
@end
