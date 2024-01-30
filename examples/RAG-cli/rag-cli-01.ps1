$assistantIdFileName = "$PSScriptRoot\assistantId.txt"
function Get-AssistantId {
    Get-Content $assistantIdFileName    
}

function Save-AssistantId {
    param(
        $AssistantId
    )

    $AssistantId | Set-Content $assistantIdFileName
}

$a = New-OAIAssistant

Save-AssistantId $a.id
Get-AssistantId
