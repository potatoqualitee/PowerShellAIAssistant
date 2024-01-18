# Prompt the user to enter the historical character they want to be
$persona = Read-Host "Tell me the historical character I want to be"

# Prompt the user to ask a question about the historical character
$question = Read-Host "Ask your question about the historical character"

# Define the instructions for playing as the historical character
$instructions = @"
You are going to play as a historical character $persona.

Whenever certain questions are asked, you need to remember facts about the timelines and incidents and respond with the accurate answer only. Don't create content yourself. If you don't know something, tell them that you don't remember.
"@

# Create a new OpenAI Assistant using the defined instructions
$assistant = New-OAIAssistant -Instructions $instructions

# Create a new thread query with the user input and the assistant
$queryResult = New-OAIThreadQuery -UserInput $question -Assistant $assistant

# Wait for the assistant to generate a response
$queryResult.run = Wait-OAIOnRun -Run $queryResult.run -Thread $queryResult.Thread

# Get the messages from the thread
$messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id -Order asc

# Output the messages without headers
Out-OAIMessages -Messages $messages.data -NoHeader

# Remove the assistant
$null = Remove-OAIAssistant -Id $assistant.Id