//
//  PrivateSettings.m
//  orlandoaleman.com
//
//  Created by Orlando Aleman Ortiz on 19/03/12.
//  Copyright (c) 2012 OrlandoAleman.com. All rights reserved.
//

#import "PrivateSettings.h"


@interface PrivateSettings () {
    NSMutableDictionary *_settingsDic;
    NSURL *_privateSettingsURL;
}
@end


@implementation PrivateSettings

+ (PrivateSettings *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


- (id)init
{
    self = [super init];
    if (self) {
        _privateSettingsURL = [self genPrivateSettingsURL];
        [self createPrivateSettingsFileIfNeeded];
        BOOL success = [self readAllSettings];
        if (!success) _settingsDic = [NSMutableDictionary dictionary];
    }
    return self;
}


- (NSURL *)genPrivateSettingsURL
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL URLByAppendingPathComponent:PRIVATESETTINGS_FILE];
}


- (void)createPrivateSettingsFileIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[_privateSettingsURL path]]) {
        NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:PRIVATESETTINGS_FILE ofType:nil];
        if (defaultsPath) [fileManager copyItemAtPath:defaultsPath toPath:[_privateSettingsURL path] error:NULL];
    }
}


- (BOOL)readAllSettings
{
    if (_settingsDic) return YES;

    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:[_privateSettingsURL path]];
    NSDictionary *props = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML
                                                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                                     format:&format
                                                                           errorDescription:&errorDesc];
    if (!props) return NO;

    _settingsDic = [[NSMutableDictionary alloc] initWithDictionary:props];
    return YES;
}


- (BOOL)save
{
    if (!_settingsDic) {
        return NO;
    }
    return [_settingsDic writeToURL:_privateSettingsURL atomically:NO];
}



- (id)getPropertyValue:(NSString *)key
{
    if (!_settingsDic) {
        if (![self readAllSettings]) return nil;
    }
    return [_settingsDic valueForKey:key];
}


- (BOOL)setPropertyValue:(id)value forKey:(NSString *)key
{
    if (!_settingsDic) {
        if (![self readAllSettings]) return NO;
    }
    [_settingsDic setValue:value forKey:key];
    return YES;
}


- (id)objectForKeyedSubscript:(NSString *)key
{
    return [self getPropertyValue:key];
}


- (void)setObject:(id)object forKeyedSubscript:(NSString *)key
{
    [self setPropertyValue:object forKey:key];
}


+ (BOOL)existsPrivateSettingsFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *settingsURL = [documentsURL URLByAppendingPathComponent:PRIVATESETTINGS_FILE];
    return [fileManager fileExistsAtPath:[settingsURL path]];
}

@end
