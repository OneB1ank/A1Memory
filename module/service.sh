#!/system/bin/sh
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

# 定义模块目录
MODDIR="$(dirname "$0")"
COUNT=0

# 等待设备完成引导
while [ "$(getprop sys.boot_completed)" != "1" ] && [ $COUNT -lt 3]; do
    sleep 10
    COUNT=$((COUNT+1))
done

adjustPermissions() {
    local dir="$1"
    local perms=$(stat -c %A "$dir")
    local owner_read_perm=${perms:1:1}
    local owner_write_perm=${perms:2:1}
    local group_read_perm=${perms:4:1}
    local group_write_perm=${perms:5:1}
    local other_read_perm=${perms:7:1}
    local other_write_perm=${perms:8:1}

    # 根据检测到的权限，为所有者、用户组和其他用户逐一添加缺失的权限
    if [ "$owner_read_perm" != "r" ]; then
        chmod u+r "$dir"
    fi

    if [ "$owner_write_perm" != "w" ]; then
        chmod u+w "$dir"
    fi

    if [ "$group_read_perm" != "r" ]; then
        chmod g+r "$dir"
    fi

    if [ "$group_write_perm" != "w" ]; then
        chmod g+w "$dir"
    fi

    if [ "$other_read_perm" != "r" ]; then
        chmod o+r "$dir"
    fi

    if [ "$other_write_perm" != "w" ]; then
        chmod o+w "$dir"
    fi
}

init() {
    cd $MODDIR
    logfile_path=$(grep -A 1 '"log":' config/memory.json | grep '"path":' | awk -F'"path": "' '{print $2}' | awk -F'"' '{print $1}')
    # logfile如果为空
    if [ -z "$logfile_path" ]; then
        logfile_path=$(grep -A 2 '"log":' config/memory.json | grep '"path":' | awk -F'"path": "' '{print $2}' | awk -F'"' '{print $1}')
    fi
}

memory() {
    adjustPermissions "/data/media/0/Android/HChai/HC_memory"
    rm -rf "$logfile_path"
    touch "$logfile_path"
    $MODDIR/HC_memory
    sleep 60
    memory
}

init
memory