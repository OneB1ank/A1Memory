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

# 获取当前路径
MODPATH=${0%/*}

# 获取当前日期（格式为YYYY-MM-DD）
CURRENT_DATE=$(date +%Y-%m-%d)

# 进入模块目录
cd $MODPATH/module

# 打包并压缩模块，文件名中添加日期
zip -r -9 "A1Memory-$CURRENT_DATE.zip" *

# 移动到上一层路径文件夹build
mv -f "A1Memory-$CURRENT_DATE.zip" "../build/"