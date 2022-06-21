$bedingung = 1
while($bedingung -eq 1)
{
    Clear-Host
    $input = Read-Host "Geben sie den ungefaehren Namen des Package an z.B. 'not', 'notepad', 'notep'" 

    $Package = Get-AppvClientPackage *$input*
    $number = $Package.Count
    $PackageID = $Package.PackageId
    $Name = $Package.Name
    $Version = $Package.VersionId
    if ($number -eq 1){
    Write-Host "---------------------------------------------"
    Write-Host "Eingabe: "$input
    Write-Host "---------------------------------------------"
    Write-Host "Gefunden"
    Write-Host "ID:      "$PackageID
    Write-Host "Name:    "$Name
    Write-Host "Version: "$Version
    Write-Host "---------------------------------------------"
    Write-Host -fore yellow "=> Bitte oben aufgelistete Daten pruefen!"
    $input = Read-Host "Stimmen die oben aufgelisteten Daten? ( y ; n)"
    

    if($input -eq "y" -or $input -eq "Y")
    {
        Stop-AppVClientPackage -PackageId $PackageID -VersionId $Version    
        Write-Host -fore yellow "=> AppV wird geloescht"
        Get-AppvClientPackage $Name | Remove-AppvClientPackage
        if(Test-Path -Path "C:\ProgramData\App-V\$PackageID"){
            Remove-Item C:\ProgramData\App-V\$PackageID -Recurse -Force
        }
        Write-Host -fore yellow "=> AppV Client Package wurde geloescht!"
        Remove-Item HKCU:\SOFTWARE\Microsoft\AppV\Client\Packages\$PackageID -Recurse -erroraction 'silentlycontinue'
        Remove-Item HKCU:\SOFTWARE\Classes\AppV\Client\Packages\$PackageID -Recurse -erroraction 'silentlycontinue'
        Remove-Item HKLM:\SOFTWARE\Microsoft\AppV\Client\Packages\$PackageID -Recurse -erroraction 'silentlycontinue'
        Remove-Item HKLM:\SOFTWARE\Microsoft\AppV\Client\Virtualization\LocalVFSSecuredUsers -erroraction 'silentlycontinue'
        Write-Host -fore yellow "=> Regestry Einträge wurden geloescht!"

        Remove-Item C:\Users\$env:UserName\AppData\Local\Microsoft\AppV\Client\VFS\*$PackageID* -Recurse
        Remove-Item C:\Users\$env:UserName\AppData\Roaming\Microsoft\AppV\Client\Catalog\Packages\*$PackageID* -Recurse
    
        Write-Host -fore yellow "=> Ordner wurden geloescht!"
        $bedingung = 0
    }else{
        Write-Host -fore red "=> Package loeschung wurde abgebrochen!"
        PAUSE
        
    }
    }else{
        Write-Host -fore red "=> Name zu ungenau! Gefundene Packages: $number"
        PAUSE
        
    }
}