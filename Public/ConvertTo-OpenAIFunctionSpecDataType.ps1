function ConvertTo-OpenAIFunctionSpecDataType {
    <#
        .SYNOPSIS
        Converts a .NET data type to an OpenAI Function Spec data type.

        .DESCRIPTION
        This function takes a .NET data type as input and returns the corresponding OpenAI Function Spec data type.

        .PARAMETER targetType
        The .NET data type to convert.

        .EXAMPLE
        ConvertTo-OpenAIFunctionSpecDataType -targetType 'int32'
        Returns 'number'.

        .EXAMPLE
        ConvertTo-OpenAIFunctionSpecDataType -targetType 'switchparameter'
        Returns 'boolean'.
    #>

    [CmdletBinding()]
    param($targetType)

    switch -Regex ($targetType) {
        'int|int32|int64|short|long|byte|decimal|double|float|single' {
            return 'number'
        }
        'switchparameter|bool|boolean' {
            return 'boolean'
        }
        'pscredential|hashtable|object|psobject|adsi' {
            return 'object'
        }
        'string|char|regex|securestring|timespan|datetime|datetimeoffset|uri|ipaddress|mailaddress|pattern|wildcard|scriptblock|uniqueid|guid|byte\[\]|biginteger|securestring|xml|commandtype' {
            return 'string'
        }
        '.*\[\]$' {
            return 'array'
        }
        default {
            return 'string'
        }
    }
}