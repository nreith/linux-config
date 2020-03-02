Get-WmiObject Win32_PnPSignedDriver| select DeviceName, Manufacturer, DriverVersion, DriverDate | Sort-Object DeviceName
