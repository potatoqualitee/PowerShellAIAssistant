function Invoke-DataQuery {
    param (
        [Parameter(Mandatory)]
        $UserInput,
        [Parameter(Mandatory)]
        $FilePath
    )

    $file = Invoke-OAIUploadFile -Path $FilePath

    $assistantParams = @{
        Name         = 'DataAnalyzer'
        Instructions = 'You are a helpful data analyst. When asked a question, you will parse the attached  file to provide the requested analysis.'
        FileIds      = $file.id
        Tools        = Enable-OAICodeInterpreter
        #Model        = 'gpt-4-1106-preview'
    }

    $assistant = New-OAIAssistant @assistantParams

    $result = New-OAIThreadQuery -Assistant $assistant -UserInput $UserInput 
    $result.run = Wait-OAIOnRun -Run $result.run -Thread $result.thread

    Out-OAIMessages -Messages (Get-OAIMessage -ThreadId $result.thread.id -Order asc -After $result.message.id).data

    $null = Remove-OAIFile -id $file.id
    $null = Remove-OAIAssistant -Id $assistant.id

    $result
}