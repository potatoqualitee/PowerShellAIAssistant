Import-Module $PSScriptRoot\SearchPro-CLI.psm1 -Force

Get-ChildItem $PSScriptRoot -Recurse *yoga*pdf | rag -Question "What are these pdfs about?"