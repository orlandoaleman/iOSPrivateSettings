//
//  PrivateSettings.h
//  orlandoaleman.com
//
//  Created by Orlando Aleman Ortiz on 19/03/12.
//  Copyright (c) 2012 OrlandoAleman.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PRIVATESETTINGS_FILE @"privateSettings.plist"

@interface PrivateSettings : NSObject

+ (PrivateSettings *)sharedInstance;

/* */
+ (BOOL)existsPrivateSettingsFile;

/* */
- (BOOL)save;

/* */
- (id)getPropertyValue:(NSString *)key;

/* */
- (BOOL)setPropertyValue:(id)value forKey:(NSString *)key;

/*!
 In LLVM 4.0 (XCode 4.5) or higher allows myPFObject[key].
 @param key The key.
*/
- (id)objectForKeyedSubscript:(NSString *)key;

/*!
 In LLVM 4.0 (XCode 4.5) or higher allows myObject[key] = value
 @param object The object.
 @param key The key.
*/
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;


- (void)reset;

@end
