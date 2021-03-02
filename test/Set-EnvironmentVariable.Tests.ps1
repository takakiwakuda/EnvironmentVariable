$ModuleRoot = Split-Path -LiteralPath $PSScriptRoot -Resolve

Import-Module -Name $ModuleRoot -Force

if ($null -eq $IsCoreCLR) {
    Set-Variable -Name IsCoreCLR -Value $false
}

$IsAdmin = [System.Security.Principal.WindowsPrincipal]::new(
    [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [System.Security.Principal.WindowsBuiltInRole]::Administrator)

Describe "Set-EnvironmentVariable" {
    BeforeAll {
        $name = "Name"
        $value = "Value"
        $nameContainsEqual = "Name="
        $nameInitialZeroChar = "{0}Name" -f [char]0x00
        $nameTooLong = [string]::new("*", 32767)
        $nameTooLong_user = [string]::new("*", 255)
        $nameTooLong_machine = [string]::new("*", 1024)
    }

    Context "No target" {
        It "Throws an exception if the name contains an equal sign (=)" {
            { Set-EnvironmentVariable -Name $nameContainsEqual -Value $value } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        It "Throws an exception if the name initial a zero character (0x00)" {
            { Set-EnvironmentVariable -Name $nameInitialZeroChar -Value $value } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        #region .NET Framework
        It "Throws an exception if the name is greater than or equal to 32,767 characters" -Skip:$IsCoreCLR {
            { Set-EnvironmentVariable -Name $nameTooLong -Value $value } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        It "Throws an exception if the value is greater than or equal to 32,767 characters" -Skip:$IsCoreCLR {
            { Set-EnvironmentVariable -Name $name -Value $nameTooLong } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }
        #endregion

        It "Should set an environment variable" {
            { Set-EnvironmentVariable -Name $name -Value $value } | Should -Not -Throw
            [System.Environment]::GetEnvironmentVariable($name) | Should -BeExactly $value
        }

        It "Should set an environment variable with PassThru" {
            $envVar = Set-EnvironmentVariable -Name $name -Value $value -PassThru
            $envVar | Should -BeOfType ([hashtable])
            [System.Environment]::GetEnvironmentVariable($name) | Should -BeExactly $envVar[$name]
        }
    }

    Context "With User target" {
        BeforeAll {
            $target = [System.EnvironmentVariableTarget]::User
        }

        It "Throws an exception if the name contains an equal sign (=)" {
            { Set-EnvironmentVariable -Name $nameContainsEqual -Value $value -Target $target } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        It "Throws an exception if the name initial a zero character (0x00)" {
            { Set-EnvironmentVariable -Name $nameInitialZeroChar -Value $value -Target $target } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        It "Throws an exception if the name is greater than or equal to 255 characters" {
            { Set-EnvironmentVariable -Name $nameTooLong_user -Value $value -Target $target } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        It "Should set an environment variable" {
            try {
                { Set-EnvironmentVariable -Name $name -Value $value -Target $target } | Should -Not -Throw
                [System.Environment]::GetEnvironmentVariable($name, $target) | Should -BeExactly $value
            }
            finally {
                [System.Environment]::SetEnvironmentVariable($name, $null, $target)
            }
        }

        It "Should set an environment variable with PassThru" {
            try {
                $envVar = Set-EnvironmentVariable -Name $name -Value $value -Target $target -PassThru
                $envVar | Should -BeOfType ([hashtable])
                [System.Environment]::GetEnvironmentVariable($name, $target) | Should -BeExactly $envVar[$name]
            }
            finally {
                [System.Environment]::SetEnvironmentVariable($name, $null, $target)
            }
        }
    }

    Context "With Machine target" {
        BeforeAll {
            $target = [System.EnvironmentVariableTarget]::Machine
        }

        #region without Administrators rights
        It "Throws an exception if the current process is not elevated" -Skip:$IsAdmin {
            { Set-EnvironmentVariable -Name $name -Value $value -Target $target } |
            Should -Throw -ErrorId "SecurityException,Set-EnvironmentVariable"
        }
        #endregion

        #region with Administrators rights
        It "Throws an exception if the name contains an equal sign (=)" -Skip:(-not $IsAdmin) {
            { Set-EnvironmentVariable -Name $nameContainsEqual -Value $value -Target $target } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        It "Throws an exception if the name initial a zero character (0x00)" -Skip:(-not $IsAdmin) {
            { Set-EnvironmentVariable -Name $nameInitialZeroChar -Value $value -Target $target } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }

        #region .NET Framework
        It "Throws an exception if the name is greater than or equal to 1,024 characters" -Skip:(-not $IsAdmin -or $IsCoreCLR) {
            { Set-EnvironmentVariable -Name $nameTooLong_machine -Value $value -Target $target } |
            Should -Throw -ErrorId "ArgumentException,Set-EnvironmentVariable"
        }
        #endregion

        It "Should set an environment variable" -Skip:(-not $IsAdmin) {
            try {
                { Set-EnvironmentVariable -Name $name -Value $value -Target $target } | Should -Not -Throw
                [System.Environment]::GetEnvironmentVariable($name, $target) | Should -BeExactly $value
            }
            finally {
                [System.Environment]::SetEnvironmentVariable($name, $null, $target)
            }
        }

        It "Should set an environment variable with PassThru" -Skip:(-not $IsAdmin) {
            try {
                $envVar = Set-EnvironmentVariable -Name $name -Value $value -Target $target -PassThru
                $envVar | Should -BeOfType ([hashtable])
                [System.Environment]::GetEnvironmentVariable($name, $target) | Should -BeExactly $envVar[$name]
            }
            finally {
                [System.Environment]::SetEnvironmentVariable($name, $null, $target)
            }
        }
        #endregion
    }
}
