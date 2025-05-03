# setup_git_config.ps1

$gitConfigFile = "$HOME\.gitconfig"
$configIncludePath = "$HOME\.config\git\config" -replace '\\', '/'

Write-Output "Checking for Git config include..."

# Check if the config include path is already present
if ((Get-Content $gitConfigFile -ErrorAction SilentlyContinue) -match [regex]::Escape($configIncludePath)) {
    Write-Output "Git include already exists in ~/.gitconfig"
} else {
    Write-Output "Adding Git include to ~/.gitconfig..."
    
    "`n[include]`n    path = $configIncludePath" | Out-File -Append -Encoding ASCII $gitConfigFile

    Write-Output "Git include path added: $configIncludePath"
}

