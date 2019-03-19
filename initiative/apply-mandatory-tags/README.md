# Azure Policy Initiative
## Apply mandatory tags

Custom azure policy initiative which assigns mandatory tags to all resources and resource groups. The following mandatory tags can be set.

- Company
- CompanyCode
- CustomerId


``` powershell
Login-AzAccount

./deploy -DeploymentParameterFile "./deploy.parameters.json" -PolicySetDefinitionFile "./azurepolicyset.definitions.json" -PolicySetParameterFile "./azurepolicyset.parameters.json"

```