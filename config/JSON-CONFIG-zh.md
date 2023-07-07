# A1内存管理v4 Json配置文件说明

A1内存管理v4 使用框架HAMv2开发，因此可以在不修改源码的情况下，通过配置文件来调整内存管理的参数。本文档将详细介绍如何配置Json配置文件。

## 自定义modules参数

```json
"config": {
    "path": "/sdcard/Android/HChai/HC_memory",
    "modulePath": "/data/adb/modules/Hc_memory",
    "list": {
        "name": "名单列表.conf",
        "whiteList": {
            "optional": true,
            "smart": true,
            "system": false
        }
    }
}
```

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| path     | string   | 配置文件路径                                 |
| modulePath   | string   | 模块名字路径                            |
| name     | string   | 配置列表的文件名字，该文件存储白名单和乖巧名单                           |
| optional   | bool   | 是否启用白名单，启用后，白名单中的进程不会被杀死                           |
| smart   | bool   | 是否启用智能白名单，启用后将会自动识别进程加入白名单                        |
| system   | bool   | 是否启用系统白名单，启用后所有的系统软件都会加入白名单                           |

需要注意，添加白名单要按照以下格式添加：

```
WHITE 包名
```

## 日志路径/级别

记录A1内存管理v4运行时的日志，可以通过修改日志路径和日志级别来调整日志的输出。

```json
"log": {
    "path": "/sdcard/Android/HChai/HC_memory/Run.log",
    "level": "info"
}
```

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| path     | string   | 日志路径                                 |
| level   | string   | 日志级别，可选项：debug, info, warn, error, critical                           |

如果你想要关闭日志，可以将日志级别设置为critical，或者您只想查看运行错误的日志可以设置为warn。

## 主函数运行参数

这个参数的作用是在前台应用发生变化后，在一段时间内再切换前台进程不会再运行主函数。

```json
"initProcess": {
    "afterTopChange": {
        "sleep": 1
    }
}
```

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| sleep     | int   | 等待时间，单位为秒                                 |

"sleep"表示在前台应用发生变化后等待的时间，以秒为单位。设置为1秒意味着在前台应用发生变化后，等待1秒后切换前台才会再次执行主函数。换句话说，在这1秒的时间内切换前台，主函数不会被执行。这个参数可以用于控制在前台应用变化后的一段时间内避免主函数的重复执行，以防止不必要的操作或资源浪费。

## A1内存管理结束不必要的进程

A1内存管理v4可以结束不必要的进程以释放内存。下面是用于控制此行为的参数示例：

```json
"a1Memory": {
    "enable": true,
    "oomAdj": 905
}
```

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| enable     | bool   | 是否启用A1内存管理结束不必要的进程                                 |
| oomAdj   | int   | 大于oomAdj的数值才会被结束                          |

- `enable`表示是否启用A1内存管理来结束不必要的进程。如果设置为true，A1内存管理将会执行进程结束操作；如果设置为false，A1内存管理将不会结束任何进程。
- `oomAdj`表示用于判断进程是否被结束的调整值。只有进程的oomAdj值大于设定的"oomAdj"数值时，它们才会被A1内存管理结束。此数值范围为0到1000之间，数值越大，被结束的进程就越少；反之，数值越小，被结束的进程就越多。需要注意的是，并非所有进程都会被识别和结束，只有那些被算法判断为非必要进程且oomAdj值大于指定数值的进程才会被结束。

## 让应用自动释放内存

A1内存管理v4可以让应用自动释放内存。下面是用于控制此行为的参数示例：

```json
"initCutMemory": {
    "freed": {
        "enable": true,
        "level": "80",
        "regex": "( CAC|SVC|CEM).*",
        "change": 20
    }
}
```

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| enable     | bool   | 是否启用应用自动释放内存                                 |
| level   | string   | 0-100，数值越高释放的内存越多                          |
| regex   | string   | 正则表达式，匹配需要释放内存的应用状态                        |
| change   | int   | 前台切换多少次执行一次自动释放操作                          |

