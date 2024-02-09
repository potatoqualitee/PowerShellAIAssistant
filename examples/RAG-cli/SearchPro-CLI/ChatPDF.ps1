Import-Module $PSScriptRoot\SearchPro-CLI.psm1 -Force

Get-ChildItem $PSScriptRoot *pdf | rag -Question "What is cool about this PDF?"