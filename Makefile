export ARCHS = arm64 arm64e
export TARGET = iphone:clang:16.0:16.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyGlobalSwitchTweak
MyGlobalSwitchTweak_FILES = Tweak.xm
MyGlobalSwitchTweak_CFLAGS = -fobjc-arc
MyGlobalSwitchTweak_FRAMEWORKS = UIKit CoreFoundation

# Load into Preferences to demo the UI effect safely
INSTALL_TARGET_PROCESSES = Preferences

SUBPROJECTS += MyGlobalSwitchPrefs

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk


