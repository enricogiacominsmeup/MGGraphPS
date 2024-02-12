<#
    Creare una APP Registration con gli opportuni permessi MS Graph Application permission
    Recuperare i seguentu dati per autenticarsi:

    $SecuredPassword  = ""
    $ApplicationId    = ""
    $tenantID         = ""
#>

$SecuredPasswordPassword = ConvertTo-SecureString -String $SecuredPassword -AsPlainText -Force
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecuredPasswordPassword
Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential


$params = @{
    Message = @{
        Subject = "Test 11:11"
        Body = @{
            ContentType = "Text"
            Content = "Test mail."
        }
        ToRecipients = @(
            @{
                EmailAddress = @{
                    Address = "enrico.giacomin@smeup.com"
                }
            }
        )
    }
    SaveToSentItems = "True"
}

Send-MgUserMail -UserId "e.giacomin@jacknet.biz" -BodyParameter $params
