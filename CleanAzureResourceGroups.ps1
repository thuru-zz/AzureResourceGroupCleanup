<# script will run on the current selected subscription of the session #>

$currentSub = Get-AzureSubscription -Current
Write-Host Script will run on $currentSub.SubscriptionName ($currentSub.SubscriptionId)
$isOk = Read-Host 'Do you want to continue [Y/N] ?'

if ($isOk.ToUpper().Equals("Y"))
{

    Switch-AzureMode -Name AzureResourceManager

    $resourceGroups = Get-AzureResourceGroup
    $fullAuto = Read-Host 'Do you want to delete all the resource groups which do not have any resources. If you select No you can choose one by one and delete them [Y/N] ?'

    $found = 0;
    $deleted = 0;

    foreach($resourceGroup in $resourceGroups)
    {
        $rgName = $resourceGroup.ResourceGroupName
        
        $resources = Get-AzureResource -ResourceGroupName $rgName
   
        if ($resources.Count -eq 0)
        {
            $found++
            Write-Host Resource Group " $rgName " does not contain any resources.

            if($fullAuto.ToUpper().Equals("N"))
            {
                $input = Read-Host 'Do you want to delete it [Y/N] ?'
                if ($input.ToUpper().Equals("Y"))
                {
                    Write-Host Deleting Resource Group - $rgName
                    Remove-AzureResourceGroup -Name $resourceGroup.ResourceGroupName -Force -Verbose
                    Write-Host Deleted Resource Group - $rgName
                    $deleted++
                }
            }
            else
            {
                Write-Host Deleting Resource Group - $rgName
                Remove-AzureResourceGroup -Name $resourceGroup.ResourceGroupName -Force -Verbose
                Write-Host Deleted Resource Group - $rgName
                $deleted++
            }
        }
    }

    Write-Host $deleted / $found Resource Groups deleted with no resources

    Switch-AzureMode -Name AzureServiceManagement
}
else
{
    exit
}