- `enable`表示是否启用应用自动释放内存。如果设置为true，A1内存管理将会执行应用自动释放内存操作；如果设置为false，A1内存管理将不会执行应用自动释放内存操作。
- `level`表示释放内存的程度。此数值范围为0到100之间，数值越高，释放的内存就越多；反之，数值越低，释放的内存就越少。
- `regex`表示用于匹配需要释放内存的应用状态的正则表达式。只有匹配到的应用状态才会被释放内存。正则表达式的匹配规则与JS语言相同，可以参考[这里](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Regular_Expressions)。
- `change`表示前台应用切换多少次后执行一次自动释放操作。此数值我推荐10-30之间。

我怎么知道要释放哪些应用的内存？你可以通过以命令来获取状态：
```shell
命令: dumpsys activity lru
输出: ACTIVITY MANAGER LRU PROCESSES (dumpsys activity lru)
  Activities:
  #67: fg     TOP  LCMN 6918:bin.mt.plus/u0a226 act:activities|recents
  #66: vis    BFGS ---N 3152:com.miui.home/u0a80 act:activities
  #65: prev   LAST ---- 25424:com.omarea.vtools/u0a672 act:activities|recents
  #64: cch    CAC  ---- 5586:com.kiwibrowser.browser/u0a91 act:activities|recents
  #63: cch    CACC ---- 5961:com.kiwibrowser.browser:kiwi_sandboxed_process0:org.chromium.content.app.KiwiSandboxedProcessService0:4/u0a91i-8996 act:client
  #62: cch+10 CAC  ---- 22204:com.tencent.mobileqq/u0a481 act:activities|recents
  #61: cch+10 CACC ---- 22308:com.tencent.mobileqq:MSF/u0a481 act:client
  #60: cch+20 CACC ---- 5715:com.kiwibrowser.browser:kiwi_privileged_process0/u0a91 act:client
  #59: cch+20 CACC ---- 5748:com.kiwibrowser.browser:kiwi_sandboxed_process0:org.chromium.content.app.KiwiSandboxedProcessService0:1/u0a91i-8999 act:client
  #58: hvy    CAC  ---- 31098:com.coolapk.market/u0a677 act:activities|recents
  #57: hvy    SVC  ---- 9696:com.tencent.mm/u0a201 act:activities|recents
  #56: vis    SVC  ---- 4370:com.google.android.gms/u0a159 act:client
  #55: vis    BFGS ---N 4265:com.google.android.gms.persistent/u0a159 act:client
  #54: hvy    SVC  ---- 9290:com.tencent.mm:push/u0a201 act:client
  #53: cch+30 CACC ---- 6104:com.kiwibrowser.browser:kiwi_sandboxed_process0:org.chromium.content.app.KiwiSandboxedProcessService0:5/u0a91i-8995 act:client
  #52: hvy    CAC  ---- 22734:org.telegram.plus/u0a386 act:activities|recents
  #51: hvy    CAC  ---- 24029:mark.via/u0a222 act:activities|recents
  #50: cch+30 CACC ---- 24074:com.google.android.webview:sandboxed_process0:org.chromium.content.app.SandboxedProcessService0:0/u0a222i1 act:client
  #49: cch+40 CAC  ---- 25274:com.google.android.apps.translate/u0a548 act:activities|recents
  #48: hvy    CAC  ---- 21987:com.github.kr328.clash/u0a329 act:activities|recents
  Other:
  #47: fg     BTOP ---N 4315:com.miui.securitycenter.remote/1000
  #46: vis    BFGS ---N 4948:com.miui.powerkeeper/1000
  #45: cch+ 5 CEM  ---- 4209:com.miui.weather2/u0a203
  #44: vis    BTOP ---N 4853:com.miui.securitycenter.bootaware/1000
  #43: cch+15 CEM  ---- 11717:com.android.mms/u0a66
  #42: cch+25 CEM  ---- 7159:egrn.pucm.pgo/u0a764
  #41: psvc   PER  LCMN 4197:com.android.providers.media.module/u0a197
  #40: prcp   FGS  ---N 5977:com.miui.gallery/u0a68
  #39: vis    FGS  ---N 22036:com.github.kr328.clash:background/u0a329 act:client
  #38: cch+35 SVC  ---- 31061:com.android.settings:remote/1000
  #37: svcb   SVC  ---- 4569:com.xiaomi.xmsf/u0a141
  #36: cch+45 CEM  ---- 5950:com.xiaomi.aiasst.service/1000
  #35: prcp   FGS  ---N 20376:com.miui.misound/u0a126
  #34: fg     BFGS ---N 5543:com.xiaomi.misettings:remote/1000
  #33: fg     FGS  ---N 5665:com.miui.notification:remote/1000
  #32: cch+55 CEM  ---- 4396:com.android.providers.calendar/u0a50
  #31: cch+65 CEM  ---- 9210:com.xiaomi.market:guard/u0a117
  #30: hvy    CEM  ---- 9075:com.xiaomi.joyose/1000
  #29: cch+75 CEM  ---- 8819:com.miui.core/u0a145
  #28: cch+85 CEM  ---- 8352:com.android.shell/2000
  #27: prcp   TRNB ---- 4793:com.lbe.security.miui/u0a52
  #26: vis    BFGS LCMN 5035:com.sohu.inputmethod.sogou.xiaomi/u0a134 act:treated
  #25: pers   PER  LCMN 4180:com.miui.face/1000
  #24: pers   PER  LCMN 4171:com.qualcomm.location/u0a182
  #23: pers   PER  LCMN 4149:org.mipay.android.manager/u0a150
  #22: pers   PER  LCMN 4130:com.tencent.soter.soterserver/u0a151 act:client
  #21: pers   PER  LCMN 4126:com.qualcomm.qti.workloadclassifier/u0a191
  #20: pers   PER  LCMN 4073:com.xiaomi.mircs/u0a76
  #19: pers   PER  LCMN 4081:com.xiaomi.xmsfkeeper/u0a140
  #18: pers   PER  LCMN 4061:com.miui.voicetrigger/u0a102
  #17: pers   PER  LCMN 4038:.slas/1000
  #16: pers   PER  LCMN 4001:system/u0a46
  #15: pers   PER  LCMN 4003:org.ifaa.aidl.manager/u0a149
  #14: pers   PER  LCMN 3996:com.android.nfc/1027
  #13: pers   PER  LCMN 3967:com.miui.contentcatcher/1000
  #12: vis    BFGS LCMN 2913:com.miui.miwallpaper/u0a119
  #11: vis    IMPF ---- 3432:com.android.smspush/u0a187
  #10: pers   PER  LCMN 3135:com.android.systemui/1000
  # 9: pers   PER  LCMN 3119:com.android.phone/1001
  # 8: pers   PER  LCMN 3104:com.xiaomi.finddevice/6110
  # 7: pers   PER  LCMN 3103:com.android.se/1068
  # 6: pers   PER  LCMN 3137:.dataservices/1001
  # 5: pers   PER  LCMN 3106:com.qualcomm.qti.devicestatisticsservice/u0a161
  # 4: pers   PER  LCMN 3094:org.codeaurora.ims/u0a184
  # 3: pers   PER  LCMN 3098:com.qti.qualcomm.mstatssystemservice/u0a186
  # 2: pers   PER  LCMN 3072:com.qti.phone/u0a175
  # 1: pers   PER  LCMN 3051:.qtidataservices/u0a148
  # 0: sys    PER  LCMN 1824:system/1000
```
你大概率不知道进程状态代表什么意思，我简单解释一下：
- PER (Persistent): 这是一个永久状态，表示进程不会被系统杀死。这通常适用于关键系统进程，如系统服务。
- PERU (Persistent and Upward): 这也是一个永久状态，但允许系统在内存不足时终止该进程。这意味着进程在某些情况下可以被杀死，但在大多数情况下将保持运行。
- TOP (Top): 这表示进程是当前可见的前台应用程序，即用户正在与之交互的应用程序。
- BTOP (Bound Top): 这是一个与TOP类似的状态，但是由于内存不足，系统可能会选择终止该进程。它通常发生在设备上运行大量应用程序并且内存不足的情况下。
- FGS (Foreground Service): 表示进程正在提供前台服务。前台服务是一种与用户交互的服务，会显示通知或其他用户界面。
- BFGS (Bound Foreground Service): 类似于FGS，但由于内存不足，系统可能会终止该进程。
- IMPF (Important Background): 表示进程是一个重要的后台进程，正在执行一些关键任务，但不需要在前台显示给用户。
- IMPB (Important Background and Upward): 这是类似于IMPF的状态，但是由于内存不足，系统可能会选择终止该进程。
- TRNB (Trusted Background): 表示进程是一个可信任的后台进程，正在执行一些受信任的任务。
- BKUP (Backup): 表示进程正在执行应用程序备份操作，例如将数据备份到云端或其他存储设备。
- SVC (Service): 表示进程是一个后台服务，正在执行某些功能而不需要在前台显示给用户。
- RCVR (Receiver): 表示进程是一个广播接收器，用于接收和处理系统或应用程序发送的广播消息。
- TPSL (Top Sleeping): 表示进程是顶层睡眠状态，即应用程序处于睡眠状态但仍保持在前台。
- HVY (Heavy Weight): 表示进程是一个重量级进程，通常因为它使用了大量系统资源，如内存或CPU。
- HOME: 表示进程是设备的主屏幕应用程序，即用户所看到的桌面。
- LAST: 表示进程是上一个已经终止的应用程序进程。
- CAC (Cached Activity Client): 表示进程是缓存的活动客户端，通常是在后台运行的应用程序。
- CACC (Cached Recent): 表示进程是缓存的最近活动客户端，通常在内存不足时被终止。
- CRE (Cached Empty): 表示进程是缓存的空进程，它没有任何活动或任务。
- CEM (Cached Empty and Maintained): 表示进程是缓存的空进程，但在内存不足时可能会被终止。
- NONE: 表示进程没有状态或无法确定其状态。

