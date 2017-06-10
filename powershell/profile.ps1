if ($Host.Name -eq 'ConsoleHost') {

    if (-not(Get-Module PSReadline -ErrorAction SilentlyContinue)) {

        Import-Module PSReadLine -ErrorAction SilentlyContinue

    }

    if (Get-Module PSReadline -ErrorAction SilentlyContinue) {

        # Searching for commands with up/down arrow is really handy.  The
        # option "moves to end" is useful if you want the cursor at the end
        # of the line while cycling through history like it does w/o searching,
        # without that option, the cursor will remain at the position it was
        # when you used up arrow, which can be useful if you forget the exact
        # string you started the search on.
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd
        Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

        # This key handler shows the entire or filtered history using Out-GridView. The
        # typed text is used as the substring pattern for filtering. A selected command
        # is inserted to the command line without invoking. Multiple command selection
        # is supported, e.g. selected by Ctrl + Click.
        Set-PSReadlineKeyHandler -Key F7 `
                                 -BriefDescription History `
                                 -LongDescription 'Show command history' `
                                 -ScriptBlock {
            $pattern = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
            if ($pattern)
            {
                $pattern = [regex]::Escape($pattern)
            }

            $history = [System.Collections.ArrayList]@(
                $last = ''
                $lines = ''
                foreach ($line in [System.IO.File]::ReadLines((Get-PSReadlineOption).HistorySavePath))
                {
                    if ($line.EndsWith('`'))
                    {
                        $line = $line.Substring(0, $line.Length - 1)
                        $lines = if ($lines)
                        {
                            "$lines`n$line"
                        }
                        else
                        {
                            $line
                        }
                        continue
                    }

                    if ($lines)
                    {
                        $line = "$lines`n$line"
                        $lines = ''
                    }

                    if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
                    {
                        $last = $line
                        $line
                    }
                }
            )
            $history.Reverse()

            $command = $history | Out-GridView -Title History -PassThru
            if ($command)
            {
                [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
            }
        }

        # Use the bash style completion, without using Emacs mode:
        Set-PSReadlineKeyHandler -Key Tab -Function Complete

        # If the bash style completion is used (by setting Emacs mode or changing tab function),
        # the Windows style completion still has its uses, so bind some keys so we can do both.
        Set-PSReadlineKeyHandler -Key Ctrl+Tab -Function TabCompleteNext
        Set-PSReadlineKeyHandler -Key Ctrl+Shift+Tab -Function TabCompletePrevious

        # The built-in word movement uses character delimiters, but token based word
        # movement is also very useful - these are the bindings you'd use if you
        # prefer the token based movements bound to the normal emacs word movement
        # key bindings.
        Set-PSReadlineKeyHandler -Key Alt+D -Function ShellKillWord
        Set-PSReadlineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
        Set-PSReadlineKeyHandler -Key Alt+B -Function ShellBackwardWord
        Set-PSReadlineKeyHandler -Key Alt+F -Function ShellForwardWord
        Set-PSReadlineKeyHandler -Key Shift+Alt+B -Function SelectShellBackwardWord
        Set-PSReadlineKeyHandler -Key Shift+Alt+F -Function SelectShellForwardWord

        #region Smart Insert/Delete

        # The next four key handlers are designed to make entering matched quotes
        # parens, and braces a nicer experience.  I'd like to include functions
        # in the module that do this, but this implementation still isn't as smart
        # as ReSharper, so I'm just providing it as a sample.


        # Insert paired quotes if not already on a quote
        Set-PSReadlineKeyHandler -Chord "Ctrl+'","Ctrl+Shift+'" `
                                 -BriefDescription SmartInsertQuote `
                                 -Description "Insert paired quotes if not already on a quote" `
                                 -ScriptBlock {
            param($key, $arg)

            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

            $keyChar = $key.KeyChar
            if ($key.Key -eq 'Oem7') {
                if ($key.Modifiers -eq 'Control') {
                    $keyChar = "`'"
                }
                elseif ($key.Modifiers -eq 'Shift','Control') {
                    $keyChar = '"'
                }
            }

            if ($line[$cursor] -eq $key.KeyChar) {
                # Just move the cursor
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            }
            else {
                # Insert matching quotes, move cursor to be in between the quotes
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$keyChar" * 2)
                [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
            }
        }


        Set-PSReadlineKeyHandler -Key '(','{','[' `
                                 -BriefDescription InsertPairedBraces `
                                 -LongDescription "Insert matching braces" `
                                 -ScriptBlock {
            param($key, $arg)

            $closeChar = switch ($key.KeyChar)
            {
                <#case#> '(' { [char]')'; break }
                <#case#> '{' { [char]'}'; break }
                <#case#> '[' { [char]']'; break }
            }

            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
        }

        # Doesn't seem to work
        Set-PSReadlineKeyHandler -Key ')',']','}' `
                                 -BriefDescription SmartCloseBraces `
                                 -LongDescription "Insert closing brace or skip" `
                                 -ScriptBlock {
            param($key, $arg)

            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

            if ($line[$cursor] -eq $key.KeyChar)
            {
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            }
            else
            {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
            }
        }

        # Doesn't seem to work.
        Set-PSReadlineKeyHandler -Key Backspace `
                                 -BriefDescription SmartBackspace `
                                 -LongDescription "Delete previous character or matching quotes/parens/braces" `
                                 -ScriptBlock {
            param($key, $arg)

            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

            if ($cursor -gt 0)
            {
                $toMatch = $null
                if ($cursor -lt $line.Length)
                {
                    switch ($line[$cursor])
                    {
                        <#case#> '"' { $toMatch = '"'; break }
                        <#case#> "'" { $toMatch = "'"; break }
                        <#case#> ')' { $toMatch = '('; break }
                        <#case#> ']' { $toMatch = '['; break }
                        <#case#> '}' { $toMatch = '{'; break }
                    }
                }

                if ($toMatch -ne $null -and $line[$cursor-1] -eq $toMatch)
                {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
                }
                else
                {
                    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
                }
            }
        }

        #endregion Smart Insert/Delete

        # Sometimes you enter a command but realize you forgot to do something else first.
        # This binding will let you save that command in the history so you can recall it,
        # but it doesn't actually execute.  It also clears the line with RevertLine so the
        # undo stack is reset - though redo will still reconstruct the command line.
        Set-PSReadlineKeyHandler -Key Alt+w `
                                 -BriefDescription SaveInHistory `
                                 -LongDescription "Save current line in history but do not execute" `
                                 -ScriptBlock {
            param($key, $arg)

            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
            [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        }

        # Insert text from the clipboard as a here string
        Set-PSReadlineKeyHandler -Key Ctrl+Shift+v `
                                 -BriefDescription PasteAsHereString `
                                 -LongDescription "Paste the clipboard text as a here string" `
                                 -ScriptBlock {
            param($key, $arg)

            Add-Type -Assembly PresentationCore
            if ([System.Windows.Clipboard]::ContainsText())
            {
                # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
                $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n","`n").TrimEnd()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
            }
            else
            {
                [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
            }
        }

        # Sometimes you want to get a property of invoke a member on what you've entered so far
        # but you need parens to do that.  This binding will help by putting parens around the current selection,
        # or if nothing is selected, the whole line.
        Set-PSReadlineKeyHandler -Key 'Alt+(' `
                                 -BriefDescription ParenthesizeSelection `
                                 -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
                                 -ScriptBlock {
            param($key, $arg)

            $selectionStart = $null
            $selectionLength = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            if ($selectionStart -ne -1)
            {
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
            }
            else
            {
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
                [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
            }
        }

        # This example will replace any aliases on the command line with the resolved commands.
        Set-PSReadlineKeyHandler -Key "Alt+%" `
                                 -BriefDescription ExpandAliases `
                                 -LongDescription "Replace all aliases with the full command" `
                                 -ScriptBlock {
            param($key, $arg)

            $ast = $null
            $tokens = $null
            $errors = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

            $startAdjustment = 0
            foreach ($token in $tokens)
            {
                if ($token.TokenFlags -band [System.Management.Automation.Language.TokenFlags]::CommandName)
                {
                    $alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
                    if ($alias -ne $null)
                    {
                        $resolvedCommand = $alias.ResolvedCommandName
                        if ($resolvedCommand -ne $null)
                        {
                            $extent = $token.Extent
                            $length = $extent.EndOffset - $extent.StartOffset
                            [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                                $extent.StartOffset + $startAdjustment,
                                $length,
                                $resolvedCommand)

                            # Our copy of the tokens won't have been updated, so we need to
                            # adjust by the difference in length
                            $startAdjustment += ($resolvedCommand.Length - $length)
                        }
                    }
                }
            }
        }

        # F1 for help on the command line - naturally
        Set-PSReadlineKeyHandler -Key F1 `
                                 -BriefDescription CommandHelp `
                                 -LongDescription "Open the help window for the current command" `
                                 -ScriptBlock {
            param($key, $arg)

            $ast = $null
            $tokens = $null
            $errors = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

            $commandAst = $ast.FindAll( {
                $node = $args[0]
                $node -is [System.Management.Automation.Language.CommandAst] -and
                    $node.Extent.StartOffset -le $cursor -and
                    $node.Extent.EndOffset -ge $cursor
                }, $true) | Select-Object -Last 1

            if ($commandAst -ne $null)
            {
                $commandName = $commandAst.GetCommandName()
                if ($commandName -ne $null)
                {
                    $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
                    if ($command -is [System.Management.Automation.AliasInfo])
                    {
                        $commandName = $command.ResolvedCommandName
                    }

                    if ($commandName -ne $null)
                    {
                        Get-Help $commandName -ShowWindow
                    }
                }
            }
        }
    }

}

Import-Module posh-git
