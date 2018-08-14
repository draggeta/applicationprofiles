param(
    [string]$Suite,
    [parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Passthrough
    )

python "$env:LOCALAPPDATA\Programs\Python\Python37\Scripts\pyang" $Passthrough
