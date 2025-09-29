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

%hook UILabel
- (void)setText:(NSString *)text {
    if (gEnabled) {
        // Only affect Preferences app (bundle id: com.apple.Preferences)
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        if ([bundleId isEqualToString:@"com.apple.Preferences"]) {
            if (text.length > 0 && ![text hasPrefix:@"🔧 "]) {
                text = [@"🔧 " stringByAppendingString:text];
            }
        }
    }
    %orig(text);
}
%end

%ctor {
    loadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, preferencesChanged, CFSTR(MGSTPrefsChangedNotification), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}


