# https://docs.llamaindex.ai/en/stable/use_cases/q_and_a/rag_cli.html

function ragAssistant {
    [CmdletBinding()]
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

    end {
        # need a timestamp
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $assistantParams = @{
            Name         = "rag assistant-$timestamp"
            Instructions = "Please read all, repeat all the uploaded file(s) to answer all questions. Pls summarize your answer in 1-2 sentences."
            Model        = 'gpt-4-turbo-preview' 
            Tools        = Enable-OAIRetrievalTool
            FileIds      = $files.id
        }

        $assistant = New-OAIAssistant @assistantParams
        $assistant.id | Set-Content "$PSScriptRoot\assistantId.txt"

        Write-Host "Asking the question: " -NoNewline
        Write-Host -ForegroundColor Yellow $Question

        $queryResult = New-OAIThreadQuery -UserInput $Question -Assistant $assistant 
        $null = Wait-OAIOnRun -Run $queryResult.Run -Thread $queryResult.Thread
        $messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id
        $messages.data[0].content.text.value
    }    
}

return 
function SingleQuestion {

}

function QuickChat {

}

function SnapTalk {

}