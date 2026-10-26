@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "OUTPUT_FILE=sysinfo_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt"
set "OUTPUT_FILE=!OUTPUT_FILE: =0!"

title System Information - PowerShell
cls

echo ========================================
echo   SYSTEM INFORMATION (PowerShell)
echo ========================================
echo.

call :show_section "OPERATING SYSTEM"
powershell -NoProfile -Command ^
  "$os = Get-CimInstance Win32_OperatingSystem; "^
  "Write-Host ('OS:            ' + $os.Caption); "^
  "Write-Host ('Version:       ' + $os.Version); "^
  "Write-Host ('Build:         ' + $os.BuildNumber); "^
  "Write-Host ('Architecture:  ' + $os.OSArchitecture); "^
  "Write-Host ('Language:      ' + $os.OSLanguage); "^
  "Write-Host ('User:          ' + $os.RegisteredUser); "^
  "Write-Host ('Organization:  ' + $os.Organization); "^
  "Write-Host ('Last Boot:     ' + $os.LastBootUpTime); "^
  "Write-Host ('Uptime:        ' + (New-TimeSpan -Start $os.LastBootUpTime -End (Get-Date) | ForEach-Object { '{0}d {1}h {2}m' -f $_.Days, $_.Hours, $_.Minutes })); "^
  "Write-Host ('System Dir:    ' + $os.WindowsDirectory)"
echo.

call :show_section "PROCESSOR (CPU)"
powershell -NoProfile -Command ^
  "$cpu = Get-CimInstance Win32_Processor; "^
  "foreach ($c in $cpu) { "^
  "  Write-Host ('Name:          ' + $c.Name); "^
  "  Write-Host ('Manufacturer:  ' + $c.Manufacturer); "^
  "  Write-Host ('Cores (phys):  ' + $c.NumberOfCores); "^
  "  Write-Host ('Threads (log): ' + $c.NumberOfLogicalProcessors); "^
  "  Write-Host ('Max Clock:     ' + $c.MaxClockSpeed + ' MHz'); "^
  "  Write-Host ('Curr Clock:    ' + $c.CurrentClockSpeed + ' MHz'); "^
  "  Write-Host ('L2 Cache:      ' + [math]::Round($c.L2CacheSize / 1024, 2) + ' MB'); "^
  "  Write-Host ('L3 Cache:      ' + [math]::Round($c.L3CacheSize / 1024, 2) + ' MB') "^
  "}"
echo.

call :show_section "MEMORY (RAM)"
powershell -NoProfile -Command ^
  "$ram = Get-CimInstance Win32_PhysicalMemory; "^
  "$total = 0; "^
  "foreach ($r in $ram) { "^
  "  $total += $r.Capacity; "^
  "  Write-Host ('Module:        ' + [math]::Round($r.Capacity / 1GB, 2) + ' GB - ' + $r.Manufacturer + ' ' + $r.PartNumber + ' (' + $r.Speed + ' MHz)') "^
  "}; "^
  "Write-Host ('---'); "^
  "$os = Get-CimInstance Win32_OperatingSystem; "^
  "Write-Host ('Total:         ' + [math]::Round($total / 1GB, 2) + ' GB'); "^
  "Write-Host ('Available:     ' + [math]::Round($os.FreePhysicalMemory / 1MB, 2) + ' GB'); "^
  "Write-Host ('In Use:        ' + [math]::Round(($total - ($os.FreePhysicalMemory * 1024)) / 1GB, 2) + ' GB')"
echo.

call :show_section "DISKS"
powershell -NoProfile -Command ^
  "$disks = Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3'; "^
  "foreach ($d in $disks) { "^
  "  $sizeGB = [math]::Round($d.Size / 1GB, 2); "^
  "  $freeGB = [math]::Round($d.FreeSpace / 1GB, 2); "^
  "  $usedGB = [math]::Round(($d.Size - $d.FreeSpace) / 1GB, 2); "^
  "  $pct = [math]::Round(($d.FreeSpace / $d.Size) * 100, 1); "^
  "  Write-Host ('[' + $d.DeviceID + '] ' + $d.VolumeName); "^
  "  Write-Host ('  File System:  ' + $d.FileSystem); "^
  "  Write-Host ('  Total Size:   ' + $sizeGB + ' GB'); "^
  "  Write-Host ('  Used:         ' + $usedGB + ' GB'); "^
  "  Write-Host ('  Free:         ' + $freeGB + ' GB (' + $pct + '%%)'); "^
  "  Write-Host '' "^
  "}"
echo.

