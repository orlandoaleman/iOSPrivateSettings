//
//  PrivateSettings.h
//  CareForMe
//
//  Created by Orlando Aleman Ortiz on 19/03/12.
//  Copyright (c) 2012 OrlandoAleman.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PRIVATESETTINGS_FILE @"private.plist"

@interface PrivateSettings : NSObject

+ (PrivateSettings *)sharedInstance;
+ (BOOL)existsPrivateSettingsFile;

- (id)getPropertyValue:(NSString *)key;
- (BOOL)setPropertyValue:(NSString *)key value:(id)value;

- (BOOL)save;

@end