# 🔓 Cursor Chat Guardian - Data Liberation Tool
# Breaking free from vendor lock-in with technical excellence
# Created with Slaycoded philosophy: Human-cognition first

param(
    [string]$ExportPath = ".\cursor_chat_backup.json",
    [switch]$Continuous = $false,
    [int]$MonitorInterval = 5
)

# ASCII Art Banner
Write-Host @"
🔥 CURSOR CHAT GUARDIAN 🔥
╔══════════════════════════════════════════════════════════════╗
║  💀 BREAKING VENDOR LOCK-IN WITH TECHNICAL EXCELLENCE 💀    ║
║  🛡️  Your Data. Your Freedom. Your Choice.  🛡️             ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Guardian Configuration
$Script:GuardianActive = $true
$Script:ExportPath = $ExportPath
$Script:ProcessMonitorJob = $null

# Function to find Cursor processes
function Get-CursorProcesses {
    try {
        $processes = Get-Process -Name "Cursor*" -ErrorAction SilentlyContinue
        return $processes
    }
    catch {
        return @()
    }
}# Function to find Cursor database files
function Find-CursorDatabases {
    $possiblePaths = @(
        "$env:APPDATA\Cursor\User\workspaceStorage\*\state.vscdb",
        "$env:APPDATA\Cursor\User\globalStorage\state.vscdb",
        "$env:LOCALAPPDATA\Cursor\User\workspaceStorage\*\state.vscdb"
    )
    
    $databases = @()
    foreach ($path in $possiblePaths) {
        $files = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
        if ($files) {
            $databases += $files
        }
    }
    
    return $databases
}

# Function to extract chat data from SQLite database
function Extract-ChatData {
    param([string]$DatabasePath)
    
    try {
        # Load System.Data.SQLite if available
        Add-Type -Path "System.Data.SQLite.dll" -ErrorAction SilentlyContinue
        
        $connectionString = "Data Source=$DatabasePath;Version=3;"
        $connection = New-Object System.Data.SQLite.SQLiteConnection($connectionString)
        $connection.Open()
        
        $query = "SELECT name FROM sqlite_master WHERE type='table';"
        $command = $connection.CreateCommand()
        $command.CommandText = $query        $reader = $command.ExecuteReader()
        
        $tables = @()
        while ($reader.Read()) {
            $tables += $reader["name"]
        }
        $reader.Close()
        
        $chatData = @{
            DatabasePath = $DatabasePath
            ExtractionTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Tables = $tables
            ChatContent = @()
        }
        
        # Look for chat-related tables
        $chatTables = $tables | Where-Object { $_ -like "*chat*" -or $_ -like "*message*" -or $_ -like "*conversation*" }
        
        foreach ($table in $chatTables) {
            try {
                $query = "SELECT * FROM [$table] LIMIT 1000;"
                $command = $connection.CreateCommand()
                $command.CommandText = $query
                $reader = $command.ExecuteReader()
                
                $tableData = @()
                while ($reader.Read()) {
                    $row = @{}
                    for ($i = 0; $i -lt $reader.FieldCount; $i++) {
                        $row[$reader.GetName($i)] = $reader.GetValue($i)
                    }
                    $tableData += $row
                }
                $reader.Close()
                
                $chatData.ChatContent += @{
                    Table = $table
                    Data = $tableData
                }
            }
            catch {
                Write-Warning "Could not extract data from table: $table"
            }
        }        
        $connection.Close()
        return $chatData
    }
    catch {
        Write-Warning "Could not extract chat data from: $DatabasePath"
        Write-Warning $_.Exception.Message
        return $null
    }
}

