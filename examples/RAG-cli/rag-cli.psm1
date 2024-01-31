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

<#
.SYNOPSIS
Clears the assistant and associated files.

.DESCRIPTION
The Clear-AssistantAndFile function removes the specified assistant and all associated files from the system.

.PARAMETER AssistantId
The ID of the assistant to be cleared. This parameter is mandatory.

.EXAMPLE
Clear-AssistantAndFile -AssistantId "12345"
Removes the assistant with ID "12345" and all associated files.

#>
function Clear-AssistantAndFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]        
        $AssistantId
    )

    $targetAssistant = Get-OAIAssistantItem -AssistantId $AssistantId
    Write-Verbose "Removing assistant $($targetAssistant.name) with id $($targetAssistant.id)"
    $null = Remove-OAIAssistant -Id $targetAssistant.id
    
    foreach ($file in $targetAssistant.file_Ids) {
        $targetFile = Get-OAIFileItem -FileId $file
        Write-Verbose "Removing file $($targetFile.filename) with id $($targetFile.id)"
        $null = Remove-OAIFile -Id $targetFile.id
    }
}