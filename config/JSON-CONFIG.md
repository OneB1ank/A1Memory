# Description of A1 memory management v4 Json configuration file

A1 Memory Management v4 utilizes the HAMv2 framework, allowing you to adjust memory management parameters through configuration files without modifying the source code. This document will provide a detailed guide on how to configure the JSON configuration file.

## Customizing Modules Parameters

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

| Field Name | Type   | Description                                                                                                             |
| ---------- | ------ | ----------------------------------------------------------------------------------------------------------------------- |
| path       | string | The path to the configuration file.                                                                                     |
| modulePath | string | The path to the module name.                                                                                            |
| name       | string | The filename of the configuration list file, which stores the whitelist and naughty list.                               |
| optional   | bool   | Indicates whether the whitelist is enabled. When enabled, processes in the whitelist will not be killed.                |
| smart      | bool   | Indicates whether the smart whitelist is enabled. When enabled, processes will be automatically added to the whitelist. |
| system     | bool   | Indicates whether the system whitelist is enabled. When enabled, all system software will be added to the whitelist.    |

Please note that when adding entries to the whitelist, they should follow the following format:

```
WHITE PackageName
```

## Log path/level

Logging Runtime Logs for A1 Memory Management v4, which can be Adjusted by Modifying Log Path and Log Level.

```json
"log": {
    "path": "/sdcard/Android/HChai/HC_memory/Run.log",
    "level": "info"
}
```

| Field Name | Type   | Description                                                           |
| ---------- | ------ | --------------------------------------------------------------------- |
| path       | string | The path to the log file.                                             |
| level      | string | The log level. Available options: debug, info, warn, err, critical. |

If you wish to disable logging, you can set the log level to "critical". Alternatively, if you only want to view logs related to runtime errors, you can set the log level to "warn".

## Main function running parameters

The purpose of this parameter is to prevent the execution of the main function when switching to a foreground process within a certain period of time after a change in the foreground application.

```json
"initProcess": {
    "afterTopChange": {
        "sleep": 1
    }
}
```

| Field Name | Type | Description                  |
| ---------- | ---- | ---------------------------- |
| sleep      | int  | The waiting time in seconds. |

The "sleep" parameter represents the waiting time, in seconds, after a change in the foreground application. Setting it to 1 second means that after a change in the foreground application, the main function will wait for 1 second before being executed again upon switching to the foreground. In other words, during this 1-second interval of foreground switching, the main function will not be executed.
This parameter can be used to control the avoidance of repetitive execution of the main function within a certain period of time after a change in the foreground application. It helps prevent unnecessary operations or resource wastage.

## A1 memory management ends unnecessary processes

A1 Memory Management v4 can terminate unnecessary processes to free up memory. Here is an example of the parameters used to control this behavior:

```json
"a1Memory": {
    "enable": true,
    "oomAdj": 905
}
```

| Field Name | Type | Description                                                                                   |
| ---------- | ---- | --------------------------------------------------------------------------------------------- |
| enable     | bool | Indicates whether to enable the termination of unnecessary processes by A1 Memory Management. |
| oomAdj     | int  | Only processes with an oomAdj value greater than the specified value will be terminated.      |

- `enable`: Specifies whether to enable A1 Memory Management to terminate unnecessary processes. When set to true, A1 Memory Management will perform process termination. When set to false, A1 Memory Management will not terminate any processes.
- `oomAdj`: Represents the adjustment value used to determine whether a process should be terminated. Only processes with an oomAdj value greater than the specified "oomAdj" value will be terminated by A1 Memory Management. The "oomAdj" value ranges from 0 to 1000. A higher value will result in fewer terminated processes, while a lower value will result in more terminated processes. It is important to note that not all processes will be identified and terminated. Only processes deemed unnecessary by the algorithm and with an oomAdj value higher than the specified threshold will be terminated.

## Let the application automatically release memory

