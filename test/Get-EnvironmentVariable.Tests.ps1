$ModuleRoot = Split-Path -LiteralPath $PSScriptRoot -Resolve

Import-Module -Name $ModuleRoot -Force

Describe "Get-EnvironmentVariable" {
    BeforeAll {
        $nameTemp = "TEMP"
        $nonExistVariable = "NonExistingVariable"
        $nonExistVariableWithWildcard = "NonExisting*"
        $envVars_process = [System.Environment]::GetEnvironmentVariables()
        $envVars_user = [System.Environment]::GetEnvironmentVariables("User")
        $envVar_processTemp = $envVars_process[$nameTemp]
        $envVar_userTemp = $envVars_user[$nameTemp]
    }

    Context "No target" {
        It "Throws an exception if the environment variable does not found" {
            { Get-EnvironmentVariable -Name $nonExistVariable -ErrorAction Stop } |
            Should -Throw -ErrorId "EnvironmentVariableNotFound,Get-EnvironmentVariable"
        }

        It "Should retrieve all environment variables" {
            $envVars = Get-EnvironmentVariable
            $envVars | Should -BeOfType ([hashtable])
            $envVars.Count | Should -Be $envVars_process.Count
        }

        It "Should retrieve all environment variables with an asterisk" {
            $envVars = Get-EnvironmentVariable -Name "*"
            $envVars | Should -BeOfType ([hashtable])
            $envVars.Count | Should -Be $envVars_process.Count
        }

        It "Should retrieve the environment variable" {
            $envVar = Get-EnvironmentVariable -Name $nameTemp
            $envVar | Should -BeOfType ([hashtable])
            $envVar[$nameTemp] | Should -BeExactly $envVar_processTemp
        }

        It "Should also pass the exam if wildcard serach find nothing" {
            Get-EnvironmentVariable -Name $nonExistVariableWithWildcard | Should -BeNullOrEmpty
        }
    }

    Context "With target" {
        It "Throws an exception if the environment variable does not found" {
            { Get-EnvironmentVariable -Name $nonExistVariable -Target User -ErrorAction Stop } |
            Should -Throw -ErrorId "EnvironmentVariableNotFound,Get-EnvironmentVariable"
        }

        It "Should retrieve all environment variables" {
            $envVars = Get-EnvironmentVariable -Target User
            $envVars | Should -BeOfType ([hashtable])
            $envVars.Count | Should -Be $envVars_user.Count
        }

        It "Should retrieve all environment variables with an asterisk" {
            $envVars = Get-EnvironmentVariable -Name "*" -Target User
            $envVars | Should -BeOfType ([hashtable])
            $envVars.Count | Should -Be $envVars_user.Count
        }

        It "Should retrieve the environment variable" {
            $envVar = Get-EnvironmentVariable -Name $nameTemp -Target User
            $envVar | Should -BeOfType ([hashtable])
            $envVar[$nameTemp] | Should -BeExactly $envVar_userTemp
        }

        It "Should also pass the exam if wildcard serach find nothing" {
            Get-EnvironmentVariable -Name $nonExistVariableWithWildcard -Target User | Should -BeNullOrEmpty
        }
    }
}
