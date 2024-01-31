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

<#
.SYNOPSIS
    Invokes the RAG (Retrieval-augmented generation) assistant.

.DESCRIPTION
    The Invoke-RAG function is used to interact with the RAG assistant. It allows you to ask questions, provide files for context, and engage in a chat-like conversation with the assistant.

.PARAMETER Question
    Specifies the question to ask the assistant. If not provided, the function will enter chat mode.

.PARAMETER Path
    Specifies the path to a file to be uploaded and used for context. Can be provided as a pipeline input.

.PARAMETER Chat
    Switch parameter that enables chat mode. If specified, the function will enter chat mode instead of asking a specific question.

.PARAMETER Clear
    Switch parameter that clears the assistant and configuration files.

.EXAMPLE
    # Example 1: Ask a question to the RAG assistant
    Invoke-RAG -Question "What is the capital of France?"

.EXAMPLE
    # Example 2: Enter chat mode with the RAG assistant
    Invoke-RAG -Chat

.EXAMPLE
    # Example 3: Upload a file and ask a question to the RAG assistant
    Invoke-RAG -Path "C:\Documents\file.txt" -Question "Can you provide a summary of the file?"

.EXAMPLE
    # Example 4: Clear the assistant and configuration files
    Invoke-RAG -Clear
#>
function Invoke-RAG {
    param(
        $Question,        
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path,
        [Switch]$Chat,
        [Switch]$Clear            
    )

    begin {
        $files = @()
    }

    process {
        if ($Path) {
            $files += Invoke-OAIUploadFile $Path        
        }
    }

    End {

        $assistant = Get-OAIAssistantItem (Get-RAGConfigContent)

        if ($Clear -and $null -ne $assistant) {
            Clear-AssistantAndFile -AssistantId $assistant
            Clear-RAGConfig
            return
        }

        if ($null -eq $assistant) {
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $assistantParams = @{
                Name         = "rag assistant-$timestamp"
                Instructions = "Please read all, repeat all the uploaded file(s) to answer all questions. Pls summarize your answer in 1-2 sentences."
                Model        = 'gpt-4-turbo-preview' 
                Tools        = Enable-OAIRetrievalTool
                FileIds      = $files.id
            }
        
            $assistant = New-OAIAssistant @assistantParams
            Save-AssistantId -AssistantId $assistant.id
        }

        if (!$Chat -and $null -ne $Question) {             
            Invoke-SimpleQuestion -AssistantId $assistant.id -Question $Question
        }
        elseif ($Chat) {
            Invoke-QuickChat -AssistantId $assistant.id
        }
    }
}