A1 Memory Management v4 can enable automatic memory release for applications. Here is an example of the parameters used to control this behavior:

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

| Field Name | Type   | Description                                                                                          |
| ---------- | ------ | ---------------------------------------------------------------------------------------------------- |
| enable     | bool   | Indicates whether to enable automatic memory release for applications.                               |
| level      | string | A value between 0 and 100, where higher values result in more memory being released.                 |
| regex      | string | A regular expression used to match the application status for which memory release is required.      |
| change     | int    | Specifies the number of foreground switches before triggering an automatic memory release operation. |

- `enable`: Specifies whether to enable automatic memory release for applications. When set to true, A1 Memory Management will perform automatic memory release operations for applications. When set to false, A1 Memory Management will not perform automatic memory release operations.
- `level`: Determines the extent of memory release. The value ranges from 0 to 100, where higher values indicate a greater amount of memory being released, and lower values indicate less memory being released.
- `regex`: Specifies a regular expression used to match the application status for which memory release is required. Only applications that match the defined regex pattern will have their memory released. The regex pattern follows the same rules as the JavaScript language. You can refer to[this link](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Regular_Expressions)for more information on regular expressions in JavaScript.
- `change`: Specifies the number of foreground application switches before triggering an automatic memory release operation. It is recommended to set this value between 10 and 30.