## hook注入相关参数

A1内存管理v4可以使用hook让lmkd无法杀死后台进程。下面是用于控制此行为的参数示例：

```json
"initInjection": {
	"enable": true,
	"processName": "/system/bin/lmkd",
	"symbolsFunc": "hc_hook",
	"libraryPath": "/data/adb/modules/Hc_memory/lib/arm64-v8a/libhook_lmkd.so",
	"lmkd": {
		"memThreshold": {
			"enable": true,
			"value": 90
		},
		"hookFunc": {
			"kill": true,
			"pidfd_send_signal": true,
			"__android_log_print": false,
			"meminfo": {
				"updateTime": 60
			}
		},
		"model": {
			"inlineHook": "dobby"
		}
	}
}
```

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| initInjection     | object   | 初始化注入                                 |
| enable     | bool   | 是否启用hook lmkd                                 |
| processName   | string   | 进程名字                            |
| symbolsFunc   | string   | hook后需要执行的函数名字                        |
| libraryPath   | string   | hook库的路径                           |

你可以修改路径来向指定进程注入你的hook库，进程名字我推荐使用绝对路径。
- `initInjection`表示初始化注入。
- `enable`表示是否启用hook lmkd。如果设置为true，A1内存管理将会hook lmkd；如果设置为false，A1内存管理将不会hook lmkd。

