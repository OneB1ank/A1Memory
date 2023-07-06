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

set -e

MODPATH=${0%/*}
CURRENT_DATE=$(date +%Y-%m-%d)

init() {
    cd $MODPATH/module
    echo "- 切换到模块路径"
}

packaged_Modules() {
    cp -f $MODPATH/config/memory.json $MODPATH/module/config/memory.json
    zip -r -9 "A1Memory-$CURRENT_DATE.zip" *
    mv -f "A1Memory-$CURRENT_DATE.zip" "../build/"
    echo "- 打包成功，模块名" "A1Memory-$CURRENT_DATE.zip"
}

clear() {
    rm config/memory.json
}

init
packaged_Modules
clear