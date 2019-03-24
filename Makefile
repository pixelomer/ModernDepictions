THEOS_DEVICE_IP ?= 0
THEOS_DEVICE_PORT ?= 2222
TARGET = iphone:clang:11.2:7.0
ARCHS = arm64 armv7
CFLAGS = -include macros.h -fobjc-arc -Wno-deprecated-declarations -Wno-unguarded-availability-new -Wno-non-literal-null-conversion
LDFLAGS = -ObjC

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmartDepictions
SmartDepictions_FILES = Tweak.xm $(wildcard MMMarkdown/*.m SmartDepictions/*.mm Extensions/*.mm)
SmartDepictions_FRAMEWORKS = WebKit
SmartDepictions_LIBRARIES = GoogleMobileAds
SmartDepictions_EXTRA_FRAMEWORKS = nanopb GoogleUtilities GoogleMobileAds GoogleAppMeasurement

include $(THEOS_MAKE_PATH)/tweak.mk

install-example:
	@$(THEOS)/bin/dm.pl -Zlzma -b ExamplePackage ExamplePackage.deb
	@cat ExamplePackage.deb | ssh -p$(THEOS_DEVICE_PORT) root@$(THEOS_DEVICE_IP) "cat > /tmp/_.deb; dpkg -i /tmp/_.deb"