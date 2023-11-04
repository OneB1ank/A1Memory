#
#Copyright (C) 2022-2023 OneB1ank
#
#This program is free module: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program. If not, see <http://www.gnu.org/licenses/>.
#

CONFIG_PATH="/sdcard/Android/HChai/HC_memory"
MODULE_PATH="/data/adb/modules/Hc_memory"
LANGUAGE_PATH="$MODPATH/config/Language"
LANGUAGE_PATH_MODULE="$MODULE_PATH/config/Language"
LOCALE=`getprop persist.sys.locale`
LOCALE_JSON_PATH="$LANGUAGE_PATH/list/${LOCALE}.json"
LOCALE_JSON_PATH_MODULE="$LANGUAGE_PATH_MODULE/list/${LOCALE}.json"
LMKDRC_PATH="/system/etc/init/lmkd.rc"

config() {
    [ ! -d "$CONFIG_PATH" ] && mkdir -p "$CONFIG_PATH"
    [ ! -f "$CONFIG_PATH/名单列表.conf" ] && cp "$MODPATH/config/HC_memory/名单列表.conf" "$CONFIG_PATH"
    rm -rf "$MODPATH/config/HC_memory"
    [ -f "$MODULE_PATH/config/memory.json" ] && cp "$MODULE_PATH/config/memory.json" "$MODPATH/config/memory.json"
    cp "$MODPATH/system/bin/amui" "$CONFIG_PATH/terminal.sh"
    ui_print "- update configuration"
    if [ -f "${LOCALE_JSON_PATH}" ]; then
        echo "${LOCALE_JSON_PATH_MODULE}" > "$LANGUAGE_PATH/lg.txt"
    else
        echo "$LANGUAGE_PATH_MODULE/list/en-US.json" > "$LANGUAGE_PATH/lg.txt"
    fi
    if [ -f "$LMKDRC_PATH" ]; then
        sed -e '/group/{
        /system/ s/system/root/
        /root/! s/$/ root/
        }' "$LMKDRC_PATH" > "${MODPATH}${LMKDRC_PATH}"
    else
        echo "File not found: $LMKDRC_PATH"
    fi
    ui_print "- update language"
}

xp() {
    pm install -r "$MODPATH/app/app-release.apk"
    rm -rf "$MODPATH/app"
    ui_print "- install com.hchai.rescueplan"
}j

if [ "$ARCH" != "arm64" ]; then
  abort "Not compatible with this platform: $ARCH"
else
  ui_print "- Your platform can use A1 Memory"
  config
  xp
fi

set_perm_recursive "$MODPATH" 0 0 0755 0777

ui_print "- Restart and enjoy A1 Memory immediately"
> "${MODPATH}${LMKDRC_PATH}"