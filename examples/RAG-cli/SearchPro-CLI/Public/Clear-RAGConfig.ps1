<#
.SYNOPSIS
Clears the RAG configuration by removing the output file.

.DESCRIPTION
The Clear-RAGConfig function clears the RAG (Retrieval-augmented generation) configuration by removing the output file specified in the configuration.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Clear-RAGConfig
Removes the output file specified in the RAG configuration.

#>
function Clear-RAGConfig {
    [CmdletBinding()]
    param()

    $cfg = Get-RAGConfig

    if (Test-Path $cfg.OutputFullName) {
        Remove-Item $cfg.OutputFullName
    }
}
