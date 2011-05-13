Tiny Keychain Services Wrapper
==============================

LKKeychain class is a tiny keychain services wrapper. It provides:

 Add account
 Update account
 Delete account
 Dump accounts (for debug)


Usage
-----
Adding or updating account

	[LKKeychain updatePassowrd:@"hdsI3823Khdf"
		               account:@"hashiguchi@lakesoft.jp"
					   service:@"SampleService"];
If the account does not exists in keychain then new account is created. If exists, the password for the account is updated.

Delete account

	[LKKeychain deletePasswordWithAccount:@"hashiguchi@lakesoft.jp"
								  service:@"SampleService"];

Dump account (for debug)

	NSArray* accounts = [LKKeychain getItemsWithServices:@"SampleService"];

Sample:

	2011-05-14 07:16:28.847 LKKeychain[64739:40b] (
	{
		acct = "hashiguchi@lakesoft.jp";
		agrp = test;
		cdat = "0023-05-13 14:40:33 +0000";
		mdat = "0023-05-13 14:40:33 +0000";
		pdmn = ak;
		svce = SampleService;
		"v_Data" = <70617373 776f7264>;
	},
	:


Customize
---------



Installation
-----------

You should copy below files to your projects.

 LKKeychain.h
 LKKeychain.m


Note
----
You may want to see:

Keychain Services Programming Guide

http://developer.apple.com/library/ios/#documentation/Security/Conceptual/keychainServConcepts/01introduction/introduction.html


License
-------
MIT

Copyright (c) 2011 Hiroshi Hashiguchi

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

