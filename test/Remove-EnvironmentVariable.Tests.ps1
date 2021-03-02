$ModuleRoot = Split-Path -LiteralPath $PSScriptRoot -Resolve

Import-Module -Name $ModuleRoot -Force

$IsAdmin = [System.Security.Principal.WindowsPrincipal]::new(
    [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [System.Security.Principal.WindowsBuiltInRole]::Administrator)

Describe "Remove-EnvironmentVariable" {
    BeforeAll {
        $name = "Name"
        $value = "Value"
        $nameTemp = "TEMP"
        $nonExistVariable = "NonExistingVariable"
    }

    Context "No target" {
        It "Throws an exception if the environment variable does not found" {
            { Remove-EnvironmentVariable -Name $nonExistVariable -Force } |
            Should -Throw -ErrorId "EnvironmentVariableNotFound,Remove-EnvironmentVariable"
        }

        It "Should set an environment variable" {
            try {
                [System.Environment]::SetEnvironmentVariable($name, $value)
                { Remove-EnvironmentVariable -Name $name -Force } | Should -Not -Throw
                [System.Environment]::GetEnvironmentVariable($name) | Should -BeNullOrEmpty
            }
            finally {
                [System.Environment]::SetEnvironmentVariable($name, $null)
            }
        }
    }

    Context "With User target" {
        BeforeAll {
            $target = [System.EnvironmentVariableTarget]::User
        }

        It "Throws an exception if the environment variable does not found" {
            { Remove-EnvironmentVariable -Name $nonExistVariable -Target $target -Force } |
            Should -Throw -ErrorId "EnvironmentVariableNotFound,Remove-EnvironmentVariable"
        }

        It "Should set an environment variable" {
            try {
                [System.Environment]::SetEnvironmentVariable($name, $value, $target)
                { Remove-EnvironmentVariable -Name $name -Target $target -Force } | Should -Not -Throw
                [System.Environment]::GetEnvironmentVariable($name) | Should -BeNullOrEmpty
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
            { Remove-EnvironmentVariable -Name $nameTemp -Target $target -Force } |
            Should -Throw -ErrorId "SecurityException,Remove-EnvironmentVariable"
        }
        #endregion

        #region with Administrators rights
        It "Throws an exception if the environment variable does not found" -Skip:(-not $IsAdmin) {
            { Remove-EnvironmentVariable -Name $nonExistVariable -Target $target -Force } |
            Should -Throw -ErrorId "EnvironmentVariableNotFound,Remove-EnvironmentVariable"
        }

        It "Should set an environment variable" -Skip:(-not $IsAdmin) {
            try {
                [System.Environment]::SetEnvironmentVariable($name, $value, $target)
                { Remove-EnvironmentVariable -Name $name -Target $target -Force } | Should -Not -Throw
                [System.Environment]::GetEnvironmentVariable($name) | Should -BeNullOrEmpty
            }
            finally {
                [System.Environment]::SetEnvironmentVariable($name, $null, $target)
            }
        }
        #endregion
    }
}
