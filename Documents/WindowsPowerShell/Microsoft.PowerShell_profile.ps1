Set-PSReadlineOption -BellStyle None
atuin init powershell | Out-String | Invoke-Expression

# yo - LLM command assistant
if (Get-Command yo -ErrorAction SilentlyContinue) { yo --init powershell | Out-String | iex }
