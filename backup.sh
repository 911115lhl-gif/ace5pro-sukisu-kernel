#!/usr/bin/env bash
# OnePlus Ace 5 Pro 原厂分区备份（macOS/Linux 环境）
set -e
echo "== 手机 dump 分区 =="
for p in boot_a boot_b init_boot_a init_boot_b vendor_boot_a vendor_boot_b dtbo_a dtbo_b; do
  echo "  $p"
  adb shell su -c "dd if=/dev/block/bootdevice/by-name/$p of=/sdcard/$p.img bs=4096"
done
mkdir -p backup
for p in boot_a boot_b init_boot_a init_boot_b vendor_boot_a vendor_boot_b dtbo_a dtbo_b; do
  adb pull "/sdcard/$p.img" "backup/$p.img"
done
echo "== 完成，备份在 backup/ =="
