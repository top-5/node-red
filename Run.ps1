# Add node-red-admin from current source tree to path
$nodeRedAdminPath = Join-Path (Get-Location) "node_modules\.bin"
$env:Path = "$nodeRedAdminPath;$env:Path"

# Check if settings directory exists, if not create it
if (-not (Test-Path -Path "./settings")) {
    New-Item -ItemType Directory -Path "./settings"
}
# Check if file settings.json exists in ./settings, if not initialize it
if (-not (Test-Path -Path "./settings/settings.js")) {
    node-red-admin.cmd init
    # Move generated settings.json to ./settings
    Move-Item -Path "settings.json" -Destination "./settings" -Force
}

try {
    # Start Node-RED in the background and store the process
    $nodeRedProcess = Start-Process -FilePath "node" `
        -ArgumentList "./packages/node_modules/node-red/red.js --settings ./settings/settings.js ./examples/workflow/flows.json" `
        -NoNewWindow -PassThru

    Write-Host "Node-RED started with Process ID: $($nodeRedProcess.Id)"

    # Wait for Node-RED to initialize (adjust delay if needed)
    Start-Sleep -Seconds 5

    # Launch the browser with the specific flow URL
    Start-Process "http://127.0.0.1:1880/#flow/4da54320b85f4178"

    # Keep the script running until Ctrl+C is pressed
    Write-Host "Press Ctrl+C to stop Node-RED..."
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    # Ensure the Node-RED process is terminated when the script exits
    if ($nodeRedProcess -and !$nodeRedProcess.HasExited) {
        Write-Host "Stopping Node-RED (Process ID: $($nodeRedProcess.Id))..."
        Stop-Process -Id $nodeRedProcess.Id -Force
        Write-Host "Node-RED stopped."
    }
}
