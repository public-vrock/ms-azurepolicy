$parameters = Get-Content -Path "./deploy.parameters.json" | ConvertFrom-Json

$definition = @{
        Name = ([guid]::NewGuid() -replace "-", "").Substring(0,24);
        DisplayName = "[$($parameters.Company)]: $($parameters.policyset.Name)";
        Description = $parameters.policyset.Description;
        scope = Get-AzManagementGroup | Where-Object {$_.DisplayName -eq $parameters.policyset.scope};
        PolicySetDefinition = "./azurepolicyset.definitions.json";
        PolicySetParameters = "./azurepolicyset.parameters.json";
}

$assignment = @{
        Name = ([guid]::NewGuid() -replace "-", "").Substring(0,24);
        DisplayName = "[$($parameters.assignment.Type)]: $($parameters.assignment.Name)"
        Scope = (Get-AzManagementGroup | Where-Object {$_.DisplayName -eq $parameters.assignment.Scope}).Id;

}

$policyset = New-AzPolicySetDefinition `
        -Name $definition.Name `
        -DisplayName $definition.DisplayName `
        -Description $definition.Description `
        -PolicyDefinition $definition.PolicySetDefinition `
        -Parameter $definition.PolicySetParameters `
        -ManagementGroupName $definition.scope.Name
 
New-AzPolicyAssignment `
        -PolicySetDefinition $policyset `
        -Name $assignment.Name `
        -Scope  $assignment.Scope`
        -DisplayName $assignment.DisplayName `
        -Description $parameters.assignment.Description `
        -CompanyCodeValue $parameters.CompanyCode `
        -CompanyValue $parameters.Company `
        -CustomerIdValue $parameters.CustomerId