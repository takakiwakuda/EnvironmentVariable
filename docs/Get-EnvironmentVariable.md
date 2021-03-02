---
external help file: EnvironmentVariable-help.xml
Module Name: EnvironmentVariable
online version: https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Get-EnvironmentVariable.md
schema: 2.0.0
---

# Get-EnvironmentVariable

## SYNOPSIS
Retrieves one or more environment variables.

## SYNTAX

```
Get-EnvironmentVariable [[-Name] <String[]>] [-Target <EnvironmentVariableTarget>] [<CommonParameters>]
```

## DESCRIPTION
The `Get-EnvironmentVariable` cmdlet retrieves one or more environment variables.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-EnvironmentVariable
```

This example retrieves all environment variables.

### Example 2
```powershell
PS C:\> Get-EnvironmentVariable -Name "P*"
```

This example retrieves environment variables whose names start with the character `P`.

### Example 3
```powershell
PS C:\> Get-EnvironmentVariable -Name "Temp" -Target User
```

This example retrieves a user environment variable with name `Temp`.

## PARAMETERS

### -Name
Specifies the name of environment variable.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Variable

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### -Target
Specifies the location where an environment variable is stored.

```yaml
Type: EnvironmentVariableTarget
Parameter Sets: (All)
Aliases:
Accepted values: Process, User, Machine

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
You can pipe a string that contains a name of environment variable to `Get-EnvironmentVariable`.

## OUTPUTS

### System.Collections.Hashtable
`Get-EnvironmentVariable` returns the hashtable objects that contains one or more environment variables names and their values.

## NOTES

## RELATED LINKS

[Remove-EnvironmentVariable](https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Remove-EnvironmentVariable.md)

[Set-EnvironmentVariable](https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Set-EnvironmentVariable.md)
