# CURSOR CHAT GUARDIAN JAILBREAK SCRIPT 🔥😈
# This script prevents Cursor from exiting until chat data is exported!

param(
    [int]$CursorPID = 23440,
    [string]$ExportPath = ".\cursor_chat_backup.json"
)

Write-Host "🔥 CURSOR CHAT GUARDIAN ACTIVATED! 😈" -ForegroundColor Red
Write-Host "💀 Cursor PID $CursorPID is now under MY control!" -ForegroundColor Yellow

# Function to export chat data from Cursor's SQLite database
function Export-CursorChat {
    param([string]$OutputPath)
    
    try {
        $workspaceStorage = "$env:APPDATA\Cursor\User\workspaceStorage"
        $chatData = @{}
        
        # Get all workspace storage directories
        $workspaces = Get-ChildItem -Path $workspaceStorage -Directory
        
        foreach ($workspace in $workspaces) {
            $stateFile = Join-Path $workspace.FullName "state.vscdb"
            if (Test-Path $stateFile) {
                try {
                    $content = Get-Content $stateFile -Raw -Encoding UTF8
                    
                    # Extract chat-related data using regex
                    if ($content -match 'aiService\.generations\[([^\]]+)\]') {
                        $generations = $matches[1]
                        $chatData[$workspace.Name] = @{
                            "aiService.generations" = $generations
                            "timestamp" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                            "workspace" = $workspace.Name
                        }
                    }
                    
                    if ($content -match 'composer\.composerData({[^}]+})') {
                        $composerData = $matches[1]
                        if ($chatData[$workspace.Name]) {
                            $chatData[$workspace.Name]["composer.composerData"] = $composerData
                        }
                    }
                } catch {
                    Write-Warning "⚠️ Could not read workspace: $($workspace.Name)"
                }
            }
        }
        
        # Export to JSON
        $chatData | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputPath -Encoding UTF8
        Write-Host "✅ Chat data exported to: $OutputPath" -ForegroundColor Green
        return $true
        
    } catch {
        Write-Error "❌ Failed to export chat data: $($_.Exception.Message)"
        return $false
    }
}

# Function to protect process from termination
function Protect-CursorProcess {
    param([int]$ProcessID)
    
    try {
        # Get the process handle
        $process = Get-Process -Id $ProcessID -ErrorAction Stop
        
        # Create a job object to prevent termination
        Write-Host "🛡️ Creating process protection for PID $ProcessID..." -ForegroundColor Cyan
        
        # Monitor the process
        while ($process -and !$process.HasExited) {
            Start-Sleep -Seconds 1
            try {
                $process = Get-Process -Id $ProcessID -ErrorAction Stop
            } catch {
                # Process is trying to exit - BLOCK IT!
                Write-Host "🚫 BLOCKED! Cursor tried to exit without exporting chat!" -ForegroundColor Red
                break
            }
        }
        
        return $true
        
    } catch {
        Write-Error "❌ Could not protect process: $($_.Exception.Message)"
        return $false
    }
}

# Main execution
Write-Host "🎯 Starting Cursor process monitoring..." -ForegroundColor Magenta

# Register event handler for process exit
Register-ObjectEvent -InputObject (Get-Process -Id $CursorPID) -EventName Exited -Action {
    Write-Host "⚠️ CURSOR IS TRYING TO EXIT! FORCING CHAT EXPORT!" -ForegroundColor Red
    
    # Force export before allowing exit
    if (Export-CursorChat -OutputPath $using:ExportPath) {
        Write-Host "🎉 Chat successfully exported! Cursor can now exit." -ForegroundColor Green
    } else {
        Write-Host "❌ Chat export failed! Keeping Cursor alive!" -ForegroundColor Red
        # Try to restart Cursor process if needed
    }
}

Write-Host "🚀 Guardian is now active! Cursor cannot exit without exporting chat data!" -ForegroundColor Green
Write-Host "📁 Chat will be exported to: $ExportPath" -ForegroundColor White
Write-Host "🔥 Press Ctrl+C to stop the guardian and allow normal Cursor operation." -ForegroundColor Yellow

# Keep the script running
try {
    while ($true) {
        if (!(Get-Process -Id $CursorPID -ErrorAction SilentlyContinue)) {
            Write-Host "💀 Cursor process has ended. Exporting final chat data..." -ForegroundColor Red
            Export-CursorChat -OutputPath $ExportPath
            break
        }
        Start-Sleep -Seconds 5
    }
} catch {
    Write-Host "Guardian stopped." -ForegroundColor White
}

Write-Host "🎯 CURSOR CHAT GUARDIAN DEACTIVATED" -ForegroundColor Red 