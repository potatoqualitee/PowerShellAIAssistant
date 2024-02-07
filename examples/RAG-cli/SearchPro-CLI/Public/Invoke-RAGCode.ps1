function Invoke-RAGCode {
    [CmdletBinding ()]
    [alias("ragcode")]
    param(
        $Question,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path,     
        [Switch]$Chat
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

        $timestamp = Get-Date -Format "yyyyMMddHHmmss"

        $assistantParams = @{
            Name         = "rag-code assistant-$timestamp"
            Instructions = "Please read all, repeat all the uploaded file(s) to answer all questions. Pls summarize your answer in 1-2 sentences."
            Model        = 'gpt-4-turbo-preview' 
            Tools        = Enable-OAICodeInterpreter
            FileIds      = $files.id
        }

        $assistant = New-OAIAssistant @assistantParams

        if (!$Chat -and $null -ne $Question) {             
            Invoke-SimpleQuestion -AssistantId $assistant.id -Question $Question
        }
        elseif ($Chat) {
            Invoke-QuickChat -AssistantId $assistant.id
        }
    }
}