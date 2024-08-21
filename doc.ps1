# Definir caminho para a área de trabalho
$desktop = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
$dump_file = [System.IO.Path]::Combine($desktop, "dump.txt")

# Apagar o arquivo dump.txt se já existir
if (Test-Path $dump_file) {
    Remove-Item $dump_file
}

# Cabeçalho
Add-Content $dump_file "==============================="
Add-Content $dump_file "         Dump de Hardware       "
Add-Content $dump_file "==============================="
Add-Content $dump_file ""

# Informações da placa-mãe
Add-Content $dump_file "[PLACA-MÃE]"
Get-WmiObject Win32_BaseBoard | ForEach-Object {
    Add-Content $dump_file "$($_.Manufacturer) - $($_.Product)"
}
Add-Content $dump_file ""

# Informações da memória RAM
Add-Content $dump_file "[MEMÓRIA RAM]"
Get-WmiObject Win32_PhysicalMemory | ForEach-Object {
    Add-Content $dump_file "$($_.Manufacturer) - $($_.PartNumber)"
}
Add-Content $dump_file ""

# Informações da placa de vídeo
Add-Content $dump_file "[PLACA DE VÍDEO]"
Get-WmiObject Win32_VideoController | ForEach-Object {
    $pnpId = $_.PNPDeviceID -split '&'
    Add-Content $dump_file "$($_.Caption) - $($pnpId[2])"
}
Add-Content $dump_file ""

# Informações do processador
Add-Content $dump_file "[PROCESSADOR]"
Get-WmiObject Win32_Processor | ForEach-Object {
    Add-Content $dump_file "$($_.Name)"
}
Add-Content $dump_file ""

# Informações de todos os discos (SSD e HDD)
Add-Content $dump_file "[DISCOS]"
Get-WmiObject Win32_DiskDrive | ForEach-Object {
    Add-Content $dump_file "$($_.Model) - $($_.Manufacturer) - $($_.MediaType)"
}
Add-Content $dump_file ""

# Exibir o arquivo gerado
Start-Process notepad.exe $dump_file
