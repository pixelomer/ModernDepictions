TARGET = iphone:11.2:8.0
ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ModernDepictions

ModernDepictions_FILES = Tweak.xm $(wildcard */*.xm) $(wildcard */*.mm) $(wildcard MMMarkdown/Source/*.m)
ModernDepictions_CFLAGS = -fobjc-arc -include macros.h -I. -IMMMarkdown/Source

include $(THEOS_MAKE_PATH)/tweak.mk
