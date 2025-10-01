#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MyGlobalSwitchTweak.h"

static BOOL gEnabled = YES;

static void loadPreferences(void) {
    CFStringRef appID = CFSTR(MGSTPrefsDomain);
    CFPreferencesAppSynchronize(appID);
    Boolean keyExistsAndHasValidFormat = false;
    Boolean value = CFPreferencesGetAppBooleanValue(CFSTR("Enabled"), appID, &keyExistsAndHasValidFormat);
    if (!keyExistsAndHasValidFormat) {
        gEnabled = YES; // default on
    } else {
        gEnabled = (BOOL)value;
    }
}

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPreferences();
}

// 注释掉系统设置前端图标功能
/*
%hook UILabel
- (void)setText:(NSString *)text {
    if (gEnabled) {
        // Only affect Preferences app (bundle id: com.apple.Preferences)
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        if ([bundleId isEqualToString:@"com.apple.Preferences"]) {
            if (text.length > 0 && ![text hasPrefix:@"💞 "]) {
                text = [@"🎈 " stringByAppendingString:text];
            }
        }
    }
    %orig(text);
}
%end
*/

// 新增
%hook NSUserDefaults
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
    if (gEnabled) {
        // 全局控制所有开关的默认行为
        // 强制所有开关为开启状态
        value = YES;
    }
    %orig(value, defaultName);
}

- (BOOL)boolForKey:(NSString *)defaultName {
    BOOL originalValue = %orig;
    if (gEnabled) {
        // 全局控制所有布尔值的读取
        // 强制返回开启状态
        return YES;
    }
    return originalValue;
}
%end

%ctor {
    loadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, preferencesChanged, CFSTR(MGSTPrefsChangedNotification), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}