call :show_section "GRAPHICS CARDS (GPU)"
powershell -NoProfile -Command ^
  "$gpu = Get-CimInstance Win32_VideoController; "^
  "foreach ($g in $gpu) { "^
  "  Write-Host ('Name:          ' + $g.Name); "^
  "  Write-Host ('Manufacturer:  ' + $g.AdapterCompatibility); "^
  "  Write-Host ('VRAM:          ' + [math]::Round($g.AdapterRAM / 1GB, 2) + ' GB'); "^
  "  Write-Host ('Resolution:    ' + $g.CurrentHorizontalResolution + 'x' + $g.CurrentVerticalResolution + ' @ ' + $g.CurrentRefreshRate + 'Hz'); "^
  "  Write-Host ('Driver:        ' + $g.DriverVersion + ' (' + $g.DriverDate + ')') "^
  "}"
echo.

call :show_section "NETWORK ADAPTERS"
powershell -NoProfile -Command ^
  "$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=True'; "^
  "foreach ($a in $adapters) { "^
  "  Write-Host ('Interface:     ' + $a.Description); "^
  "  Write-Host ('MAC Address:   ' + $a.MACAddress); "^
  "  if ($a.IPAddress) { Write-Host ('IPv4:          ' + ($a.IPAddress | Where-Object { $_ -match '\d+\.\d+\.\d+\.\d+' })) }; "^
  "  if ($a.IPSubnet) { Write-Host ('Subnet Mask:   ' + ($a.IPSubnet | Select-Object -First 1)) }; "^
  "  if ($a.DefaultIPGateway) { Write-Host ('Gateway:       ' + ($a.DefaultIPGateway | Select-Object -First 1)) }; "^
  "  if ($a.DNSServerSearchOrder) { Write-Host ('DNS:           ' + ($a.DNSServerSearchOrder -join ', ')) }; "^
  "  if ($a.DHCPEnabled) { Write-Host ('DHCP:          Enabled (' + $a.DHCPServer + ')') } else { Write-Host ('DHCP:          Disabled') }; "^
  "  Write-Host '' "^
  "}"
echo.

call :show_section "MOTHERBOARD / BIOS"
powershell -NoProfile -Command ^
  "$cs = Get-CimInstance Win32_ComputerSystem; "^
  "$mb = Get-CimInstance Win32_BaseBoard; "^
  "$bios = Get-CimInstance Win32_BIOS; "^
  "Write-Host ('PC Manufacturer: ' + $cs.Manufacturer); "^
  "Write-Host ('PC Model:        ' + $cs.Model); "^
  "Write-Host ('PC Name:         ' + $cs.Name); "^
  "Write-Host ('MB Manufacturer: ' + $mb.Manufacturer); "^
  "Write-Host ('MB Model:        ' + $mb.Product); "^
  "Write-Host ('MB Version:      ' + $mb.Version); "^
  "Write-Host ('BIOS Vendor:     ' + $bios.Manufacturer); "^
  "Write-Host ('BIOS Version:    ' + $bios.SMBIOSBIOSVersion); "^
  "Write-Host ('BIOS Date:       ' + $bios.ReleaseDate)"
echo.

call :show_section "USB DEVICES"
powershell -NoProfile -Command ^
  "$usb = Get-PnpDevice -Class USB -Status OK | Select-Object -First 15; "^
  "foreach ($u in $usb) { "^
  "  Write-Host (' - ' + $u.FriendlyName) "^
  "}"
echo.

call :show_section "STARTUP PROGRAMS"
powershell -NoProfile -Command ^
  "$startup = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location -First 15; "^
  "foreach ($s in $startup) { "^
  "  Write-Host ('[' + $s.Location + '] ' + $s.Name); "^
  "  Write-Host ('  ' + $s.Command); "^
  "  Write-Host '' "^
  "}"
echo.

echo ========================================
echo   SAVING TO FILE: !OUTPUT_FILE!
echo ========================================

call :save_to_file

echo.
echo Done! Report saved as: !OUTPUT_FILE!
echo.
pause
endlocal
goto :eof

:show_section
echo ========================================
echo   %~1
echo ========================================
goto :eof

:save_to_file
(
  echo ========================================
  echo   SYSTEM INFORMATION - PowerShell
  echo   Date: %date% %time%
  echo ========================================
  echo.
) > "!OUTPUT_FILE!"

