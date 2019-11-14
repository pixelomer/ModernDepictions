include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ModernDepictions

ModernDepictions_FILES = Tweak.xm
ModernDepictions_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
