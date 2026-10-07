$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/samsung/a05/device.mk)

PRODUCT_DEVICE := a05
PRODUCT_NAME := omni_a05
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-A055F
PRODUCT_MANUFACTURER := samsung
PRODUCT_GMS_CLIENTID_BASE := android-samsung
