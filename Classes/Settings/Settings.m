//
//  Settings.m
//  MobileOrg
//
//  Created by Richard Moreland on 9/30/09.
//  Copyright 2009 Richard Moreland.
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//

#import "Settings.h"
#import "GlobalUtils.h"

// Singleton instance
static Settings *gInstance = NULL;

// Settings keys
static NSString *kIndexUrlKey        = @"IndexUrl";
static NSString *kUsernameKey        = @"Username";
static NSString *kPasswordKey        = @"Password";
static NSString *kLastSyncKey        = @"LastSync";
static NSString *kAllTagsKey         = @"AllTags";
static NSString *kMutuallyExclusiveTagsKey = @"MutuallyExclusiveTags";
static NSString *kPrimaryTagsKey     = @"PrimaryTags";
static NSString *kTodoStateGroupsKey = @"TodoStateGroups";
static NSString *kPrioritiesKey      = @"Priorities";
static NSString *kAppBadgeModeKey    = @"AppBadgeMode";

@implementation Settings

@synthesize indexUrl;
@synthesize username;
@synthesize password;
@synthesize lastSync;
@synthesize allTags;
@synthesize primaryTags;
@synthesize mutuallyExclusiveTagGroups;
@synthesize todoStateGroups;
@synthesize priorities;
@synthesize appBadgeMode;

+ (Settings*)instance {
    @synchronized(self) {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return gInstance;
}

- (id)init {
    if (self = [super init]) {

        NSString *indexUrlString = [[NSUserDefaults standardUserDefaults] objectForKey:kIndexUrlKey];
        if (indexUrlString) {
            indexUrl = [NSURL URLWithString:indexUrlString];
            [indexUrl retain];
        }
        username = [[NSUserDefaults    standardUserDefaults] objectForKey:kUsernameKey];
        [username retain];

        password = [[NSUserDefaults    standardUserDefaults] objectForKey:kPasswordKey];
        [password retain];

        lastSync = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSyncKey];
        [lastSync retain];

        allTags = [[NSUserDefaults standardUserDefaults] objectForKey:kAllTagsKey];
        if (!allTags) {
            self.allTags = [NSMutableArray arrayWithCapacity:0];
        }

        primaryTags = [[NSUserDefaults standardUserDefaults] objectForKey:kPrimaryTagsKey];
        if (!primaryTags) {
            self.primaryTags = [NSMutableArray arrayWithCapacity:0];
        }

        mutuallyExclusiveTagGroups = [[NSUserDefaults standardUserDefaults] objectForKey:kMutuallyExclusiveTagsKey];
        if (!mutuallyExclusiveTagGroups) {
            self.mutuallyExclusiveTagGroups = [NSMutableArray arrayWithCapacity:0];
        }

        todoStateGroups = [[NSUserDefaults standardUserDefaults] objectForKey:kTodoStateGroupsKey];
        if (!todoStateGroups) {
            self.todoStateGroups = [NSMutableArray arrayWithCapacity:0];
        }

        priorities = [[NSUserDefaults standardUserDefaults] objectForKey:kPrioritiesKey];
        if (!priorities) {
            self.priorities = [NSMutableArray arrayWithCapacity:0];
        }

        appBadgeMode = [[NSUserDefaults standardUserDefaults] integerForKey:kAppBadgeModeKey];
        if (!appBadgeMode) {
            self.appBadgeMode = AppBadgeModeNone;
        }
    }
    return self;
}

