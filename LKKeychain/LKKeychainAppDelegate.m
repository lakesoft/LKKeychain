//
//  LKKeychainAppDelegate.m
//  LKKeychain
//
//  Created by Hiroshi Hashiguchi on 11/05/13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKKeychainAppDelegate.h"
#import "LKKeychain.h"

#define SERVICE_NAME    @"TestServeic"

@implementation LKKeychainAppDelegate


@synthesize window=_window;
@synthesize usernameTextField, passwordTextField, itemTable, itemList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    [self dump:nil];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LKKeychainDumpCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:cellIdentifier] autorelease];
    }

    NSDictionary* dict = [self.itemList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@",
                           [dict objectForKey:(id)kSecAttrAccount],
                           [LKKeychain getPasswordWithAccount:[dict objectForKey:(id)kSecAttrAccount]
                                                      service:SERVICE_NAME]];
    cell.detailTextLabel.text = [[dict objectForKey:(id)kSecAttrCreationDate] description];

    return cell;
}



- (IBAction)update:(id)sender
{
    [LKKeychain updatePassword:self.passwordTextField.text
                       account:self.usernameTextField.text
                       service:SERVICE_NAME];
    [self dump:nil];
}
- (IBAction)delete:(id)sender
{
    [LKKeychain deletePasswordWithAccount:self.usernameTextField.text
                                  service:SERVICE_NAME];
    [self dump:nil];
}
- (IBAction)dump:(id)sender
{
    self.itemList = [LKKeychain getItemsWithService:SERVICE_NAME];
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.itemTable reloadData];
}


@end