powershell -NoProfile -Command ^
  "$os = Get-CimInstance Win32_OperatingSystem; "^
  "$out = '--- OPERATING SYSTEM ---' + [Environment]::NewLine; "^
  "$out += 'OS:            ' + $os.Caption + [Environment]::NewLine; "^
  "$out += 'Version:       ' + $os.Version + [Environment]::NewLine; "^
  "$out += 'Build:         ' + $os.BuildNumber + [Environment]::NewLine; "^
  "$out += 'Architecture:  ' + $os.OSArchitecture + [Environment]::NewLine; "^
  "$out += 'Language:      ' + $os.OSLanguage + [Environment]::NewLine; "^
  "$out += 'User:          ' + $os.RegisteredUser + [Environment]::NewLine; "^
  "$out += 'Organization:  ' + $os.Organization + [Environment]::NewLine; "^
  "$out += 'Last Boot:     ' + $os.LastBootUpTime + [Environment]::NewLine; "^
  "$out += 'System Dir:    ' + $os.WindowsDirectory + [Environment]::NewLine; "^
  "$out += [Environment]::NewLine; "^
  "$out | Out-File -FilePath (Join-Path $PWD $env:OUTPUT_FILE) -Append -Encoding UTF8"

powershell -NoProfile -Command ^
  "$cpu = Get-CimInstance Win32_Processor; "^
  "$out = ''; "^
  "$out += '--- PROCESSOR (CPU) ---' + [Environment]::NewLine; "^
  "foreach ($c in $cpu) { "^
  "  $out += 'Name:          ' + $c.Name + [Environment]::NewLine; "^
  "  $out += 'Manufacturer:  ' + $c.Manufacturer + [Environment]::NewLine; "^
  "  $out += 'Cores (phys):  ' + $c.NumberOfCores + [Environment]::NewLine; "^
  "  $out += 'Threads (log): ' + $c.NumberOfLogicalProcessors + [Environment]::NewLine; "^
  "  $out += 'Max Clock:     ' + $c.MaxClockSpeed + ' MHz' + [Environment]::NewLine; "^
  "  $out += 'Curr Clock:    ' + $c.CurrentClockSpeed + ' MHz' + [Environment]::NewLine; "^
  "  $out += 'L2 Cache:      ' + [math]::Round($c.L2CacheSize / 1024, 2) + ' MB' + [Environment]::NewLine; "^
  "  $out += 'L3 Cache:      ' + [math]::Round($c.L3CacheSize / 1024, 2) + ' MB' + [Environment]::NewLine; "^
  "}; "^
  "$out += [Environment]::NewLine; "^
  "$out | Out-File -FilePath (Join-Path $PWD $env:OUTPUT_FILE) -Append -Encoding UTF8"

powershell -NoProfile -Command ^
  "$ram = Get-CimInstance Win32_PhysicalMemory; "^
  "$total = 0; $out = ''; "^
  "$out += '--- MEMORY (RAM) ---' + [Environment]::NewLine; "^
  "foreach ($r in $ram) { $total += $r.Capacity; $out += 'Module: ' + [math]::Round($r.Capacity / 1GB, 2) + ' GB - ' + $r.Manufacturer + ' ' + $r.PartNumber + ' (' + $r.Speed + ' MHz)' + [Environment]::NewLine }; "^
  "$os = Get-CimInstance Win32_OperatingSystem; "^
  "$out += '---' + [Environment]::NewLine; "^
  "$out += 'Total:     ' + [math]::Round($total / 1GB, 2) + ' GB' + [Environment]::NewLine; "^
  "$out += 'Available: ' + [math]::Round($os.FreePhysicalMemory / 1MB, 2) + ' GB' + [Environment]::NewLine; "^
  "$out += 'In Use:    ' + [math]::Round(($total - ($os.FreePhysicalMemory * 1024)) / 1GB, 2) + ' GB' + [Environment]::NewLine; "^
  "$out += [Environment]::NewLine; "^
  "$out | Out-File -FilePath (Join-Path $PWD $env:OUTPUT_FILE) -Append -Encoding UTF8"

powershell -NoProfile -Command ^
  "$disks = Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3'; "^
  "$out = '--- DISKS ---' + [Environment]::NewLine; "^
  "foreach ($d in $disks) { "^
  "  $sizeGB = [math]::Round($d.Size / 1GB, 2); "^
  "  $freeGB = [math]::Round($d.FreeSpace / 1GB, 2); "^
  "  $usedGB = [math]::Round(($d.Size - $d.FreeSpace) / 1GB, 2); "^
  "  $pct = [math]::Round(($d.FreeSpace / $d.Size) * 100, 1); "^
  "  $out += '[' + $d.DeviceID + '] ' + $d.VolumeName + [Environment]::NewLine; "^
  "  $out += '  File System:  ' + $d.FileSystem + [Environment]::NewLine; "^
  "  $out += '  Total Size:   ' + $sizeGB + ' GB' + [Environment]::NewLine; "^
  "  $out += '  Used:         ' + $usedGB + ' GB' + [Environment]::NewLine; "^
  "  $out += '  Free:         ' + $freeGB + ' GB (' + $pct + '%%)' + [Environment]::NewLine + [Environment]::NewLine; "^
  "}; "^
  "$out | Out-File -FilePath (Join-Path $PWD $env:OUTPUT_FILE) -Append -Encoding UTF8"