- (void)setIndexUrl:(NSURL*)aIndexUrl {
    [indexUrl release];
    indexUrl = [aIndexUrl copy];
    [[NSUserDefaults standardUserDefaults] setObject:[aIndexUrl absoluteString] forKey:kIndexUrlKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUsername:(NSString*)aUsername {
    [username release];
    username = [aUsername copy];
    [[NSUserDefaults standardUserDefaults] setObject:aUsername forKey:kUsernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString*)aPassword {
    [password release];
    password = [aPassword copy];
    [[NSUserDefaults standardUserDefaults] setObject:aPassword forKey:kPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLastSync:(NSDate *)aLastSync {
    [lastSync release];
    lastSync = [aLastSync copy];
    [[NSUserDefaults standardUserDefaults] setObject:lastSync forKey:kLastSyncKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetPrimaryTagsAndTodoStates {
    [primaryTags removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:primaryTags forKey:kPrimaryTagsKey];

    [mutuallyExclusiveTagGroups removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:mutuallyExclusiveTagGroups forKey:kMutuallyExclusiveTagsKey];

    [todoStateGroups removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:todoStateGroups forKey:kTodoStateGroupsKey];

    [priorities removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:priorities forKey:kPrioritiesKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetAllTags {
    [allTags removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:allTags forKey:kAllTagsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAllTags:(NSMutableArray*)theAllTags {
    [allTags release];
    allTags = [theAllTags mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:allTags forKey:kAllTagsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addTag:(NSString*)tag {
    if (!tag || [tag length] == 0) {
        return;
    }
    if (![allTags containsObject:tag] && ![primaryTags containsObject:tag]) {
        [allTags addObject:tag];
        [[NSUserDefaults standardUserDefaults] setObject:allTags forKey:kAllTagsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)addPrimaryTag:(NSString*)tag {
    if (!tag || [tag length] == 0) {
        return;
    }
    if (![primaryTags containsObject:tag]) {
        [primaryTags addObject:tag];
        [[NSUserDefaults standardUserDefaults] setObject:primaryTags forKey:kPrimaryTagsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setPrimaryTags:(NSMutableArray*)thePrimaryTags {
    [primaryTags release];
    primaryTags = [thePrimaryTags mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:primaryTags forKey:kPrimaryTagsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addMutuallyExclusiveTagGroup:(NSArray*)mutexTags {
    [self.mutuallyExclusiveTagGroups addObject:mutexTags];
    [[NSUserDefaults standardUserDefaults] setObject:mutuallyExclusiveTagGroups forKey:kMutuallyExclusiveTagsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTodoStateGroups:(NSMutableArray*)theTodoStateGroups {
    [todoStateGroups release];
    todoStateGroups = [theTodoStateGroups mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:todoStateGroups forKey:kTodoStateGroupsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addTodoStateGroup:(NSMutableArray*)todoStateGroup {
    [self.todoStateGroups addObject:todoStateGroup];
    [[NSUserDefaults standardUserDefaults] setObject:todoStateGroups forKey:kTodoStateGroupsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (bool)isTodoState:(NSString*)state {
    for (NSMutableArray *group in todoStateGroups) {
        NSMutableArray *todoWords = [group objectAtIndex:0];
        if ([todoWords containsObject:state]) {
            return true;
        }
    }
    return false;
}

- (bool)isDoneState:(NSString*)state {
    for (NSMutableArray *group in todoStateGroups) {
        NSMutableArray *doneWords = [group objectAtIndex:1];
        if ([doneWords containsObject:state]) {
            return true;
        }
    }
    return false;
}

- (void)setPriorities:(NSMutableArray*)thePriorities {
    [priorities release];
    priorities = [thePriorities mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:priorities forKey:kPrioritiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addPriority:(NSString*)priority {
    if (!priority || [priority length] == 0) {
        return;
    }
    if (![priorities containsObject:priority]) {
        [priorities addObject:priority];
        [[NSUserDefaults standardUserDefaults] setObject:priorities forKey:kPrioritiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (bool)isPriority:(NSString*)priority {
    return [priorities containsObject:priority];
}

- (void)setAppBadgeMode:(AppBadgeMode)newAppBadgeMode {
    appBadgeMode = newAppBadgeMode;
    [[NSUserDefaults standardUserDefaults] setInteger:appBadgeMode forKey:kAppBadgeModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UpdateAppBadge();
}

- (NSString*)indexFilename {
    return [[[self indexUrl] path] lastPathComponent];
}

- (NSURL*)baseUrl {
    return [NSURL URLWithString:[[[self indexUrl] absoluteString] stringByReplacingOccurrencesOfString:[self indexFilename] withString:@""]];
}

- (NSURL*)urlForFilename:(NSString*)filename {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], filename]];
}

- (bool)isConfiguredProperly {
    NSString *indexUrlStr = [indexUrl absoluteString];
    if (indexUrl && [indexUrlStr length] > 0) {
        if ([indexUrlStr rangeOfRegex:@"http[s]?://.*\\.(?:org|txt)"].location == 0) {
            return true;
        }
    }
    return false;
}

- (void)dealloc {
    [indexUrl release];
    [username release];
    [password release];
    [lastSync release];
    [allTags release];
    [primaryTags release];
    [mutuallyExclusiveTagGroups release];
    [todoStateGroups release];
    [super dealloc];
}

@end
