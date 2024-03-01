<#
.SYNOPSIS
Retrieves the OpenAI function call specification for the specified PowerShell functions.

.DESCRIPTION
The Get-OAIFunctionCallSpec function retrieves the OpenAI function call specification for the specified PowerShell functions. It takes an array of function names as input and returns the function call specifications in a tool-specific format.

.PARAMETER functionNames
Specifies an array of function names for which the function call specifications need to be retrieved.

.EXAMPLE
Get-OAIFunctionCallSpec -functionNames "Get-Process", "Get-Service"
This example retrieves the function call specifications for the "Get-Process" and "Get-Service" PowerShell functions.
#>
function Get-OAIFunctionCallSpec {
    [CmdletBinding()]
    param(
        [string[]]$functionNames
    )

    if($null -eq $functionNames) {
        return
    }

    $functions = foreach ($function in $functionNames) {
        $fn = Get-Command $function -ErrorAction SilentlyContinue

        if (-not $fn) {
            Write-Warning "Function $function does not exist"
            continue
        }
        
        $fnd = Get-FunctionDefinition $fn
        ConvertTo-OpenAIFunctionSpec $fnd -Raw
    }

    ConvertTo-ToolFormat $functions
}
