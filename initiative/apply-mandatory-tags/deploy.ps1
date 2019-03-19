param (
        [Parameter(Mandatory=$true)]
        [string]$DeploymentParameterFile,
        [Parameter(Mandatory=$true)]
        [string]$PolicySetDefinitionFile,
        [Parameter(Mandatory=$true)]
        [string]$PolicySetParameterFile
)

try
{
        $parameters = Get-Content -Path $DeploymentParameterFile -ErrorAction Stop| ConvertFrom-Json 
}
catch
{
        Write-Host "[ERROR]: Unable to load deployment parameters. Please check input file..." -ForegroundColor Red
        break
}


$definition = @{
        Name = ([guid]::NewGuid() -replace "-", "").Substring(0,24);
        DisplayName = "[$($parameters.Company)]: $($parameters.policyset.Name)";
        Description = $parameters.policyset.Description;
        scope = Get-AzManagementGroup | Where-Object {$_.DisplayName -eq $parameters.policyset.scope};
        PolicySetDefinition = $PolicySetDefinitionFile;
        PolicySetParameters = $PolicySetParameterFile;
}

$assignment = @{
        Name = ([guid]::NewGuid() -replace "-", "").Substring(0,24);
        DisplayName = "[$($parameters.assignment.Type)]: $($parameters.assignment.Name)"
        Scope = (Get-AzManagementGroup | Where-Object {$_.DisplayName -eq $parameters.assignment.Scope}).Id;

}

if((Get-AzPolicyDefinition -Name $definition.Name -ErrorAction SilentlyContinue).count -eq 0)
{
        $policyset = New-AzPolicySetDefinition `
        -Name $definition.Name `
        -DisplayName $definition.DisplayName `
        -Description $definition.Description `
        -PolicyDefinition $definition.PolicySetDefinition `
        -Parameter $definition.PolicySetParameters `
        -ManagementGroupName $definition.scope.Name
}
else
{
        Write-Host "[ERROR]: PolicySet with name already assigned." -ForegroundColor Red
        break
}

if((Get-AzPolicyAssignment -Name $assignment.Name -ErrorAction SilentlyContinue).count -eq 0)
{
        New-AzPolicyAssignment `
        -PolicySetDefinition $policyset `
        -Name $assignment.Name `
        -Scope  $assignment.Scope`
        -DisplayName $assignment.DisplayName `
        -Description $parameters.assignment.Description `
        -CompanyCodeValue $parameters.CompanyCode `
        -CompanyValue $parameters.Company `
        -CustomerIdValue $parameters.CustomerId
}
else
{
        Write-Host "[ERROR]: Assignment with name already assigned." -ForegroundColor Red
        break
}