### 内存阈值

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| memThreshold     | object   | 内存阈值                                 |
| enable   | bool   | 是否启用内存阈值                          |
| value   | int   | 当内存占用到达90%，不再阻止lmkd杀进程                          |

内存阈值是很重要的功能，它可以让你在内存占用到达一定程度后，不再阻止lmkd杀进程。这样做的好处是可以防止内存占用过高导致系统卡顿，但是也会导致后台进程被杀死。因此，你可以通过设置内存阈值来控制内存占用到达一定程度后，不再阻止lmkd杀进程。
- `memThreshold`表示内存阈值功能。
- `enable`表示是否启用内存阈值功能。如果设置为true，A1内存管理将会启用内存阈值功能；如果设置为false，A1内存管理将不会启用内存阈值功能。
- `value`表示当内存占用到达90%，不再阻止lmkd杀进程。

### 选择要hook的函数

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| hookFunc     | object   | hook函数                                 |
| kill   | bool   | 是否hook kill函数                          |
| pidfd_send_signal   | bool   | 是否hook pidfd_send_signal函数                          |
| __android_log_print   | bool   | 是否hook __android_log_print函数                          |
| meminfo   | object   | 内存信息                          |
| updateTime   | int   | 更新时间，单位为秒                          |

- `hookFunc`表示hook函数。
- `kill`设置为true以hook kill函数，A1内存管理将会hook kill函数；设置为false则不hook kill函数。
- `pidfd_send_signal`设置为true以hook pidfd_send_signal函数，A1内存管理将会hook pidfd_send_signal函数以阻止结束进程；设置为false则不hook pidfd_send_signal函数。
- `__android_log_print`设置为true以hook __android_log_print函数，A1内存管理将会hook __android_log_print函数；设置为false则不hook __android_log_print函数。不建议启用该功能，因为会导致日志无法输出，还有可能会造成lmkd异常。

