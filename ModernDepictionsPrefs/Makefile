include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ModernDepictionsPrefs
ModernDepictionsPrefs_FILES = PXMDSPRootListController.m
ModernDepictionsPrefs_INSTALL_PATH = /Library/PreferenceBundles
ModernDepictionsPrefs_FRAMEWORKS = UIKit
ModernDepictionsPrefs_LIBRARIES = colorpicker
ModernDepictionsPrefs_PRIVATE_FRAMEWORKS = Preferences
ModernDepictionsPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ModernDepictionsPrefs.plist$(ECHO_END)
