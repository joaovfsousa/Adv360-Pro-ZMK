#!/usr/bin/env bash

set -eu

PWD=$(pwd)
TIMESTAMP="${TIMESTAMP:-$(date -u +"%Y%m%d%H%M")}"
COMMIT="${COMMIT:-$(echo xxxxxx)}"

BUILD_LEFT="${BUILD_LEFT:-true}"
BUILD_RIGHT="${BUILD_RIGHT:-true}"
BUILD_DONGLE="${BUILD_DONGLE:-true}"

# West Build (left)
if [ "${BUILD_LEFT}" = true ]; then
    west build -s zmk/app -p -d build/left -b adv360_left -- -DZMK_CONFIG="${PWD}/config"
    grep -vE '(^#|^$)' build/left/zephyr/.config
    cp build/left/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-left.uf2"
fi

# West Build (right)
if [ "${BUILD_RIGHT}" = true ]; then
    west build -s zmk/app -p -d build/right -b adv360_right -- -DZMK_CONFIG="${PWD}/config"
    grep -vE '(^#|^$)' build/right/zephyr/.config
    cp build/right/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-right.uf2"
fi

# West Build (dongle) - this is the central, ZMK Studio lives here.
if [ "${BUILD_DONGLE}" = true ]; then
    west build -s zmk/app -p -d build/dongle -b adv360_dongle -S studio-rpc-usb-uart -- -DZMK_CONFIG="${PWD}/config" -DCONFIG_ZMK_STUDIO=y
    grep -vE '(^#|^$)' build/dongle/zephyr/.config
    cp build/dongle/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-dongle.uf2"
fi
