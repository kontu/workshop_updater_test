$steamCmd = "$pwd\steamcmd\steamcmd.exe"
$args1 = "+login kontu037 +workshop_build_item ..\"
$quit = " +quit"


$ButtonsLabels=Get-ChildItem -Depth 3 -Filter "*.vdf" -Name
$menu = [ordered]@{}
    for ($i=1;$i -le $ButtonsLabels.Count; $i++) {
        #Write-Host "$i. $($ButtonsLabels[$i-1])"
        $menu.Add($i, $ButtonsLabels[$i-1])} 

do{
    write-output "=========="
    Write-output "Choose a workshop mod to update:"
    write-output $menu | ft -auto
    Write-output "Enter 'q' to quit"

    $ans = Read-Host "Enter number to update"
    $ans2 = $ans -as [int]
    if (($ans2 -gt 0) -and ($ans2 -le $menu.Count)) {
        $selection = $menu[$ans2-1]
        $args2 = $args1+$selection+$quit
        $attempts = 1
        while ($true){
        write-output ""
        write-output "=== Updating mod $selection ==="
        write-output "=== Update attempt: $attempts"
        write-output ""
        $process = (Start-Process -Wait -NoNewWindow -PassThru -FilePath $steamCmd $args2)
        #write-output $steamCmd $args2
        write-output ""
        if ($process.ExitCode -eq 0){
            write-output ""
            write-host "=== Mod successfully updated after $attempts attempts." -ForegroundColor green
            write-host "=== Mod: $selection" -ForegroundColor green
            write-output ""
            break
        }elseif ($attempts -gt 5){
            write-output ""
            write-host "=== Mod failed to update after $attempts attempts. Aborting." -ForegroundColor red
            write-host "=== Mod: $selection" -ForegroundColor red
            write-output ""
            break
        }else{
            write-output ""
            write-warning "=== Mod failed to update on attempt number $attempts. Retrying...."
            write-warning "=== Mod: $selection"
            $attempts++
        }
        
        }
    }else{
        if ($ans -ne "q"){
            write-output ""
            write-output "=========="
            write-host "$ans is an invalid entry, please try again." -ForegroundColor red
            write-output "=========="
            write-output ""
        }
        continue}
} until ($ans -eq "q") 