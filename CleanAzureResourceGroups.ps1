$currentSub = Get-AzureSubscription -Current
Write-Host Script will run on the subscription Name : $currentSub.SubscriptionName Id : ($currentSub.SubscriptionId)

$resourceGroups = Get-AzureRmResourceGroup

foreach($rg in $resourceGroups)
{
    Remove-AzureRmResourceGroup -Name $rg.ResourceGroupName -Force -Verbose
}
