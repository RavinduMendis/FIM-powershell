function hashing($path, $algorithm = "SHA512"){
    $fileHash = Get-FileHash -Path $path -Algorithm $algorithm
    return $fileHash
}

function deleteBaseline(){
    $baselineExists = Test-Path -Path .\baseline.txt
    if ($baselineExists){
        Remove-Item -Path .\baseline.txt
        Write-Host "Old baseline deleted." -ForegroundColor DarkYellow
    }
}

function logMessage($message, $color){
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "$timestamp - $message" -ForegroundColor $color
}

cls
Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host ""
Write-Host ""
$path = ".\Files"

while($true){
    $response = Read-Host -Prompt "Please enter 'A' or 'B'"
    $response = $response.ToUpper()

    if($response -eq "A"){
        deleteBaseline

        $files = Get-ChildItem -Path $path -Recurse
        foreach($item in $files){
            $hash = hashing -path $item.FullName
            "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath ".\baseline.txt" -Append
            $item
        }

        Write-Host ""
        Write-Host "Algorithm - $($hash.Algorithm)" -ForegroundColor DarkCyan
        Write-Host ""
        logMessage "Baseline collected." Green
        break
    }
    elseif($response -eq "B"){
        cls
        Write-Host ""
        Write-Host "Start monitoring (CTRL + C to exit)"
        Write-Host ""

        $baselineDictionary = @{}
        $baselineContent = Get-Content -Path .\baseline.txt
        foreach($data in $baselineContent){
            $baselineDictionary.add($data.Split("|")[0], $data.Split("|")[1])
        }

        while($true){
            $files = Get-ChildItem -Path $path -Recurse
            foreach($file in $files){
                $hash = hashing -path $file.FullName

                if (-not [string]::IsNullOrEmpty($hash.Path)){
                    if($baselineDictionary[$hash.Path] -eq $null){
                        logMessage "$($hash.Path) has been created!" Green
                    }
                    elseif($baselineDictionary[$hash.Path] -ne $hash.Hash ){
                        logMessage "$($hash.Path) has been edited." Yellow
                    }
                }
            }

            foreach($key in $baselineDictionary.Keys){
                if (-not [string]::IsNullOrEmpty($key)){
                    $existence = Test-Path -Path $key
                    if(-not $existence){
                        logMessage "$($key) has been deleted." Red
                    }
                }
            }

            Start-Sleep -Seconds 3
        }
        break
    }
    else{
        Write-Host ""
        Write-Host "Select A or B"
        Write-Host ""
    }
}
