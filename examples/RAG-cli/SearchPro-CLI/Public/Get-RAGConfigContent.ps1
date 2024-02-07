<#
.SYNOPSIS
Retrieves the content of the RAG (Retrieval-augmented generation) configuration file.

.DESCRIPTION
The Get-RAGConfigContent function retrieves the content of the RAG configuration file specified in the RAGConfig object. If the file exists, its content is returned.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-RAGConfigContent
# Retrieves the content of the RAG configuration file.
#>
function Get-RAGConfigContent {
    [CmdletBinding()]
    param()

    $cfg = Get-RAGConfig

    if (Test-Path $cfg.OutputFullName) {
        Get-Content $cfg.OutputFullName
    }
}
