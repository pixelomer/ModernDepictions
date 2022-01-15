THEOS_DEVICE_IP ?= 0
THEOS_DEVICE_PORT ?= 2222
TARGET = iphone:clang:11.2:8.0
ARCHS = arm64 armv7
CFLAGS = -fobjc-arc -include macros.h -I.

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ModernDepictions
ModernDepictions_FILES = Tweak.xm $(wildcard Tweak/*.xm MMMarkdown/*.m ModernDepictions/*/*.mm Extensions/*.mm)
ModernDepictions_FRAMEWORKS = WebKit
ModernDepictions_LIBRARIES = CSColorPicker

MMMarkdown/MMScanner.m_CFLAGS = -Wno-non-literal-null-conversion

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += ModernDepictionsPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