### 内存信息刷新时间

有效避免重复刷新meminfo内存信息造成的性能消耗，你可以通过设置更新时间来控制更新的时间间隔。
- `meminfo`内存信息。
- `updateTime`更新已占用内存百分比的时间，推荐取值在30到90之间。数值越大，更新的时间间隔越长，性能消耗越少；数值越小，更新的时间间隔越短，性能消耗越多。

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| model     | object   | 模式                                 |
| inlineHook   | string   | inlineHook模式                          |

- `model`表示模式。
- `inlineHook`默认使用的是[dobby](https://github.com/jmpews/Dobby)来修改函数地址，如果无法正常hook，你可以尝试修改为And64[https://github.com/Rprop/And64InlineHook]。

## 让应用休眠减少CPU和内存使用

A1内存管理v4可以让应用休眠减少CPU和内存使用。下面是用于控制此行为的参数示例：

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| appSleep     | object   | 应用休眠                               |
| enable     | bool   | 是否启用应用休眠减少CPU和内存使用                                 |
| idle   | string   | 空闲后针对用户，all代表全部/current代表当前用户，current对多开不生效                          |
| bg   | string   | 后台应用状态，ignore代表忽略唤醒请求和拉起应用请求                          |
| top   | string   | 前台应用状态，allow代表允许唤醒请求和拉起应用请求                          |

- `enable`设置为true以启用应用休眠以减少CPU和内存使用操作；设置为false则不执行。
- `idle`空闲后针对用户的设置。可选值为all（全部用户）和current（当前用户），其中current对多开不生效。
- `bg`后台应用状态设置。可选值为ignore（忽略唤醒请求和拉起应用请求），allow（允许唤醒请求和拉起应用请求），deny（拒绝唤醒请求和拉起应用请求）。
- `top`前台应用状态设置。可选值和bg参数一样。

## 乖巧模式

简单来说就是杀死应用的子进程，并且试图阻止主进程拉起子进程，从而实现应用减少CPU和内存的使用。
为了满足更多人的需求，A1内存管理v4默认已经包含了一些应用的子进程，但可能仍然无法涵盖所有情况。如果需要KILL其他子进程，你可以通过编辑名单列表.conf文件来添加。以下是名单列表.conf文件的格式示例：
```
KILL 包名:子进程名
```

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| clever     | object   | 乖巧模式                                 |
| enable     | bool   | 是否启用乖巧模式                                 |

## 疯狂杀戮

调用内核的api来杀死一些进程，目前暂不清楚原理，但是可以有效的杀死一些进程。我猜想可能是根据oom数值来判断的。下面是用于控制此行为的参数示例：

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| crazyKill    | object   | 疯狂杀戮                                 |
| enable     | bool   | 是否启用疯狂杀戮                                 |

## 写入内容到文件

A1内存管理v4可以将内容写入到文件中。下面是用于控制此行为的参数示例：

```json
"file": {
    "write": [
        {
            "path": "/proc/sys/fs/inotify/max_queued_events",
            "content": "102400"
        },
        {
            "path": "/proc/sys/fs/inotify/max_user_watches",
            "content": "102400"
        },
        ...
    ]
}
```

上面的示例中，我们将内容写入到了两个文件中，从而启用了inotify功能。

| 字段名   | 类型 | 描述                                           |
| -------- | -------- | ---------------------------------------------- |
| write     | array   | 写入内容到文件                                 |
| path   | string   | 文件路径                          |
| content   | string   | 写入的内容                          |

