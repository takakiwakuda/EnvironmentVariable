---
external help file: EnvironmentVariable-help.xml
Module Name: EnvironmentVariable
online version: https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Remove-EnvironmentVariable.md
schema: 2.0.0
---

# Remove-EnvironmentVariable

## SYNOPSIS

Removes an environment variable.

## SYNTAX

```powershell
Remove-EnvironmentVariable [-Name] <String> [-Target <EnvironmentVariableTarget>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Remove-EnvironmentVariable` cmdlet removes an environment variable.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-EnvironmentVariable -Name "Foo"
```

This example removes an environment variable with name `Foo`.

### Example 2

```powershell
PS C:\> Remove-EnvironmentVariable -Name "Foo" -Target User
```

This example removes a user environment variable with name `Foo`.

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

### -Force

Suppresses the user prompt. By default, `Remove-EnvironmentVariable` prompts you for confirmation before removing an environment variable.

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

### -Target

Specifies the location where an environment variable is stored.

```yaml
Type: EnvironmentVariableTarget
Parameter Sets: (All)
Aliases:
Accepted values: Process, User, Machine

Required: False
Position: Named
Default value: Process
Accept pipeline input: False
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

You can pipe a string that contains a name of environment variable to `Remove-EnvironmentVariable`.

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Get-EnvironmentVariable](https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Get-EnvironmentVariable.md)

[Set-EnvironmentVariable](https://github.com/takakiwakuda/EnvironmentVariable/blob/main/docs/Set-EnvironmentVariable.md)
