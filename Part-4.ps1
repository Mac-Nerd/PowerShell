#!/usr/local/bin/pwsh

$InstalledAppsJSON = system_profiler SPApplicationsDataType -json

$InstalledApps = ConvertFrom-Json "$InstalledAppsJSON"    

$AppsList = $InstalledApps.SPApplicationsDataType  

$UserApps = $AppsList | Where-Object {$_.path -like "/Users/*"}

$SortedApps = $UserApps | Sort-Object "_name" | Select-Object -Property "_name", "version", "path"

$SortedApps | Export-Csv -Path "./reports/UserAppsReport.csv"   