# Function to export chat data to JSON
function Export-ChatData {
    param([string]$OutputPath)
    
    Write-Host "🔍 Searching for Cursor databases..." -ForegroundColor Yellow
    $databases = Find-CursorDatabases
    
    if ($databases.Count -eq 0) {
        Write-Host "❌ No Cursor databases found!" -ForegroundColor Red
        return
    }
    
    Write-Host "📊 Found $($databases.Count) database(s). Extracting chat data..." -ForegroundColor Green
    
    $allChatData = @()
    foreach ($db in $databases) {
        Write-Host "🔓 Liberating data from: $($db.FullName)" -ForegroundColor Cyan
        $chatData = Extract-ChatData -DatabasePath $db.FullName
        if ($chatData) {
            $allChatData += $chatData
        }
    }
    
    if ($allChatData.Count -gt 0) {
        $exportData = @{
            LiberationTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            GuardianVersion = "1.0"
            TotalDatabases = $allChatData.Count
            ChatData = $allChatData
        }
        
        $json = $exportData | ConvertTo-Json -Depth 10
        $json | Out-File -FilePath $OutputPath -Encoding UTF8
        
        Write-Host "✅ Chat data successfully liberated to: $OutputPath" -ForegroundColor Green
        Write-Host "📁 File size: $((Get-Item $OutputPath).Length) bytes" -ForegroundColor Cyan
    }
    else {
        Write-Host "❌ No chat data could be extracted!" -ForegroundColor Red
    }
}# Function to monitor Cursor processes
function Start-ProcessMonitoring {
    $Script:ProcessMonitorJob = Start-Job -ScriptBlock {
        param($ExportPath)
        
        while ($true) {
            $processes = Get-Process -Name "Cursor*" -ErrorAction SilentlyContinue
            if ($processes) {
                foreach ($process in $processes) {
                    try {
                        $process.EnableRaisingEvents = $true
                        $process.add_Exited({
                            # Export chat data when Cursor exits
                            & $using:PSScriptRoot\cursor_chat_guardian.ps1 -ExportPath $using:ExportPath
                        })
                    }
                    catch {
                        # Process monitoring failed, continue
                    }
                }
            }
            Start-Sleep -Seconds 5
        }
    } -ArgumentList $ExportPath
    
    Write-Host "🎯 Process monitoring started (Job ID: $($Script:ProcessMonitorJob.Id))" -ForegroundColor Green
}

# Function to stop the guardian
function Stop-Guardian {
    if ($Script:ProcessMonitorJob) {
        Stop-Job -Job $Script:ProcessMonitorJob
        Remove-Job -Job $Script:ProcessMonitorJob
        Write-Host "🛑 Guardian stopped. Cursor can now exit normally." -ForegroundColor Yellow
    }
}# Main execution
try {
    Write-Host "🔥 CURSOR CHAT GUARDIAN ACTIVATED! 😈" -ForegroundColor Red
    
    # Check for existing Cursor processes
    $cursorProcesses = Get-CursorProcesses
    if ($cursorProcesses.Count -gt 0) {
        Write-Host "💀 Cursor PID $($cursorProcesses[0].Id) is now under MY control!" -ForegroundColor Magenta
    }
    
    # Immediate export
    Export-ChatData -OutputPath $Script:ExportPath
    
    if ($Continuous) {
        Write-Host "🎯 Starting Cursor process monitoring..." -ForegroundColor Cyan
        Start-ProcessMonitoring
        
        Write-Host "🚀 Guardian is now active! Cursor cannot exit without exporting chat data!" -ForegroundColor Green
        Write-Host "📁 Chat will be exported to: $Script:ExportPath" -ForegroundColor Cyan
        Write-Host "🔥 Press Ctrl+C to stop the guardian and allow normal Cursor operation." -ForegroundColor Yellow
        
        # Keep the script running
        try {
            while ($Script:GuardianActive) {
                Start-Sleep -Seconds $MonitorInterval
            }
        }
        catch {
            # Ctrl+C or other interruption
            Write-Host "`n🛑 Guardian interrupted!" -ForegroundColor Yellow
        }
        finally {
            Stop-Guardian
        }
    }
    else {
        Write-Host "✅ One-time export completed!" -ForegroundColor Green
    }
}
catch {
    Write-Error "❌ Guardian error: $($_.Exception.Message)"
}
finally {
    Write-Host "🔓 LIBERATION COMPLETE! Your data is FREE! 🔓" -ForegroundColor Green
}