powershell -NoProfile -Command ^
  "$gpu = Get-CimInstance Win32_VideoController; "^
  "$out = '--- GRAPHICS CARDS (GPU) ---' + [Environment]::NewLine; "^
  "foreach ($g in $gpu) { "^
  "  $out += 'Name:          ' + $g.Name + [Environment]::NewLine; "^
  "  $out += 'Manufacturer:  ' + $g.AdapterCompatibility + [Environment]::NewLine; "^
  "  $out += 'VRAM:          ' + [math]::Round($g.AdapterRAM / 1GB, 2) + ' GB' + [Environment]::NewLine; "^
  "  $out += 'Resolution:    ' + $g.CurrentHorizontalResolution + 'x' + $g.CurrentVerticalResolution + ' @ ' + $g.CurrentRefreshRate + 'Hz' + [Environment]::NewLine; "^
  "  $out += 'Driver:        ' + $g.DriverVersion + ' (' + $g.DriverDate + ')' + [Environment]::NewLine + [Environment]::NewLine; "^
  "}; "^
  "$out | Out-File -FilePath (Join-Path $PWD $env:OUTPUT_FILE) -Append -Encoding UTF8"

powershell -NoProfile -Command ^
  "$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=True'; "^
  "$out = '--- NETWORK ADAPTERS ---' + [Environment]::NewLine; "^
  "foreach ($a in $adapters) { "^
  "  $out += 'Interface:     ' + $a.Description + [Environment]::NewLine; "^
  "  $out += 'MAC Address:   ' + $a.MACAddress + [Environment]::NewLine; "^
  "  if ($a.IPAddress) { $out += 'IPv4:          ' + ($a.IPAddress | Where-Object { $_ -match '\d+\.\d+\.\d+\.\d+' }) + [Environment]::NewLine }; "^
  "  if ($a.IPSubnet) { $out += 'Subnet Mask:   ' + ($a.IPSubnet | Select-Object -First 1) + [Environment]::NewLine }; "^
  "  if ($a.DefaultIPGateway) { $out += 'Gateway:       ' + ($a.DefaultIPGateway | Select-Object -First 1) + [Environment]::NewLine }; "^
  "  if ($a.DNSServerSearchOrder) { $out += 'DNS:           ' + ($a.DNSServerSearchOrder -join ', ') + [Environment]::NewLine }; "^
  "  if ($a.DHCPEnabled) { $out += 'DHCP:          Enabled (' + $a.DHCPServer + ')' + [Environment]::NewLine } else { $out += 'DHCP:          Disabled' + [Environment]::NewLine }; "^
  "  $out += [Environment]::NewLine; "^
  "}; "^
  "$out | Out-File -FilePath (Join-Path $PWD $env:OUTPUT_FILE) -Append -Encoding UTF8"

powershell -NoProfile -Command ^
  "$cs = Get-CimInstance Win32_ComputerSystem; $mb = Get-CimInstance Win32_BaseBoard; $bios = Get-CimInstance Win32_BIOS; "^
  "$out = '--- MOTHERBOARD / BIOS ---' + [Environment]::NewLine; "^
  "$out += 'PC Manufacturer: ' + $cs.Manufacturer + [Environment]::NewLine; "^
  "$out += 'PC Model:        ' + $cs.Model + [Environment]::NewLine; "^
  "$out += 'PC Name:         ' + $cs.Name + [Environment]::NewLine; "^
  "$out += 'MB Manufacturer: ' + $mb.Manufacturer + [Environment]::NewLine; "^
  "$out += 'MB Model:        ' + $mb.Product + [Environment]::NewLine; "^
  "$out += 'MB Version:      ' + $mb.Version + [Environment]::NewLine; "^
  "$out += 'BIOS Vendor:     ' + $bios.Manufacturer + [Environment]::NewLine; "^
  "$out += 'BIOS Version:    ' + $bios.SMBIOSBIOSVersion + [Environment]::NewLine; "^
  "$out += 'BIOS Date:       ' + $bios.ReleaseDate + [Environment]::NewLine; "^
  "$out += [Environment]::NewLine; "^
  "$out | Out-File -FilePath (Join-Path $PWD $env:OUTPUT_FILE) -Append -Encoding UTF8"

goto :eof
