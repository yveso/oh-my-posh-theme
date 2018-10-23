#requires -Version 2 -Modules posh-git
# based on Honukai

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $prompt = Set-Newline

    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $sl.Colors.OhNoesColor
    }

    If (Test-Administrator) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol)  " -ForegroundColor $sl.Colors.AdminIconForegroundColor
    }

    $user = [System.Environment]::UserName
    if (Test-NotDefaultUser($user)) {
        $prompt += Write-Prompt -Object "$user" -ForegroundColor $sl.Colors.PromptHighlightColor
        $device = $env:computername
        $prompt += Write-Prompt -Object "@"
        $prompt += Write-Prompt -Object "$device" -ForegroundColor $sl.Colors.GitDefaultColor
    }

    $timeStamp = Get-Date -Format T
    $prompt += Write-Prompt " [$timeStamp]"

    $prompt += Set-Newline

    $dir = Get-FullPath -dir $pwd
    $prompt += Write-Prompt -Object "$dir" -ForegroundColor $sl.Colors.FolderColor

    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo)" -ForegroundColor $themeInfo.BackgroundColor
    }

    $prompt += Set-Newline

    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "($(Get-VirtualEnvName)) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor
    }

    $prompt += Write-Prompt -Object $sl.PromptSymbols.PromptIndicator -ForegroundColor $sl.Colors.PromptHighlightColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x279C)
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$sl.Colors.FolderColor = [ConsoleColor]::Magenta
$sl.Colors.OhNoesColor = [ConsoleColor]::DarkRed
$sl.Colors.VirtualEnvForegroundColor = [ConsoleColor]::Blue
