#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


# List of target machines
$computers = @("Machine1", "Machine2", "Machine3")

# Define the list of folders to exclude
$foldersToExclude = @(
    "E:\ArcGIS",
    "E:\arcgisportal",
    "E:\arcgisserver",
    "E:\arcgisdatastore",
    "E:\Automation"
)

# Script block to execute on each machine
$scriptBlock = {
    $serverName = $env:COMPUTERNAME
    Write-Host "Starting to exclude folders from Windows Defender on $serverName"

    # Fetch existing exclusions to avoid duplicates
    $mp = Get-MpPreference
    $existing = @($mp.ExclusionPath)

    foreach ($folder in $Using:foldersToExclude) {
        if ($existing -contains $folder) {
            Write-Host "Already excluded: $folder on $serverName"
        } else {
            try {
                Add-MpPreference -ExclusionPath $folder
                Write-Host "Excluded: $folder on $serverName"
            } catch {
                Write-Warning "Failed to exclude $folder on $serverName. Error: $($_.Exception.Message)"
            }
        }
    }

    Write-Host "Completed excluding folders from Windows Defender on $serverName"
}

# Execute the script block on each target machine
foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock
}

