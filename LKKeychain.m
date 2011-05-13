//
//  KeychainServicesManager.m
//  Anshinkun
//
//  Created by Hiroshi Hashiguchi on 11/02/18.
//  Copyright 2011 . All rights reserved.
//
#import <Security/Security.h>
#import "KeychainServicesManager.h"

static KeychainServicesManager* sharedManager_;

@implementation KeychainServicesManager

+ (KeychainServicesManager*)sharedManager
{
	if (sharedManager_ == nil) {
		sharedManager_ = [[KeychainServicesManager alloc] init];
	}
	return sharedManager_;
}


#pragma mark -
#pragma mark API
- (NSString*)getPasswordWithAccount:(NSString*)account service:(NSString*)service
{
	if (service == nil || account == nil) {
		return nil;
	}

	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:(id)service forKey:(id)kSecAttrService];
	[query setObject:(id)account forKey:(id)kSecAttrAccount];
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

	NSString* password = nil;
	NSData* passwordData = nil;
	OSStatus err = SecItemCopyMatching((CFDictionaryRef)query,
									   (CFTypeRef*)&passwordData);
	
	if (err == noErr) {
		 password = [[[NSString alloc] initWithData:passwordData
													encoding:NSUTF8StringEncoding] autorelease];
	} else if(err == errSecItemNotFound) {
		// do nothing
	} else {
		NSLog(@"%s|SecItemCopyMatching: error(%ld)", __PRETTY_FUNCTION__, err);
	}
	
	return password;
}

- (BOOL)updatePassword:(NSString*)password account:(NSString*)account service:(NSString*)service
{
	BOOL result = NO;
	NSMutableDictionary* attributes = nil;
	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	NSData* passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
	
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:(id)service forKey:(id)kSecAttrService];
	[query setObject:(id)account forKey:(id)kSecAttrAccount];
	
	OSStatus err = SecItemCopyMatching((CFDictionaryRef)query, NULL);
	
	if (err == noErr) {
		// update item		
		attributes = [NSMutableDictionary dictionary];
		[attributes setObject:passwordData forKey:(id)kSecValueData];
		[attributes setObject:[NSDate date] forKey:(id)kSecAttrModificationDate];
		
		err = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributes);
		if (err == noErr) {
			result = YES;
		} else {
			NSLog(@"%s|SecItemUpdate: error(%ld)", __PRETTY_FUNCTION__, err);
		}
		
	} else if (err == errSecItemNotFound) {
		// add new item
		attributes = [NSMutableDictionary dictionary];
		[attributes setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
		[attributes setObject:(id)service forKey:(id)kSecAttrService];
		[attributes setObject:(id)account forKey:(id)kSecAttrAccount];
		[attributes setObject:passwordData forKey:(id)kSecValueData];
		[attributes setObject:[NSDate date] forKey:(id)kSecAttrCreationDate];
		[attributes setObject:[NSDate date] forKey:(id)kSecAttrModificationDate];
		
		err = SecItemAdd((CFDictionaryRef)attributes, NULL);
		if (err == noErr) {
			result = YES;
		} else {
			NSLog(@"%s|SecItemAdd: error(%ld)", __PRETTY_FUNCTION__, err);
		}
		
	} else {
		NSLog(@"%s|SecItemCopyMatching: error(%ld)", __PRETTY_FUNCTION__, err);
	}
	
	return result;
}

- (BOOL)deletePasswordWithAccount:(NSString*)account service:(NSString*)service
{
	BOOL result = NO;
	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:(id)service forKey:(id)kSecAttrService];
	[query setObject:(id)account forKey:(id)kSecAttrAccount];
	
	OSStatus err = SecItemDelete((CFDictionaryRef)query);
	
	if (err == noErr) {
		result = YES;
	} else {
		NSLog(@"%s|SecItemDelete: error(%ld)", __PRETTY_FUNCTION__, err);
	}
	
	return result;
}

- (NSArray*)getItemsWithService:(NSString*)service
{
	if (service == nil) {
		return nil;
	}
	
	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:(id)service forKey:(id)kSecAttrService];
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	[query setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
	
	CFArrayRef result = nil;
	OSStatus err = SecItemCopyMatching((CFDictionaryRef)query,
									   (CFTypeRef*)&result);
	
	if (err == noErr) {
		return (NSArray*)result;
	} else {
		NSLog(@"%s|SecItemCopyMatching: error(%ld)", __PRETTY_FUNCTION__, err);
		return nil;
	}
}

@end
