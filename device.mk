DEVICE_PATH := device/samsung/a05

ENABLE_VIRTUAL_AB := false
PRODUCT_SHIPPING_API_LEVEL := 34
PRODUCT_TARGET_VNDK_VERSION := 34

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.mt6769.rc:recovery/root/init.recovery.mt6769.rc \
    $(DEVICE_PATH)/recovery/root/etc/recovery.fstab:recovery/root/system/etc/recovery.fstab

PRODUCT_PACKAGES += \
    fastbootd \
    resetprop \
    libresetprop
