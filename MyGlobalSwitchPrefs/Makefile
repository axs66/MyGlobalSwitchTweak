ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MyGlobalSwitchPrefs

MyGlobalSwitchPrefs_FILES = MyGlobalSwitchRootListController.m
MyGlobalSwitchPrefs_FRAMEWORKS = UIKit Foundation CoreFoundation
MyGlobalSwitchPrefs_PRIVATE_FRAMEWORKS = Preferences
MyGlobalSwitchPrefs_INSTALL_PATH = /Library/PreferenceBundles
MyGlobalSwitchPrefs_CFLAGS = -fobjc-arc -I$(THEOS)/include/Preferences.framework -I$(THEOS_PROJECT_DIR)/theos/include/Preferences.framework
SDKROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
MyGlobalSwitchPrefs_LDFLAGS = -L$(SDKROOT)/usr/lib -F$(SDKROOT)/System/Library/PrivateFrameworks


include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -a Resources/MyGlobalSwitchPrefs.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MyGlobalSwitchPrefs.plist$(ECHO_END)
