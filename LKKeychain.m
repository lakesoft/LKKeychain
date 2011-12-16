//
// Copyright (c) 2011 Hiroshi Hashiguchi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Security/Security.h>
#import "LKKeychain.h"

@implementation LKKeychain

#pragma mark -
#pragma mark API
+ (NSString*)getPasswordWithAccount:(NSString*)account service:(NSString*)service
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
		[passwordData release];
	} else if(err == errSecItemNotFound) {
		// do nothing
		[passwordData release];
	} else {
		NSLog(@"%s|SecItemCopyMatching: error(%ld)", __PRETTY_FUNCTION__, err);
	}
	
	return password;
}

+ (BOOL)updatePassword:(NSString*)password account:(NSString*)account service:(NSString*)service
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

+ (BOOL)deletePasswordWithAccount:(NSString*)account service:(NSString*)service
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

+ (NSArray*)getItemsWithService:(NSString*)service
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
		return [(NSArray*)result autorelease];
	} else {
		NSLog(@"%s|SecItemCopyMatching: error(%ld)", __PRETTY_FUNCTION__, err);
		return nil;
	}
}

@end
