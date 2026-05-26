# Study With Me — Windows adapter (stub)
# Interface: dnd_on | dnd_off | close_apps <list> | open_apps <list> | play_focus_music <uri> | stop_focus_music | notify <title> <message>
#
# Status: STUB. Fill in implementations when you actually run this on Windows.
# Each verb should print a one-line status and exit 0. Print "not supported on this platform"
# for verbs you haven't implemented yet so the skill keeps the session running.

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Cmd,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

function Dnd-On {
    # TODO: Toggle Windows Focus Assist
    # Suggested approach: registry edit at HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.FocusAssist
    # or use the Focus Assist API via a small helper.
    Write-Output "not supported on this platform"
}

function Dnd-Off {
    Write-Output "not supported on this platform"
}

function Close-Apps {
    param([string[]]$Apps)
    foreach ($app in $Apps) {
        try {
            Stop-Process -Name $app -Force -ErrorAction Stop
            Write-Output "closed: $app"
        } catch {
            Write-Output "skip: $app (not running)"
        }
    }
}

function Open-Apps {
    param([string[]]$Apps)
    foreach ($app in $Apps) {
        try {
            Start-Process $app -ErrorAction Stop
            Write-Output "opened: $app"
        } catch {
            Write-Output "skip: $app (not found)"
        }
    }
}

function Play-FocusMusic {
    param([string]$Uri)
    if (-not $Uri) {
        Write-Output "play_focus_music: no uri configured, skipping"
        return
    }
    Start-Process $Uri
    Write-Output "play_focus_music: ok ($Uri)"
}

function Stop-FocusMusic {
    # TODO: pause Spotify desktop via global media key or Spotify Web API
    Write-Output "not supported on this platform"
}

function Send-Notify {
    param([string]$Title, [string]$Message)
    try {
        Add-Type -AssemblyName System.Windows.Forms
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = [System.Drawing.SystemIcons]::Information
        $notify.Visible = $true
        $notify.ShowBalloonTip(5000, $Title, $Message, [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Seconds 1
        $notify.Dispose()
        Write-Output "notify: ok"
    } catch {
        Write-Output "notify: failed"
    }
}

switch ($Cmd) {
    "dnd_on"           { Dnd-On }
    "dnd_off"          { Dnd-Off }
    "close_apps"       { Close-Apps -Apps $Args }
    "open_apps"        { Open-Apps -Apps $Args }
    "play_focus_music" { Play-FocusMusic -Uri $Args[0] }
    "stop_focus_music" { Stop-FocusMusic }
    "notify"           { Send-Notify -Title $Args[0] -Message $Args[1] }
    default            { Write-Output "not supported on this platform" }
}
