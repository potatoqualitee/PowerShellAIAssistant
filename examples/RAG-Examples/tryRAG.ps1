$prompt = "What are the cool things about this document?"
$files = Get-ChildItem $PSScriptRoot *.pdf | Invoke-OAIUploadFile

$params = @{
    Name         = "RAG Assistant"
    Instructions = 'You are an expert assistant in summarizing and analyzing documents. They are attached pdfs.'
    Model        = "gpt-4-turbo-preview"
    FileIds      = $files.id
    Tools        = Enable-OAIRetrievalTool
}

$assistant = New-OAIAssistant @params

$query = New-OAIThreadQuery -Assistant $assistant -UserInput $prompt

Write-Host "Waiting for the assistant to finish..." -foregroundcolor "yellow"
$null = Wait-OAIOnRun -Run $query.Run -Thread $query.Thread

$message = Get-OAIMessage -ThreadId $query.Thread.id 
$message.data.content.text.value