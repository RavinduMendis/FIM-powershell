#functions

#hashing function
function hashing($path, $algorithm = "SHA512"){
    $fileHash = Get-FileHash -Path $path -Algorithm $algorithm
    return $fileHash
}

#delete baseline if exists
function deleteBaseline(){
    $baselineExists = Test-Path -Path .\baseline.txt
    if ($baselineExists){
        Remove-Item -Path .\baseline.txt
        Write-Host "Old baseline deleted." -ForegroundColor DarkYellow
    }
}

#log message
function logMessage($message, $color){
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "$timestamp - $message" -ForegroundColor $color
}

#main script
cls #clear terminal
Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host ""
Write-Host ""
$path = ".\Files" #change file path


#main loop
while($true){
    $response = Read-Host -Prompt "Please enter 'A' or 'B'"
    $response = $response.ToUpper()

    if($response -eq "A"){
        deleteBaseline #calling delete baseline funcion

        $files = Get-ChildItem -Path $path -Recurse   #gather files

        #hashing and store in baseline file
        foreach($item in $files){
            $hash = hashing -path $item.FullName
            "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath ".\baseline.txt" -Append
            $item
        }

        #printing output
        Write-Host ""
        Write-Host "Algorithm - $($hash.Algorithm)" -ForegroundColor DarkCyan
        Write-Host ""
        logMessage "Baseline collected." Green
        break
    }

    elseif($response -eq "B"){
        #monitoring
        cls
        Write-Host ""
        Write-Host "Start monitoring (CTRL + C to exit)"
        Write-Host ""

        #store baseline file to dictionary
        $baselineDictionary = @{}
        $baselineContent = Get-Content -Path .\baseline.txt
        foreach($data in $baselineContent){
            $baselineDictionary.add($data.Split("|")[0], $data.Split("|")[1])
        }

        while($true){
            $files = Get-ChildItem -Path $path -Recurse
            foreach($file in $files){
                $hash = hashing -path $file.FullName

                #checking file has been created
                if (-not [string]::IsNullOrEmpty($hash.Path)){
                    if($baselineDictionary[$hash.Path] -eq $null){
                        logMessage "$($hash.Path) has been created!" Green
                    }

                    #checking file has been edited
                    elseif($baselineDictionary[$hash.Path] -ne $hash.Hash ){
                        logMessage "$($hash.Path) has been edited." Yellow
                    }
                }
            }

            #checking file has been deleted
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
        Write-Host "Select A or B" -ForegroundColor Magenta
        Write-Host ""
    }
}

pause
