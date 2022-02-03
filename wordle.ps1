$url = 'https://gist.githubusercontent.com/zneak/53f885f1fc5856741cb4/raw/a17a81d15acb8109cda8524c743186901dd269b6/words.txt'
$words = ((Invoke-WebRequest -Uri $url).Content.toLower() -split '\n' | Select-String '^\w\w\w\w\w$').Line
$actual = $words[(Get-Random -Maximum $words.Count)]; 
$max_guess = if ($args[0] -eq "unlimit") {999999} else {6}
for ($guess_count = 1; $guess_count -le $max_guess; $guess_count++) {
    $guess = (Read-Host -Prompt "Enter your guess ($guess_count / $max_guess)").ToLower()
    if ($words -notcontains $guess) {
        Write-Host "Please enter a valid word with 5 letters!"
        $guess_count--
        continue
    }
    if ($actual -eq $guess) {
        Write-Host "You guessed right!"
        Write-Host $guess -ForegroundColor Black -BackgroundColor Green
        return
    } 
    $remaining = ""
    for ($i = 0; $i -lt $actual.Length; $i++) {if ($actual[$i] -ne $guess[$i]) {$remaining += $actual[$i]}}
    for ($i = 0; $i -lt $actual.Length; $i++) {
        if ($actual[$i] -ne $guess[$i]) {
            if ($remaining.Contains($guess[$i])) {
                Write-Host $guess[$i] -ForegroundColor Black -BackgroundColor DarkYellow -NoNewLine
                $remaining = $remaining.Remove($remaining.IndexOf($guess[$i]), 1)
            } else {Write-Host $guess[$i] -ForegroundColor Black -BackgroundColor Gray -NoNewLine}
        } else {Write-Host $guess[$i] -ForegroundColor Black -BackgroundColor Green -NoNewLine}
    }
    Write-Host
}
Write-Host "You lose! The word is: $actual"