Describe "Invoke-OAIChat" -Tag Invoke-OAIChat {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Invoke-OAIChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}