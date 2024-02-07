<#
.SYNOPSIS
Clears the assistant and associated files.

.DESCRIPTION
The Clear-AssistantAndFile function removes the specified assistant and all associated files from the system.

.PARAMETER AssistantId
The ID of the assistant to be cleared. This parameter is mandatory.

.EXAMPLE
Clear-AssistantAndFile -AssistantId "12345"
Removes the assistant with ID "12345" and all associated files.

#>
function Clear-AssistantAndFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]        
        $AssistantId
    )

    $targetAssistant = Get-OAIAssistantItem -AssistantId $AssistantId
    Write-Verbose "Removing assistant $($targetAssistant.name) with id $($targetAssistant.id)"
    $null = Remove-OAIAssistant -Id $targetAssistant.id
    
    foreach ($file in $targetAssistant.file_Ids) {
        $targetFile = Get-OAIFileItem -FileId $file
        Write-Verbose "Removing file $($targetFile.filename) with id $($targetFile.id)"
        $null = Remove-OAIFile -Id $targetFile.id
    }
}