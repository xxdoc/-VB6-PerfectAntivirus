        ��  ��                  �  ,   T A N G T O C   ��e     0	        Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters]
"EnablePrefetcher"=dword:00000005
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AlwaysUnloadDLL]
@="1"
[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\FileSystem]
"NtfsDisableLastAccessUpdate"=dword:00000001
[HKEY_CURRENT_USER\Control Panel\Desktop]
"AutoEndTasks"="1"
[HKEY_CURRENT_USER\Control Panel\Desktop]
"HungAppTimeout"="200"
[HKEY_CURRENT_USER\Control Panel\Desktop]
"WaitToKillAppTimeOut"="200"
[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Contro l]
"WaitToKillServiceTimeout"="200"
[HKEY_CURRENT_USER\Control Panel\Desktop]
"MenuShowDelay"="0"




[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ServerAdminUI"=dword:00000000
"Hidden"=dword:00000002
"ShowCompColor"=dword:00000001
"HideFileExt"=dword:00000000
"DontPrettyPath"=dword:00000000
"ShowInfoTip"=dword:00000001
"HideIcons"=dword:00000000
"MapNetDrvBtn"=dword:00000000
"WebView"=dword:00000001
"Filter"=dword:00000000
"SuperHidden"=dword:00000000
"SeparateProcess"=dword:00000000
"ListviewAlphaSelect"=dword:00000000
"ListviewShadow"=dword:00000001
"ListviewWatermark"=dword:00000001
"TaskbarAnimations"=dword:00000000
"StartMenuInit"=dword:00000002
"StartButtonBalloonTip"=dword:00000002
"CascadeNetworkConnections"="YES"
"NoNetCrawling"=dword:00000001
"FolderContentsInfoTip"=dword:00000001
"FriendlyTree"=dword:00000001
"WebViewBarricade"=dword:00000000
"DisableThumbnailCache"=dword:00000000
"ShowSuperHidden"=dword:00000000
"ClassicViewState"=dword:00000000
"PersistBrowsers"=dword:00000000
"EnableBallonTips"=dword:00000000   �	  ,   T A N G T O C   ��f     0	        Windows Registry Editor Version 5.00

; 1 - Tang toc do truy xuat Start Menu
;[HKEY_CURRENT_USER\Control Panel\Desktop]  
;"MenuShowDelay"="400"

; 2 - Khong nap cac thu vien he thong vao Bo nho ao (Virtual Memory). Chuc nang nay su dung khi bo nho Ram cua ban >=256Mb
;[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management]
;"DisablePagingExecutive"=dword:00000001

; 3 - Tat che do cap nhat thoi gian truy cap File cua Windows, giup he thong nhanh hon nho khong can ton thoi gian doc ghi cac thoi gian truy cap nay
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
"NtfsDisableLastAccessUpdate"=dword:00000001

; 4 - Thiet lap cho Windows go bo hoan toan cac DLL ra khoi bo nho khi thoat chuong trinh lien quan, nham tranh day bo nho khi hoat dong.
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
"AlwaysUnloadDLL"=dword:00000001

; 5 - Thiet lap cac thong so tang toc khi truy cap mang
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters]
;"CacheHashTableBucketSize"=dword:00000001
"CacheHashTableSize"=dword:00000180
;"MaxCacheEntryTtlLimit"=dword:0000fa00
;"MaxSOACacheEntryTtlLimit"=dword:0000012d

; 6 - Tang suc hoat dong cua bo nho ao  
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management]
"DisablePagingExecutive"=dword:00000001
"LargeSystemCache"=dword:00000001

; 7 - Tang toc nap san du lieu
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters]
"EnablePrefetcher"=dword:00000005

; 8 - Tang toc tat may xuong con 5-15 giay tuy cau hinh may
[HKEY_CURRENT_USER\Control Panel\Desktop] 
"AutoEndTasks"="1"
"WaitToKillAppTimeout"="3500"
"HungAppTimeout"="5000"
"WaitToKillServiceTimeout"="500"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\SetControl\]
"WaitToKillServiceTimeout"="500"

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control]
"WaitToKillServiceTimeout"="500"

; 9 - Tang toc khoi dong tu 5-8 giay tuy cau hinh 
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction]
"Enable"="N"

; 10 - Tang toc hoat dong cua o dia quang (CDROM-DVD-CD RW�)
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control]
"CacheSize"=hex:ff,ff,00,00
"Prefetch"=dword:00004000
"PrefetchTail"=dword:00004000

;11 - Tang toc truy cap dia mem
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Fdc]
"ForeFifo"=dword:00000000
  