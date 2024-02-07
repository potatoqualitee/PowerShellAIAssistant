<#
.SYNOPSIS
    Retrieves the RAG (Retrieval-augmented generation) configuration.

.DESCRIPTION
    This function retrieves the RAG (Retrieval-augmented generation) configuration, which includes the output path, output file name, and output full name.

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    Get-RAGConfig
    Retrieves the RAG configuration.
#>

function Get-RAGConfig {
    [CmdletBinding()]
    param()

    $OutputPath = Join-Path $env:APPDATA 'PowerShellAIAssistant/RAGConfig'
    $OutputFileName = '/ragConfig.txt'
    $OutputFullName = $OutputPath + $OutputFileName

    [PSCustomObject]@{
        OutputPath     = $OutputPath
        OutputFileName = $OutputFileName
        OutputFullName = $OutputFullName
    }
}
