# dotfiles
My universal dotfiles configuration.

## Installation
### Environment variable
It is important create few environment variables in order to use this config.
Current setup will work with Windows PowerShell only.

#### Config directory
```shell
[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', $env:USERPROFILE+'\.config', 'user')
```

#### Data directory
```shell
[System.Environment]::SetEnvironmentVariable('XDG_DATA_HOME', $env:USERPROFILE+'\.local\share', 'user')
```

#### State directory
```shell
[System.Environment]::SetEnvironmentVariable('XDG_STATE_HOME', $env:USERPROFILE+'\.local\state', 'user')
```

#### Cache directory
```shell
[System.Environment]::SetEnvironmentVariable('XDG_CACHE_HOME', $env:USERPROFILE+'\.cache', 'user')
```

#### Log file
```shell
[System.Environment]::SetEnvironmentVariable('NVIM_LOG_FILE', $env:USERPROFILE+'\.local\state\nvim', 'user')
```

#### KOMOREBI_CONFIG_HOME
```shell
[System.Environment]::SetEnvironmentVariable('KOMOREBI_CONFIG_HOME', $env:USERPROFILE+'\.config\komorebi', 'user')
```

#### WHKD_CONFIG_HOME
```shell
[System.Environment]::SetEnvironmentVariable('WHKD_CONFIG_HOME', $env:USERPROFILE+'\.config\whkd', 'user')
```

#### STARSHIP_CONFIG
```shell
[System.Environment]::SetEnvironmentVariable('STARSHIP_CONFIG', $env:USERPROFILE+'\.config\starship\starship.toml', 'user')
```

