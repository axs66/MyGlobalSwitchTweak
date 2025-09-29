#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "../MyGlobalSwitchTweak.h"

@interface MyGlobalSwitchRootListController : PSListController
@end

@implementation MyGlobalSwitchRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *specs = [NSMutableArray array];

        PSSpecifier *group = [PSSpecifier preferenceSpecifierNamed:@"MyGlobalSwitch"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:Nil
                                                              cell:PSGroupCell
                                                              edit:Nil];
        [group setProperty:@"Enable or disable the tweak globally" forKey:@"footerText"];
        [specs addObject:group];

        PSSpecifier *toggle = [PSSpecifier preferenceSpecifierNamed:@"Enable"
                                                             target:self
                                                                set:@selector(setPreferenceValue:specifier:)
                                                                get:@selector(readPreferenceValue:)
                                                             detail:Nil
                                                               cell:PSSwitchCell
                                                               edit:Nil];
        [toggle setProperty:@"Enabled" forKey:@"key"];
        [toggle setProperty:@(YES) forKey:@"default"];
        [toggle setProperty:@MGSTPrefsDomain forKey:@"defaults"];
        [toggle setProperty:@YES forKey:@"enabled"];
        [toggle setProperty:@"com.apple.Preferences" forKey:@"PostNotificationName"];
        // Use custom Darwin notification for immediate reload
        [toggle setProperty:@MGSTPrefsChangedNotification forKey:@"PostDarwinNotification"];

        [specs addObject:toggle];

        _specifiers = [specs copy];
    }
    return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:@"key"];
    CFStringRef appID = CFSTR(MGSTPrefsDomain);
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyRef)value, appID);
    CFPreferencesAppSynchronize(appID);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR(MGSTPrefsChangedNotification), NULL, NULL, true);
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:@"key"];
    CFStringRef appID = CFSTR(MGSTPrefsDomain);
    Boolean keyExistsAndHasValidFormat = false;
    Boolean value = CFPreferencesGetAppBooleanValue((__bridge CFStringRef)key, appID, &keyExistsAndHasValidFormat);
    if (!keyExistsAndHasValidFormat) {
        id def = [specifier propertyForKey:@"default"];
        return def ?: @(YES);
    }
    return @(value);
}

@end


