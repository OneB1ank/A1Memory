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

# 等待 rosan 检测屏幕
ac=null
until [ "$ac" = "false" ]; do
	ac=$(/system/bin/app_process -Djava.class.path="$MODDIR/compilations.dex" /system/bin com.rosan.shell.ActiviteJava)
	sleep 10
done

init() {
    cd $MODDIR
    logfile_path=$(grep -A 1 '"log":' config/memory.json | grep '"path":' | awk -F'"path": "' '{print $2}' | awk -F'"' '{print $1}')
    # logfile如果为空
    if [ -z "$logfile_path" ]; then
        logfile_path=$(grep -A 2 '"log":' config/memory.json | grep '"path":' | awk -F'"path": "' '{print $2}' | awk -F'"' '{print $1}')
    fi
}

memory() {
    lmkd=$(ps -ef | grep '/system/bin/lmkd' |grep -v 'grep' | awk '{print $1}')
    kill -9 $lmkd
    sleep 5
    renice -n -19 -p $lmkd
    rm -rf "$logfile_path"
    $MODDIR/HC_memory
    sleep 55
    memory
}

init
# 执行 memory 函数
memory