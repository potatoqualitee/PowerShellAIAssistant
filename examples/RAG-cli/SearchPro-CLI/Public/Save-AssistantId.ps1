<#
.SYNOPSIS
    Saves the Assistant ID to a file.

.DESCRIPTION
    This function saves the Assistant ID to a file specified in the RAG configuration.

.PARAMETER AssistantId
    The Assistant ID to be saved.

.EXAMPLE
    Save-AssistantId -AssistantId "12345678"

    This example saves the Assistant ID "12345678" to the file specified in the RAG configuration.

#>
function Save-AssistantId {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $AssistantId
    )

    $cfg = Get-RAGConfig 

    if (!(Test-Path $cfg.OutputPath)) {
        $null = New-Item -ItemType Directory -Path $cfg.OutputPath
    }

    $AssistantId | Set-Content $cfg.OutputFullName
}
