@{
    RootModule        = 'PowerShellAIAssistant.psm1'
    ModuleVersion     = '0.2.2'
    GUID              = '23da7dfe-f77e-4ca6-8b69-5e69603a73ca'
    Author            = 'Douglas Finke'
    CompanyName       = 'Doug Finke'
    Copyright         = 'c 2024 All rights reserved.'

    Description       = @'
PowerShellAIAssistant integrates OpenAI's AI Assistants into PowerShell, leveraging advanced AI capabilities in your PowerShell scripts for dynamic, intelligent automation and data processing
'@

    # This module uses Invoke-RestMethod, which was introduced in PSv3
    PowerShellVersion = '3.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @()

    FunctionsToExport = @(
        # Private
        'Add-OAIToolsToList'
        'Get-MultiPartFormData'
        'Invoke-OAIBeta'

        # Public
        'Clear-OAIAllItems'
        'Clear-OAIAssistants'
        'Clear-OAIFiles'
        'ConvertFrom-FunctionDefinition'
        'ConvertFrom-OAIAssistant'
        'ConvertTo-OAIAssistant'
        'ConvertTo-OpenAIFunctionSpec'
        'ConvertTo-OpenAIFunctionSpecDataType'
        'ConvertTo-ToolFormat'
        'Copy-OAIAssistant'
        'Disable-UnitTesting'
        'Enable-OAICodeInterpreter'
        'Enable-OAIRetrievalTool'
        'Enable-UnitTesting'
        'Export-OAIAssistant'
        'Format-OAIFunctionCall'
        'Get-AzOAISecrets'
        'Get-FunctionDefinition'
        'Get-OAIAssistant'
        'Get-OAIAssistantItem'
        'Get-OAIFile'
        'Get-OAIFileContent'
        'Get-OAIFileItem'
        'Get-OAIFunctionCallSpec'
        'Get-OAIMessage'
        'Get-OAIProvider'
        'Get-OAIRun'
        'Get-OAIRunItem'
        'Get-OAIRunStep'
        'Get-OAIThread'
        'Get-OAIThreadItem'
        'Get-OpenAISpecDescriptions'
        'Get-UnitTestingData'
        'Get-UnitTestingStatus'
        'Import-OAIAssistant'
        'Invoke-AIExplain'
        'Invoke-OAIChat'
        'Invoke-OAIUploadFile'
        'Invoke-QuickChat'
        'Invoke-SimpleQuestion'
        'New-OAIAssistant'
        'New-OAIMessage'
        'New-OAIRun'
        'New-OAIThread'
        'New-OAIThreadQuery'
        'Out-OAIMessages'
        'Remove-OAIAssistant'
        'Remove-OAIFile'
        'Remove-OAIThread'
        'Reset-OAIProvider'
        'Set-AzOAISecrets'
        'Set-OAIProvider'
        'Show-OAIAPIReferenceWebPage'
        'Show-OAIAssistantWebPage'
        'Show-OAILocalPlayground'
        'Show-OAIPlaygroundWebPage'
        'Submit-OAIMessage'
        'Submit-OAIToolOutputs'
        'Test-JSONReplacement'
        'Test-LLMModel'
        'Test-OAIAssistantId'
        'Update-OAIAssistant'
        'Wait-OAIOnRun'
    )

    AliasesToExport   = @(
        'ai'
        'explain'
        'goaia'
        'noaia'
        'noait'
        'roaia'
        'uoaia'
    )

    PrivateData       = @{
        PSData = @{
            Category   = "PowerShell AI Assistant Module"
            Tags       = @("PowerShell", "GPT", "OpenAI", "Assistant")
            ProjectUri = "https://github.com/dfinke/PowerShellAIAssistant"
            LicenseUri = "https://github.com/dfinke/PowerShellAIAssistant/blob/main/LICENSE"
        }
    }
}