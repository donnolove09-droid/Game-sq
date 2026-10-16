ARCHS = arm64
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = L99Avatar

L99Avatar_FILES = Tweak.x
L99Avatar_CFLAGS = -fobjc-arc
L99Avatar_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
