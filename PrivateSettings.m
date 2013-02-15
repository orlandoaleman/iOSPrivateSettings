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
        [self readSettings];
    }
    return self;
}


- (NSDictionary *)readPropertyList:(NSString *)path
{
    NSError *error = nil; NSPropertyListFormat format;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSDictionary *props = [NSPropertyListSerialization propertyListWithData:plistXML
                                              options:NSPropertyListImmutable
                                               format:&format
                                                error:&error];
    return props;
}


- (BOOL)readSettings
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *defaultSettingsPath = [[NSBundle mainBundle] pathForResource:PRIVATESETTINGS_FILE ofType:nil];
    NSString *settingsPath = [[PrivateSettings privateSettingsURL] path];
    
    _settingsDic = [NSMutableDictionary dictionary];

    if ([fileManager fileExistsAtPath:defaultSettingsPath]) {
        [_settingsDic addEntriesFromDictionary:[self readPropertyList:defaultSettingsPath]];
    }
    
    if ([fileManager fileExistsAtPath:settingsPath]) {
        [_settingsDic addEntriesFromDictionary:[self readPropertyList:settingsPath]];
    }

    return _settingsDic; // != nil
}


- (BOOL)save
{
    if (!_settingsDic) {
        return NO;
    }
    return [_settingsDic writeToURL:[PrivateSettings privateSettingsURL] atomically:NO];
}



- (id)getPropertyValue:(NSString *)key
{
    if (!_settingsDic) {
        if (![self readSettings]) return nil;
    }
    return [_settingsDic valueForKey:key];
}


- (BOOL)setPropertyValue:(id)value forKey:(NSString *)key
{
    if (!_settingsDic) {
        if (![self readSettings]) return NO;
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
    return [fileManager fileExistsAtPath:[[PrivateSettings privateSettingsURL] path]];
}


+ (NSURL *)privateSettingsURL
{
    static NSURL *privateSettingsURL = nil;
    if (!privateSettingsURL) {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                      inDomains:NSUserDomainMask] lastObject];
        privateSettingsURL = [documentsURL URLByAppendingPathComponent:PRIVATESETTINGS_FILE];
    }
    return privateSettingsURL;
}

- (void)reset
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *settingsPath = [[PrivateSettings privateSettingsURL] path];
    
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:settingsPath]) {
        if (![fileManager removeItemAtPath:settingsPath error:&error]) {
            NSLog(@"%@", error);
        }
    }

    [self readSettings];
}

@end
