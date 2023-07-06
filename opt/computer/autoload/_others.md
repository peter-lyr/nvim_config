# 锁定计算机

```bat
start rundll32.exe user32.dll,LockWorkStation
```

# 重置网络

```bat
netsh int ip reset
netsh winsock reset
```

# 重启电脑

```bat
start Rundll32.exe shell32.dll,RestartDialog
```

# 蓝牙属性面板

```bat
start ms-settings:bluetooth
```

# 关闭计算机

```bat
shutdown /s /t 0
```

# 列出git忽略文件

```bat
git ls-files --exclude-standard --ignored --others
```
