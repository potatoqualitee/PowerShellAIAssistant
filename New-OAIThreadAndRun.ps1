function New-OAIThreadAndRun {
    [CmdletBinding()]
    param(
        $Assistant, 
        $UserInput
    )

    $thread = New-OAIThread
    $submitResult = Submit-OAIMessage $Assistant $thread $UserInput

    [PSCustomObject]@{
        Thread = $thread
        Run    = $submitResult.Run
    }
}

$assistant = New-OAIAssistant -Name 'Math Tutor' -Instructions 'You are an expert in Math'

$threadAndRun1 = New-OAIThreadAndRun $assistant -UserInput 'What is 2 + 2?'
$threadAndRun2 = New-OAIThreadAndRun $assistant -UserInput 'I had 3 apples and ate 1.'
$threadAndRun3 = New-OAIThreadAndRun $assistant -UserInput 'What is 3x + 2 = 4'

# $threadAndRun = New-OAIThreadAndRun $assistant -UserInput 'What is 2 + 2?'
# $null = Wait-OAIOnRun -Thread $threadAndRun.Thread -Run $threadAndRun.Run
# (Get-OAIMessage $threadAndRun.Thread.id -Order asc).data.content.text.value

# $null = Remove-OAIAssistant -Id $assistant.id

#(Get-OAIMessage $threadAndRun.Thread.id -Order asc).data.content.text.value

<#
$threadAndRun1, $threadAndRun2, $threadAndRun3 | ForEach-Object {
    (Get-OAIMessage $_.Thread.id -Order asc).data.content.text.value
    ''
}
#>