THEOS_DEVICE_IP ?= 0
THEOS_DEVICE_PORT ?= 2222
TARGET = iphone:clang:11.2:6.0
ARCHS = arm64 armv7
CFLAGS = -include macros.h -fobjc-arc -Wno-deprecated-declarations -Wno-unguarded-availability-new

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmartDepictions
$(TWEAK_NAME)_FILES = Tweak.xm $(wildcard SmartDepictions/*.xm) $(wildcard SmartDepictions/*.mm) $(wildcard Extensions/*.mm)

include $(THEOS_MAKE_PATH)/tweak.mk

install-example:
	@$(THEOS)/bin/dm.pl -Zlzma -b ExamplePackage ExamplePackage.deb
	@cat ExamplePackage.deb | ssh -p$(THEOS_DEVICE_PORT) root@$(THEOS_DEVICE_IP) "cat > /tmp/_.deb; dpkg -i /tmp/_.deb"