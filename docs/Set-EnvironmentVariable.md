---
external help file: EnvironmentVariable-help.xml
Module Name: EnvironmentVariable
online version: https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Set-EnvironmentVariable.md
schema: 2.0.0
---

# Set-EnvironmentVariable

## SYNOPSIS
Creates and modifies an environment variable.

## SYNTAX

```
Set-EnvironmentVariable [-Name] <String> [-Value] <String> [-Target <EnvironmentVariableTarget>] [-PassThru]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The `Set-EnvironmentVariable` cmdlet creates and modifies an environment variable.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-EnvironmentVariable -Name "Foo" -Value "Bar"
```

This example creates or modifies an environment variable with name `Foo`.

### Example 2
```powershell
PS C:\> Set-EnvironmentVariable -Name "Foo" -Value "Bar" -Target User
```

This example creates or modifies a user environment variable with name `Foo`.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of environment variable.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Variable

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -PassThru
Returns a hashtable object that contains an environment variable name and it value. By default, `Set-EnvironmentVariable` cmdlet returns nothing.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
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

### -Value
Specifies the value of environment variable.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
You can pipe a string that contains a name of environment variable to `Set-EnvironmentVariable`.

## OUTPUTS

### System.Collections.Hashtable
`Set-EnvironmentVariable` returns the hashtable object that contains an environment variable name and it value.

## NOTES

## RELATED LINKS

[Get-EnvironmentVariable](https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Get-EnvironmentVariable.md)
[Remove-EnvironmentVariable](https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Remove-EnvironmentVariable.md)
