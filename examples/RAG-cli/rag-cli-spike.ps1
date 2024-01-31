Import-Module $PSScriptRoot\rag-cli.psm1 -Force

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

.EXAMPLE
    # Example 5: Chat with a specific assistant
    rag -AssistantId "your-assistant-id" -Chat
#>
function Invoke-RAG {
    [alias("rag")]
    param(
        $Question,        
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path,
        # $AssistantId,
        [Switch]$Chat,
        [Switch]$Clear            
    )

    begin {
        # force it to null. revisit this later. this approach can be better generalized.
        # does not need to be tied to the RAG assistant.
        $AssistantId = $null
        $files = @()
    }

    process {
        if ($Path) {
            $files += Invoke-OAIUploadFile $Path        
        }
    }

    End {

        if ($null -eq $AssistantId) {
            $assistant = Get-OAIAssistantItem (Get-RAGConfigContent)
        }
        else {
            if (!(Test-OAIAssistantId -AssistantId $AssistantId)) {
                Write-Error "Assistant with ID $AssistantId not found."
                return                
            }
            $assistant = Get-OAIAssistantItem -AssistantId $AssistantId
        }

        if ($Clear -and $null -ne $assistant) {
            Clear-AssistantAndFile -AssistantId $assistant.id
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