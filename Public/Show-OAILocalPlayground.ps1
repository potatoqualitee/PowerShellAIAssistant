<#
.SYNOPSIS
Starts a local playground interface that lets you play with OAI
#>

function Show-OAILocalPlayground {
    param(
        $port = 8080
    )
    $script:port = $port

    if (-not $ENV:OpenAIKey) {
        Write-Warning 'No $ENV:OpenAIKey found.'
    }

    # When someone clones the PowerShellAIAssistant repo, but it isn't in any PSModulePath, the playground will fail.
    if (-not (Get-Module -list PowerShellAIAssistant)) {
        throw 'PowerShellAIAssistant not found in any module directories. Please add a PSModulePath to the correct location if using a custom one. e.g. $ENV:PSModulePath += "; $pwd"'
    }

    # Avoid the ugly logic of (-not () -or -not ())
    if ((Get-Module -list Pode) -and (Get-Module -list Pode.Web)) {}
    else {
        # Get enthusiastic consent before installing extra modules on someone's system
        if ("y" -eq (Read-Host "The local playground requires Pode and Pode.Web. Type 'y' to install to local user from PSGallery")) {
            if (-not (Get-Module -list Pode)) { Install-Module Pode -Scope CurrentUser -Force }
            if (-not (Get-Module -list Pode.Web)) { Install-Module Pode.Web -Scope CurrentUser -Force }
        }
        else {
            throw "Pode and Pode.Web are not installed and consent was not given."
        }
    }

    # Pode.Web needs to be in the global scope for runspaces to access functions
    Import-Module Pode.Web -Scope Global

    Start-PodeServer -StatusPageExceptions Show -Threads 3 {
        $endpoint_param = @{
            Address  = "localhost"
            Port     = $script:port
            Protocol = "Http"
            Name     = "Local Playground"
        }
        Add-PodeEndpoint @endpoint_param

        Enable-PodeSessionMiddleware -Duration ([int]::MaxValue)

        Use-PodeWebTemplates -Title SampleApp -Theme Dark


        # Want the assistants and history to be accessible regardless of session
        New-PodeLockable "historyList_lock"
        Set-PodeState -Name "historyList" -Value @()
        New-PodeLockable "assistantList_lock"
        Set-PodeState -Name "assistantList" -Value @()

        Lock-PodeObject -Name "historyList_lock" -ScriptBlock {
            Set-PodeState -Name "historyList" -Value ([array](Get-PodeState -Name "historyList") + "Get-OAIAssistant")
        }
        $assistantList = Get-OAIAssistant
        Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
            Set-PodeState -Name "assistantList" -Value $assistantList
        }


        Add-PodeWebPage -Name Comments -ScriptBlock {
            New-PodeWebCard -Content @(
                New-PodeWebComment -Username "My user here" -Message "Test" -TimeStamp (Get-Date) -Icon Lock
            )
        }

        Add-PodeWebPage -Name CodeHistory -DisplayName "Code history" -ScriptBlock {
            New-PodeWebCard -Content @(
                New-PodeWebTextbox -Name "Cmdlets" -Multiline -ReadOnly -Value (Get-History).CommandLine
            )
        }

        Add-PodeWebPage -Name ChatGPT -ScriptBlock {
            New-PodeWebCard -Content @(
                New-PodeWebButton -Name "Update assistant list" -ScriptBlock {
                    $assistantList = Get-OAIAssistant

                    Lock-PodeObject -Name "historyList_lock" -ScriptBlock {
                        Set-PodeState -Name "historyList" -Value ([array](Get-PodeState -Name "historyList") + "Get-OAIAssistant")
                    }
                    Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
                        Set-PodeState -Name "assistantList" -Value $assistantList
                    }
                    Move-PodeWebUrl -Url /pages/ChatGPT
                }
            )

            New-PodeWebCard -Content @(
                New-PodeWebForm -Name 'Example' -Content @(
                    New-PodeWebSelect -Name "Assistant" -Id "Assistant" -Options (@((Get-PodeState -Name "assistantList").id) + "New") -DisplayOptions (@((Get-PodeState -Name "assistantList").Name) + "New (Sample assistant)")
                    New-PodeWebSelect -Name "Thread" -Id "Thread" -Options (@($WebEvent.Session.Data.Threads.id) + "New...") -SelectedValue $WebEvent.Session.Data.Thread.id
                    New-PodeWebTextbox -Name 'Message'
                ) -ScriptBlock {
                    if ($WebEvent.Data['Assistant'] -eq "New") {
                        $assistant = New-OAIAssistant -Name 'Math Tutor' -Instructions 'You are a helpful math assistant. Please explain your answers.'
                        Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
                            $assistantList = Get-PodeState -Name "assistantList"
                            $assistantList = @($assistantList) + $assistant
                            Set-PodeState -Name "assistantList" -Value $assistantList
                        }
                        Update-PodeWebSelect -Id "Assistant" -SelectedValue $assistant.id -Options (@((Get-PodeState -Name "assistantList").id) + "New") -DisplayOptions (@((Get-PodeState -Name "assistantList").Name) + "New (Sample assistant)")
                        $assistantID = $assistant.id
                    }
                    else {
                        $assistantID = $WebEvent.Data['Assistant']
                    }
                    if ($WebEvent.Data['Thread'] -eq "New...") {
                        $WebEvent.Session.Data.Thread = New-OAIThread
                        $WebEvent.Session.Data.Threads = @($WebEvent.Session.Data.Threads) + $WebEvent.Session.Data.Thread | Sort-Object -Unique -Property created_at
                        @($WebEvent.Session.Data.Threads.id) + "New..." | Update-PodeWebSelect -Id "Thread" -SelectedValue $WebEvent.Session.Data.Thread
                    }
                    else {
                        $WebEvent.Session.Data.Thread = $WebEvent.Session.Data.Threads | Where-Object id -EQ $WebEvent.Data['Thread']
                    }

                    New-OAIMessage -ThreadId $WebEvent.Session.Data.Thread.id -Role user -Content $WebEvent.Data['Message'] | Out-Null

                    $run = New-OAIRun -ThreadId $WebEvent.Session.Data.Thread.id -AssistantId $assistantID
                    Wait-OAIOnRun -Run $run -Thread $WebEvent.Session.Data.Thread | Out-Null

                    $messages = Get-OAIMessage -ThreadId $WebEvent.Session.Data.Thread.id -Order asc
                    $messages.data | Select-Object Role, @{n = 'Message'; e = { $_.content.text.value } } | ForEach-Object {
                        "{0}: {1}" -f $_.Role, $_.Message
                        if ($_.Role -eq "Assistant") { "" }
                    } | Out-String | Out-PodeWebTextbox -Multiline -ReadOnly

                    Clear-PodeWebTextbox -Name Message
                }
            ) -CssStyle @{"max-width" = "800px" }
        }



        ConvertTo-PodeWebPage -Module PowerShellAIAssistant -Commands @(
            "Get-OAIAssistant"
            "New-OAIAssistant"
            # "New-OAIThread"
            # "New-OAIMessage"
            "New-OAIRun"
            # "Wait-OAIOnRun"
            "Get-OAIMessage"
            "Remove-OAIThread"
            "Remove-OAIAssistant"
        )
    }
}
