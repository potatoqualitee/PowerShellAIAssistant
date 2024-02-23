
Describe 'Update-OAIAssistant' -Tag Update-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Update-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys.Contains('Id') | Should -Be $true
        $actual.Parameters['Id'].Attributes.ValueFromPipelineByPropertyName | Should -Be $true

        $actual.Parameters.Keys.Contains('Model') | Should -Be $true
        
        $validateScript = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateScriptAttribute] }
        $validateScript | Should -Not -BeNullOrEmpty
        $scriptBlock = $validateScript.ScriptBlock
        $scriptBlock.ToString().Trim() | Should -BeExactly 'Test-LLMModel'

        $actual.Parameters.Keys.Contains('Name') | Should -Be $true
        $actual.Parameters.Keys.Contains('Description') | Should -Be $true
        $actual.Parameters.Keys.Contains('Instructions') | Should -Be $true

        $actual.Parameters.Keys.Contains('FileIds') | Should -Be $true
        $actual.Parameters.FileIds.Aliases.Count | Should -Be 1
        $actual.Parameters.FileIds.Aliases | Should -Be 'file_ids'

        $actual.Parameters.Keys.Contains('Metadata') | Should -Be $true
    }
}