# Set the prompt for the completion
$prompt = "Complete the following, be brief: Once upon a time there was a"

# Create a new AI assistant
$assistant = New-OAIAssistant

# Create a new thread query with the user input and the assistant
$queryResult = New-OAIThreadQuery -UserInput $prompt -Assistant $assistant

# Wait for the assistant to generate a response
$queryResult.run = Wait-OAIOnRun -Run $queryResult.run -Thread $queryResult.Thread

# Get the messages from the thread in ascending order
$messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id -Order asc

# Output the messages
Out-OAIMessages -Messages $messages.data

# Remove the assistant instance
$null = Remove-OAIAssistant -Id $assistant.Id