How do I know which applications' memory needs to be released? You can obtain the status by using a command:
```shell
Command: dumpsys activity lru
Output: ACTIVITY MANAGER LRU PROCESSES (dumpsys activity lru)
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
You are correct that you may not be familiar with the meaning of the process states. Let me provide a brief explanation:
- PER (Persistent): This is a permanent state indicating that the process will not be killed by the system. It typically applies to critical system processes, such as system services.
- PERU (Persistent and Upward): This is also a permanent state but allows the system to terminate the process when memory is low. This means the process can be killed under certain circumstances but will generally remain running.
- TOP (Top): This indicates that the process is the currently visible foreground application, meaning the application with which the user is actively interacting.
- BTOP (Bound Top): This is a state similar to TOP, but the system may choose to terminate the process due to memory constraints. This often occurs when the device is running multiple applications and memory is scarce.
- FGS (Foreground Service): It indicates that the process is providing a foreground service. Foreground services are services that interact with the user and may display notifications or other user interfaces.
- BFGS (Bound Foreground Service): Similar to FGS, but the system may terminate the process due to memory constraints.
- IMPF (Important Background): This indicates that the process is an important background process performing critical tasks but does not need to be shown in the foreground to the user.
- IMPB (Important Background and Upward): This is a state similar to IMPF, but the system may choose to terminate the process due to memory constraints.
- TRNB (Trusted Background): It represents a trusted background process performing trusted tasks.
- BKUP (Backup): It signifies that the process is performing application backup operations, such as backing up data to the cloud or other storage devices.
- SVC (Service): It denotes that the process is a background service performing certain functionalities without the need to be displayed in the foreground to the user.
- RCVR (Receiver): It indicates that the process is a broadcast receiver used to receive and handle broadcast messages sent by the system or applications.
- TPSL (Top Sleeping): It represents a process in the top-level sleep state, where the application is in sleep mode but still remains in the foreground.
- HVY (Heavy Weight): It signifies that the process is a heavyweight process, usually because it utilizes a significant amount of system resources, such as memory or CPU.
- HOME: It indicates that the process is the main home screen application of the device, i.e., the user's desktop.
- LAST: It represents the process of the previously terminated application.
- CAC (Cached Activity Client): It signifies that the process is a cached activity client, typically an application running in the background.
- CACC (Cached Recent): It represents a cached recent activity client that is often terminated when memory is low.
- CRE (Cached Empty): It indicates that the process is a cached empty process with no active tasks.
- CEM (Cached Empty and Maintained): It denotes a cached empty process that may be terminated when memory is low.
- NONE: It signifies that the process has no state or its state cannot be determined.

## Hook injection related parameters

A1 Memory Management v4 can utilize hooks to prevent lmkd (low memory killer daemon) from killing background processes. Below is an example of the parameters used to control this behavior:

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

| Field Name    | Type   | Description                                        |
| ------------- | ------ | -------------------------------------------------- |
| initInjection | object | Initialization injection configuration.            |
| enable        | bool   | Indicates whether to enable lmkd hooking.          |
| processName   | string | The name of the process.                           |
| symbolsFunc   | string | The name of the function to execute after hooking. |
| libraryPath   | string | The path to the hook library.                      |

You can modify the path to inject your hook library into the specified process. I recommend using the absolute path for the process name.
- `initInjection`: Represents the configuration for initialization injection.
- `enable`Indicates whether to enable lmkd hooking. When set to true, A1 Memory Management will hook lmkd. When set to false, A1 Memory Management will not hook lmkd.

### memory threshold 

| Field Name   | Type   | Description                                                                            |
| ------------ | ------ | -------------------------------------------------------------------------------------- |
| memThreshold | object | Memory threshold configuration.                                                        |
| enable       | bool   | Indicates whether to enable the memory threshold.                                      |
| value        | int    | The value at which the memory usage reaches 90%, allowing lmkd to terminate processes. |

The memory threshold feature is important as it allows you to stop preventing lmkd from terminating processes when the memory usage reaches a certain level. This feature helps prevent excessive memory usage, which can lead to system lag, but it may result in background processes being terminated. Therefore, you can control the prevention of lmkd from terminating processes by setting the memory threshold.
- `memThreshold`: Represents the memory threshold feature.
- `enable`: Indicates whether to enable the memory threshold feature. When set to true, A1 Memory Management will enable the memory threshold feature. When set to false, A1 Memory Management will not enable the memory threshold feature.
- `value`:  Specifies the threshold at which the memory usage reaches 90%. Once the memory usage exceeds this threshold, A1 Memory Management will no longer prevent lmkd from terminating processes.

### Selecting the functions to hook

| Field Name          | Type   | Description                                                   |
| ------------------- | ------ | ------------------------------------------------------------- |
| hookFunc            | object | Function hook configuration.                                  |
| kill                | bool   | Indicates whether to hook the `kill` function.                |
| pidfd_send_signal   | bool   | Indicates whether to hook the `pidfd_send_signal` function.   |
| __android_log_print | bool   | Indicates whether to hook the `__android_log_print` function. |
| meminfo             | object | Memory information configuration.                             |
| updateTime          | int    | Update time in seconds for the memory information.            |

- `hookFunc`: Represents the function hook configuration.
- `kill`: When set to true, A1 Memory Management will hook the `kill` function. When set to false, A1 Memory Management will not hook the `kill` function.
- `pidfd_send_signal`: When set to true, A1 Memory Management will hook the `pidfd_send_signal` function to prevent process termination. When set to false, A1 Memory Management will not hook the `pidfd_send_signal` function.
- `__android_log_print`: When set to true, A1 Memory Management will hook the `__android_log_print` function. When set to false, A1 Memory Management will not hook the `__android_log_print` function. It is not recommended to enable this feature as it may prevent log outputs and potentially cause lmkd abnormalities.

### Memory information refresh time

To efficiently avoid performance impact caused by repetitive refreshing of meminfo memory information, you can control the update interval by setting the updateTime parameter.
- `meminfo`: Represents the memory information.
- `updateTime`: Specifies the update interval for the occupied memory percentage. It is recommended to set the value between 30 and 90. A higher value results in longer update intervals and lower performance impact, while a lower value leads to shorter update intervals and higher performance impact.

| Field Name | Type   | Description         |
| ---------- | ------ | ------------------- |
| model      | object | Mode configuration. |
| inlineHook | string | Inline hook mode.   |

- `model`Represents the mode configuration.
- `inlineHook`By default, A1 Memory Management v4 uses[dobby](https://github.com/jmpews/Dobby)for modifying function addresses. If the hooking process is not working as expected, you can try modifying it to [And64InlineHook](https://github.com/Rprop/And64InlineHook).
## Enabling app hibernation reduces CPU and memory usage.

A1 Memory Management v4 can enable app hibernation to reduce CPU and memory usage. Here is an example of the parameters used to control this behavior:

| Field Name | Type   | Description                                                                                                                                                              |
| ---------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| appSleep   | object | App hibernation configuration.                                                                                                                                           |
| enable     | bool   | Indicates whether to enable app hibernation to reduce CPU and memory usage.                                                                                              |
| idle       | string | User idle setting: "all" for all users, "current" for the current user (not applicable to multi-user environments).                                                      |
| bg         | string | Background app status setting: "ignore" to ignore wake-up and launch requests, "allow" to allow wake-up and launch requests, "deny" to deny wake-up and launch requests. |
| top        | string | Foreground app status setting: Same options as `bg`.                                                                                                                     |

- `enable`: Set to true to enable app hibernation and reduce CPU and memory usage; set to false to disable it.
- `idle`: User idle setting. Available values are "all" (all users) and "current" (the current user). Note that "current" setting does not apply in multi-user environments.
- `bg`: Background app status setting. Available values are "ignore" (ignore wake-up and launch requests), "allow" (allow wake-up and launch requests), and "deny" (deny wake-up and launch requests).
- `top`: Foreground app status setting. Same options as `bg` parameter.

## Clever Mode

In simple terms, Clever Mode is designed to kill an application's child processes and attempt to prevent the main process from relaunching the child processes, thereby reducing the CPU and memory usage of the application.
To meet the diverse needs of users, A1 Memory Management v4 already includes some child processes of applications by default. However, it may not cover all scenarios. If you need to kill other child processes, you can add them by editing the whitelist.conf file. Here is an example of the format for the whitelist.conf file:
```
KILL package_name:child_process_name
```

| Field Name | Type   | Description                              |
| ---------- | ------ | ---------------------------------------- |
| clever     | object | Clever Mode configuration.               |
| enable     | bool   | Indicates whether to enable Clever Mode. |

## Crazy Kill

The Crazy Kill feature utilizes kernel APIs to kill certain processes. Currently, the exact mechanism behind it is not clear, but it can effectively terminate specific processes. It is speculated that it may be based on the OOM (Out of Memory) score of the processes. Below is an example of the parameters used to control this behavior:

| Field Name | Type   | Description                             |
| ---------- | ------ | --------------------------------------- |
| crazyKill  | object | Crazy Kill configuration.               |
| enable     | bool   | Indicates whether to enable Crazy Kill. |

## Write Content to File

You can write content to files using A1 Memory Management v4. Below is an example of the parameters used to control this behavior:

```json
"file": {
    "write": [
        {KV
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

In the above example, we write content to two files, enabling the inotify feature.

| Field Name | Type   | Description                     |
| ---------- | ------ | ------------------------------- |
| write      | array  | Write content to files.         |
| path       | string | File path.                      |
| content    | string | Content to write into the file. |

### Restart the Phone or Terminate HC_memory Process to Apply Configuration Changes

## Acknowledgments

Thanks to the following users or projects for their source code contributions to this project:  
- [@yc9559](https://github.com/yc9559)
- [@HChenX](https://github.com/HChenX)

Thanks to the following users for their testing feedback and bug identification:
- @火機(coolapk)

## Support Donations
If you find this module useful, you can make a donation to support me.
- [爱发电](https://afdian.net/a/HCha1)
- [patreon](https://patreon.com/A1memory)
- USDT(TRC20)
  > Address: TSqTqn2NcyUAbEwsdGgsrYoU5pokno5PnQ

