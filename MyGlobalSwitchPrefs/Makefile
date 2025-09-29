include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MyGlobalSwitchPrefs
MyGlobalSwitchPrefs_FILES = MyGlobalSwitchRootListController.m
MyGlobalSwitchPrefs_INSTALL_PATH = /Library/PreferenceBundles
MyGlobalSwitchPrefs_FRAMEWORKS = UIKit
MyGlobalSwitchPrefs_PRIVATE_FRAMEWORKS = Preferences
MyGlobalSwitchPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -a Resources/MyGlobalSwitchPrefs.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MyGlobalSwitchPrefs.plist$(ECHO_END)

