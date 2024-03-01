Describe "Get-OAIFunctionCallSpec" -Tag Get-OAIFunctionCallSpec {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "Test if it Get-OAIFunctionCallSpec exists" {
        $actual = Get-Command Get-OAIFunctionCallSpec -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('functionNames') | Should -Be $true
    }

    It "Test if Get-OAIFunctionCallSpec is null" {
        $actual = Get-OAIFunctionCallSpec
        $actual | Should -BeNullOrEmpty
    }

    It "Test Get-OAIFunctionCallSpec returns null if function does not exist" {
        $functionNames = 'Test-ThisFunction'
        
        $actual = Get-OAIFunctionCallSpec -functionNames $functionNames
        $actual | Should -BeNullOrEmpty
    }

    It "Test Get-OAIFunctionCallSpec returns function spec" {
        function Global:DoTest {
            param(
                [string]$name
            )
            Write-Host "Hello $name"
        }

        $functionNames = 'DoTest'
        
        $actual = Get-OAIFunctionCallSpec -functionNames $functionNames
        $actual | Should -Not -BeNullOrEmpty

        $actual.Contains('function') | Should -Be $true
        $actual.function.name | Should -Be 'DoTest'
        $actual.function.parameters.type | Should -Be 'object'
        $actual.function.parameters.properties.name.type | Should -Be 'string'
        $actual.function.parameters.properties.name.description | Should -Be 'not supplied'
        $actual.function.parameters.required | Should -Be @('name')
        $actual.function.description | Should -Be 'not supplied'

        $actual.Contains('type') | Should -Be $true
        $actual.type | Should -Be 'function'

        Get-ChildItem function:dotest | Remove-Item
    }

    It "Test Get-OAIFunctionCallSpec returns function spec if one fn doesn not exist" {
        function Global:DoTest {
            param(
                [string]$name
            )
            Write-Host "Hello $name"
        }

        $functionNames = 'DoTest', 'Test-ThisFunction'
        
        $actual = Get-OAIFunctionCallSpec -functionNames $functionNames
        $actual | Should -Not -BeNullOrEmpty
        
        $actual.count | Should -Be 2        

        $actual.Contains('function') | Should -Be $true
        $actual.function.name | Should -Be 'DoTest'
        $actual.function.parameters.type | Should -Be 'object'
        $actual.function.parameters.properties.name.type | Should -Be 'string'
        $actual.function.parameters.properties.name.description | Should -Be 'not supplied'
        $actual.function.parameters.required | Should -Be @('name')
        $actual.function.description | Should -Be 'not supplied'

        $actual.Contains('type') | Should -Be $true
        $actual.type | Should -Be 'function'

        Get-ChildItem function:dotest | Remove-Item
    }

}