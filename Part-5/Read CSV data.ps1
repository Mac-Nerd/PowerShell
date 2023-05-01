#!/usr/local/bin/pwsh

# Read CSV data
$CSVData = Import-Csv "Chrome Version Sample - Before.csv" 

# find the highest Chrome version represented in the data
$MaxVersion = $CSVData | Sort-Object -Property "Version" | Select-Object -Last 1

# Get a number from the string in the object's Version property.
$LastMajorVersion = $MaxVersion.Version.split(".")[0]

# Create a pivot table from the "Version" field, only splitting at "less than current - 3" or not
$PivotData = $CSVData | Group-Object -Property {$_.Version -lt ($LastMajorVersion - 3)}

# Display the pivot table, select a row to see details
$SelectedRow = $PivotData | Out-ConsoleGridView -OutputMode Multiple -Title "Chrome version older than $($LastMajorVersion - 3)"
 
# List of selected machine users
# $SelectedRow.Group.UserEmail

# Export selected machine details
#$CSVOutput = $SelectedRow.Group | ForEach-Object { $_.Hostname +","+ $_.useremail }

$SelectedRow.Group | Select-Object -Property Hostname,UserEmail | Export-Csv -Path "./export.csv"

#$CSVOutput # | Out-File -Path "./CSVExport.csv"