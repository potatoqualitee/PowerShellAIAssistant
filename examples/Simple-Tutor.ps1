# Once developers start to understand the entirely new capabilities that having 
# cheap intelligence-on-demand brings to the table we are going to
# see a burst of really exciting and novel things ~ Ethan Mollick

param(
    $question = 'What is the capital of France?'
)

$assistant = New-OAIAssistant -Instructions 'You are an expert in geography, be helpful and concise.' -Model 

$thread = New-OAIThread

$null = New-OAIMessage $thread.id -Role user -Content $question

$run = New-OAIRun $thread.Id $assistant.Id
$status = $run.status

# Let's poll
while ($status -ne 'completed') {
    Write-Host "[$(Get-Date)] Waiting for run to complete..."
    $run = Get-OAIRun -threadId $thread.id
    $status = $run.data[0].status
    Start-Sleep -Seconds 1
}

# Get and print the messages
$messages = Get-OAIMessage -threadId $thread.id -Order asc
#$messages.data | ConvertTo-Json -Depth 10
Write-Host -ForegroundColor Yellow "Messages:"
$messages.data.content.text.value 

<#
# Optional, get and print the steps
$steps = Get-OAIRunStep -ThreadId $thread.Id -RunId $run.data[0].id
$steps | ConvertTo-Json -Depth 10
#>

# Delete the assistant
$result = Remove-OAIAssistant $assistant.Id