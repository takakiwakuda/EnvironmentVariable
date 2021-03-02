data Resources {
    ConvertFrom-StringData -StringData @'
    EnvironmentVariableNotFound = Cannot find an environment variable with name '{0}'.
    SetEnvVarAction = Set '{0}'
    RemoveEnvVarConfirmation = Are you sure you want to remove an environment variable with name '{0}'?
    RemovingEnvVar = Removing environment variable ...
'@
}

function Get-EnvironmentVariable {
    [CmdletBinding(
        HelpUri = "https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Get-EnvironmentVariable.md")]
    [OutputType([hashtable])]
    param (
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Variable")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Name,

        [Parameter()]
        [System.EnvironmentVariableTarget]
        $Target = [System.EnvironmentVariableTarget]::Process
    )

    process {
        if ($Name.Length -eq 0 -or $Name.Contains("*")) {
            GetEnvironmentVariables $Target
        }
        else {
            FilterEnvironmentVariable $Name $Target
        }
    }
}

function Remove-EnvironmentVariable {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        HelpUri = "https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Remove-EnvironmentVariable.md")]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Variable")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [System.EnvironmentVariableTarget]
        $Target = [System.EnvironmentVariableTarget]::Process,

        [Parameter()]
        [switch]
        $Force
    )

    process {
        ValidateEnvironmentVariable $Name $Target

        if ($Force.IsPresent -or
            $PSCmdlet.ShouldContinue($Resources.RemoveEnvVarConfirmation -f $Name, $Resources.RemovingEnvVar)) {
            SetEnvironmentVariable $Name $null $Target
        }
    }
}

function Set-EnvironmentVariable {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        HelpUri = "https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Set-EnvironmentVariable.md")]
    [OutputType([hashtable])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Variable")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Value,

        [Parameter()]
        [System.EnvironmentVariableTarget]
        $Target = [System.EnvironmentVariableTarget]::Process,

        [Parameter()]
        [switch]
        $PassThru
    )

    process {
        if ($PSCmdlet.ShouldProcess($Name, $Resources.SetEnvVarAction -f $Value)) {
            SetEnvironmentVariable $Name $Value $Target

            if ($PassThru.IsPresent) {
                GetEnvironmentVariable $Name $Target
            }
        }
    }
}

#region utility functions
function FilterEnvironmentVariable {
    [OutputType([hashtable])]
    param (
        [string[]]
        $Patterns,

        [System.EnvironmentVariableTarget]
        $Target
    )

    $envVars = GetEnvironmentVariables $Target
    $wildcardOptions = [System.Management.Automation.WildcardOptions]::IgnoreCase
    $output = @{}

    foreach ($pattern in $Patterns) {
        if ([WildcardPattern]::ContainsWildcardCharacters($pattern)) {
            $wildcard = [WildcardPattern]::Get($pattern, $wildcardOptions)
            $enumerator = $envVars.GetEnumerator()
            while ($enumerator.MoveNext()) {
                $key = $enumerator.Key.ToString()
                if ($wildcard.IsMatch($key) -and -not $output.ContainsKey($key)) {
                    $output.Add($key, $enumerator.Value.ToString())
                }
            }
        }
        else {
            if ($envVars.ContainsKey($pattern)) {
                if (-not $output.ContainsKey($pattern)) {
                    $output.Add($pattern, $envVars[$pattern].ToString())
                }
            }
            else {
                $errorMessage = $Resources.EnvironmentVariableNotFound -f $pattern
                $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException]::new($errorMessage),
                    "EnvironmentVariableNotFound",
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                    $pattern)

                $PSCmdlet.WriteError($errorRecord)
            }
        }
    }

    $output
}

function GetEnvironmentVariable {
    [OutputType([hashtable])]
    param (
        [string]
        $Name,

        [System.EnvironmentVariableTarget]
        $Target
    )

    $value = [System.Environment]::GetEnvironmentVariable($Name, $Target)
    if ($null -eq $value) {
        $errorMessage = $Resources.EnvironmentVariableNotFound -f $Name
        $errorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($errorMessage),
            "EnvironmentVariableNotFound",
            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
            $Name)

        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }

    @{
        $Name = $value
    }
}

function GetEnvironmentVariables {
    [OutputType([hashtable])]
    param (
        [System.EnvironmentVariableTarget]
        $Target
    )

    [hashtable]::new(
        [System.Environment]::GetEnvironmentVariables($Target),
        [System.StringComparer]::CurrentCultureIgnoreCase)
}

function SetEnvironmentVariable {
    param (
        [string]
        $Name,

        [string]
        $Value,

        [System.EnvironmentVariableTarget]
        $Target
    )

    try {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, $Target)
    }
    catch [System.ArgumentException] {
        $errorRecord = [System.Management.Automation.ErrorRecord]::new(
            $_.Exception,
            "ArgumentException",
            [System.Management.Automation.ErrorCategory]::InvalidArgument,
            $null)

        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }
    catch [System.Security.SecurityException] {
        $errorRecord = [System.Management.Automation.ErrorRecord]::new(
            $_.Exception,
            "SecurityException",
            [System.Management.Automation.ErrorCategory]::PermissionDenied,
            $null)

        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }
}

function ValidateEnvironmentVariable {
    param (
        [string]
        $Name,

        [System.EnvironmentVariableTarget]
        $Target
    )

    GetEnvironmentVariable $Name $Target > $null
}
#endregion

Export-ModuleMember -Function "Get-EnvironmentVariable", "Remove-EnvironmentVariable", "Set-EnvironmentVariable"
