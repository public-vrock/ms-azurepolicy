$policyprefix = "[PREFIX]: "
$managementgroup = Get-AzManagementGroup -GroupName "MgmtGroupName"
$policysetguid = [guid]::NewGuid()
$policysetname = ($policyprefix + "Apply mandatory tags on all resources and resource groups")
$policysetdescription = "This initiative will set policies which apply mandatory tags on all resources and resource groups"
$policydefinitions = "./apply_mandatory_tags/azurepolicyset.definitions.json"
$policysetparameters = "./apply_mandatory_tags/azurepolicyset.parameters.json"

$policyset = New-AzPolicySetDefinition `
        -Name "PolicySetName" `
        -DisplayName $policysetname `
        -Description $policysetdescription `
        -PolicyDefinition $policydefinitions `
        -Parameter $policysetparameters `
        -ManagementGroupName $managementgroup.Name
 
New-AzPolicyAssignment `
        -PolicySetDefinition $policyset `
        -Name "AssignmentName" `
        -Scope $managementgroup.Id `
        -DisplayName $policysetname `
        -Description $policysetname `
        -CompanyCodeValue "corp" `
        -CompanyValue "Corporation" `
        -CustomerIdValue "0000000000"