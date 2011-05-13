//
//  KeychainServicesManager.h
//  Anshinkun
//
//  Created by Hiroshi Hashiguchi on 11/02/18.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeychainServicesManager : NSObject {

}

+ (KeychainServicesManager*)sharedManager;

// API
- (NSString*)getPasswordWithAccount:(NSString*)account service:(NSString*)service;

- (BOOL)updatePassword:(NSString*)password account:(NSString*)account service:(NSString*)service;

- (BOOL)deletePasswordWithAccount:(NSString*)account service:(NSString*)service;


// for debug
- (NSArray*)getItemsWithService:(NSString*)service;

@end
