function ConvertFrom-FunctionDefinition {
    <#
    .SYNOPSIS
    Converts a PowerShell function definition to an OpenAI function specification.

    .DESCRIPTION
    This function takes a PowerShell function definition and converts it to an OpenAI function specification.

    .PARAMETER FunctionInfo
    An array of CommandInfo objects representing the functions to convert.

    .EXAMPLE
    PS C:\> ConvertFrom-FunctionDefinition -FunctionInfo (Get-Command Get-ChildItem)

    This example converts the Get-ChildItem function to an OpenAI function specification.

    .EXAMPLE
    PS C:\> Get-Command Get-ChildItem | ConvertFrom-FunctionDefinition

    This example converts the Get-ChildItem function to an OpenAI function specification, this time using piping.

    #>
    param (
        [Parameter(ValueFromPipeline)]
        [System.Management.Automation.CommandInfo[]]$FunctionInfo
    )
    
    Get-FunctionDefinition $FunctionInfo | ForEach-Object {
        ConvertTo-OpenAIFunctionSpec -targetCode $_ -Raw
    }
}