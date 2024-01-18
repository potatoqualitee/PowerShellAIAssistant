$question = Read-Host "Ask your questions on the powershell language to your study assistant"

$instructions = @"
You are an expert on the powershell language.

Whenever certain questions are asked, you need to provide response in below format.

- Concept
- Example code showing the concept implementation
- explanation of the example and how the concept is done for the user to understand better.
"@

$assistant = New-OAIAssistant -Instructions $instructions

$queryResult = New-OAIThreadQuery -UserInput $question -Assistant $assistant

$queryResult.run = Wait-OAIOnRun -Run $queryResult.run -Thread $queryResult.Thread

$messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id -Order asc

Out-OAIMessages -Messages $messages.data -NoHeader

$null = Remove-OAIAssistant -Id $assistant.Id
