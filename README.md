# OnePlus Ace 5 Pro — SukiSU + SUSFS + KPM 内核构建

设备：OnePlus Ace 5 Pro（PKR110 / OP60EBL1 / sun / sm8750 / 4K 页 / A 槽 / 已解锁）
固件：PKR110_16.0.10.500(CN01) / Android 16
原厂内核：`6.6.118-android15-8-g93e223c276e7-abogki500782043-4k`

## 目标
自制同时具备 GKI / AK3 / SukiSU / SUSFS / KPM 的稳定内核，刷入后正常开机，
且在 SukiSU「拓展功能」页看到：KPM=支持、SuSFS=支持、动态管理器=已生效、
CPU 身份伪装=支持、Umount 路径管理=支持。

## 关键结论（2026-10-30 已核实）
- 源码入口是 `oneplus_ace5_pro_b.xml`（**带 _b**），分支 `oneplus/sm8750`，
  对应 b_16.0.0 分支 = 6.6.118。⚠ 不含 _b 的 `oneplus_ace5_pro.xml` 是 6.6.66（禁用）。
- 构建：`build_with_bazel.py -t sun perf`（bazel 放 kernel_platform/tools/bazel）。
- 补丁：SukiSU-Ultra kernel/（CONFIG_KSU、CONFIG_KPM）+ ShirkNeko/susfs4ksu@gki-android15-6.6（CONFIG_KSU_SUSFS）。
- 必须复刻 localversion `-g93e223c276e7-abogki500782043-4k`，否则 vendor_dlkm 模块 vermagic 不匹配。
- 只刷 boot（不带 dtb），先 `fastboot boot` 试启动。

## 构建参数
- CPU=sm8750，FEIL=oneplus_ace5_pro_b，CPUD=sun，VARIANT=perf
- ENABLE_KPM=true，ENABLE_SUSFS=true

## 操作顺序
1. 备份（见 backup.cmd / backup.sh）
2. 建仓 + 首轮 DRY_RUN=true 跑 CI
3. 通过后 DRY_RUN=false 正式构建
4. 产物验收（见下）
5. 刷入（先 fastboot boot 试启动）

## 产物验收
```
unzip -l AnyKernel3-sun-sm8750-b16-*.zip        # 只有 Image+anykernel.sh+META-INF，无 dtb
grep -a "Linux version" Image                   # = 6.6.118-android15-8-g93e223c276e7-abogki500782043-4k
grep -E "CONFIG_(KSU|KPM|KSU_SUSFS)=y" .config  # 三项全 y
grep "CONFIG_ARM64_4K_PAGES=y" .config          # 4K
```

## 无限重启恢复
```
fastboot flash boot 备份的boot_<槽>.img   # 不擦 data、不切槽
```
