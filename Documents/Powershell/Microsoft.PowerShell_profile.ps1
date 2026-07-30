Set-PSReadlineOption -BellStyle None
atuin init powershell | Out-String | Invoke-Expression

# >>> yo initialize >>>
# Added by `yo --setup`; remove with `yo --uninstall`.
if (Get-Command yo -ErrorAction SilentlyContinue) { yo --init powershell | Out-String | iex }
# <<< yo initialize <<<
