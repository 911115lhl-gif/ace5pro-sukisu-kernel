@echo off
setlocal
set "ADB=%~dp0platform-tools\adb.exe"
set "BK=%~dp0backup"
chcp 65001 >nul
echo ============================================================
echo  OnePlus Ace 5 Pro - backup stock partitions
echo ============================================================
echo.
"%ADB%" wait-for-device
echo Device connected.
echo.
echo [Step 1] dump partitions to /sdcard ...
for %%p in (boot_a boot_b init_boot_a init_boot_b vendor_boot_a vendor_boot_b dtbo_a dtbo_b) do (
  echo    %%p ...
  "%ADB%" shell /system/bin/su -c "dd if=/dev/block/bootdevice/by-name/%%p of=/sdcard/%%p.img bs=4096"
)
echo.
echo [Step 2] pull to backup folder ...
if not exist "%BK%" mkdir "%BK%"
for %%p in (boot_a boot_b init_boot_a init_boot_b vendor_boot_a vendor_boot_b dtbo_a dtbo_b) do (
  "%ADB%" pull "/sdcard/%%p.img" "%BK%\%%p.img"
)
echo.
echo ============================================================
echo  Done. Verify: 8 img files in backup\, none 0 bytes.
echo  Copy backup\ to another disk.
echo ============================================================
pause
