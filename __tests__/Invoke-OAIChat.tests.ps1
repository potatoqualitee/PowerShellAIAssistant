Describe "Invoke-OAIChat" -Tag Invoke-OAIChat {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Invoke-OAIChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'should have these parameters' {
        $actual = Get-Command Invoke-OAIChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
     
        $actual.Parameters.Keys.Contains('UserInput') | Should -Be $true
     
        $actual.Parameters.UserInput.Attributes.ValueFromPipeline | Should -Be $true
     
        $actual.Parameters.Keys.Contains('Instructions') | Should -Be $true
     
        $actual.Parameters.Instructions.Aliases.Count | Should -Be 0
     
        $actual.Parameters.Keys.Contains('model') | Should -Be $true
     
        $actual.Parameters.model.Attributes.ValidValues.Count | Should -Be 5
        $actual.Parameters.model.Attributes.ValidValues | Should -Be @('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-1106-preview', 'gpt-3.5-turbo-1106')
    }
}