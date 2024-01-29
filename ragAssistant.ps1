# https://blog.llamaindex.ai/introducing-the-llamaindex-retrieval-augmented-generation-command-line-tool-a973fa519a41

# https://docs.llamaindex.ai/en/stable/use_cases/q_and_a/rag_cli.html
function ragAssistant {
    param(
        $Question,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path
    )

    begin {
        $files = @()
    }

    process {
        $files += Invoke-OAIUploadFile $Path
    }

    end {
        $assistantParams = @{
            Name         = "rag assistant"
            Instructions = "Please read all, repeat all the uploaded file(s) to answer all questions. Pls summarize your answer in 1-2 sentences."
            Model        = 'gpt-4-turbo-preview' 
            Tools        = Enable-OAIRetrievalTool
            FileIds      = $files.id
        }

        $assistant = New-OAIAssistant @assistantParams         
        
        Write-Host "Asking the question: " -NoNewline
        Write-Host -ForegroundColor Yellow $Question

        $queryResult = New-OAIThreadQuery -UserInput $Question -Assistant $assistant 
        $null = Wait-OAIOnRun -Run $queryResult.Run -Thread $queryResult.Thread
        $messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id
        $messages.data[0].content.text.value

        Write-Host "Clearing all items"
        $null = Clear-OAIAllItems
    }
}

# Get-ChildItem . -r *.md  | rag -Question "How do I get started using this powershell module?"
# Get-ChildItem . -r *.md  | rag "How do I get started using this powershell module?"