function Invoke-SimpleQuestion {
    param(
        [Parameter(Mandatory)]
        $Question,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $AssistantId
    )

    Begin {
        $assistant = @()
    }

    Process {
        if($null -eq $AssistantId) {
            Write-Error "AssistantId is required"
            return
        }

        if (!(Test-OAIAssistantId $AssistantId)) {
            Write-Error "Assistant with Id $AssistantId not found"
            return
        }

        $assistant += Get-OAIAssistantItem -AssistantId $AssistantId
    }

    End {
        if($null -eq $assistant) {
            return
        }

        foreach ($assistantItem in $assistant) {
            $assistantName = $assistantItem.Name
            if ($null -eq $assistantName) {
                $assistantName = 'Assistant'
            }

            Write-Host "Asking the question: " -NoNewline
            Write-Host -ForegroundColor Yellow $Question

            $queryResult = New-OAIThreadQuery -UserInput $Question -Assistant $assistantItem
            $null = Wait-OAIOnRun -Run $queryResult.Run -Thread $queryResult.Thread
            $messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id
            $messages.data[0].content.text.value
        }
    }
}

function Invoke-QuickChat {
    param(
        [Parameter(Mandatory)]
        $AssistantId
    )

    if (!(Test-OAIAssistantId $AssistantId)) {
        Write-Error "Assistant with Id $AssistantId not found"
        return
    }

    $assistant = Get-OAIAssistantItem -AssistantId $AssistantId
    $assistantName = $assistant.Name
    if ($null -eq $assistantName) {
        $assistantName = 'Assistant'
    }

    "Hello, I am an $($assistantName). Type 'Exit' to exit."

    while ($true) {
        #$userInput = Read-Host "Ask $($assistantName) a question"
        $userInput = Read-Host "Question"
    
        if ($userInput -eq 'Exit') {
            break
        }

        if (!$threadQuery) {
            $threadQuery = New-OAIThreadQuery -Assistant $assistant -UserInput $userInput
        }
        else {
            $submitResponse = Submit-OAIMessage -Assistant $assistant -Thread $threadQuery.Thread -UserInput $userInput

            $threadQuery.Run = $submitResponse.Run
            $threadQuery.Message = $submitResponse.Message
        }

        $null = Wait-OAIOnRun -Thread $threadQuery.Thread -Run $threadQuery.Run

        $message = Get-OAIMessage -ThreadId $threadQuery.Thread.Id -Order asc
        $message.data[-1].content.text.value
    }
}


function New-QuickChat {
    $assistant = New-OAIAssistant -Instructions "You only handle longitude and latitude questions." -Name "Lat And Long assistant"
    Invoke-QuickChat -AssistantId $assistant.id
}
