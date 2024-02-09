$assistantIdFileName = "$PSScriptRoot\assistantId.txt"

function Get-AssistantId {
    Get-Content $assistantIdFileName    
}

function Save-AssistantId {
    param(
        $AssistantId
    )

    $AssistantId | Set-Content $assistantIdFileName
}

function ragAssistant {
    param(
        $Question,        
        # [Parameter(ValueFromPipelineByPropertyName)]
        # [Alias('FullName')]
        # $Path,
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

        $targetAssistantId = Get-AssistantId
        if ($null -ne $targetAssistantId) {
            Write-Error "No rag assistant found. Please add files."
            return
        }
        elseif (Test-OAIAssistantId $targetAssistantId -eq $false) {
            New-RagAssistant $files
        }
        # else {
        #     $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        #     $assistantParams = @{
        #         Name         = "rag assistant-$timestamp"
        #         Instructions = "Please read all, repeat all the uploaded file(s) to answer all questions. Pls summarize your answer in 1-2 sentences."
        #         Model        = 'gpt-4-turbo-preview' 
        #         Tools        = Enable-OAIRetrievalTool
        #         FileIds      = $files.id
        #     }
        
        #     $assistant = New-OAIAssistant @assistantParams            
        #     Save-AssistantId $assistant.id
        # }

        if (!$Chat -and $null -ne $Question) {
            askQuestion $Question $assistant
        }
        elseif ($Chat) {
            ChatREPL $assistant
        }
    }
}

function askQuestion {
    param(
        $Question,
        $Assistant
    )

    Write-Host "Asking the question: " -NoNewline
    Write-Host -ForegroundColor Yellow $Question

    $queryResult = New-OAIThreadQuery -UserInput $Question -Assistant $Assistant 
    $null = Wait-OAIOnRun -Run $queryResult.Run -Thread $queryResult.Thread
    $messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id
    $messages.data[0].content.text.value
}

#ragAssistant -Question "How do I get started?"