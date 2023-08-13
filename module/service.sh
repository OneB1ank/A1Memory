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

# 等待设备完成引导
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 5
done

init() {
    cd $MODDIR
    local linesAfter=1
    while true; do
        logfile_path=$(grep -A $linesAfter '"log":' config/memory.json | awk -F'"path": "' '/"path":/ {print $2}' | awk -F'"' '{print $1}')
        [ -n "$logfile_path" ] || [ $linesAfter -gt 10 ] && break
        ((linesAfter++))
    done
}

memory() {
    lmkd_pid=$(ps -ef | grep '/system/bin/lmkd' | grep -v 'grep' | awk '{print $1}')
    kill -9 $lmkd_pid
    sleep 5
    lmkd_pid=$(ps -ef | grep '/system/bin/lmkd' | grep -v 'grep' | awk '{print $1}')
    renice -n -19 -p $lmkd_pid
    rm -rf "$logfile_path"
    $MODDIR/HC_memory
    sleep 55
    memory
}

init
memory