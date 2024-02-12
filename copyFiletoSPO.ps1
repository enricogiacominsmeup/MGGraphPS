Param (  
    $Tenant = "M365B878827",  
    $AppID = "0aaacc9a-3010-46c5-80f7-d43cfb8d15a5",  
    $SiteID = "15b5f26c-fd79-49ba-9440-df14919c3ffd",  
    $LibraryURL = "https://M365B878827.sharepoint.com/sites/Marketing/Shared%20Documents",  
    $Path = ""C:\Users\e.giacomin-n365.NANOSOFT365\OneDrive - Smeup ICS\Shared\Active Directory - Raccomandazioni sulla sicurezza.pdf""  
)  
  
$AppCredential = Get-Credential($AppID)  
  
#region authorize  
$Scope = "https://graph.microsoft.com/.default"  
  
$Body = @{  
    client_id = $AppCredential.UserName  
    client_secret = $AppCredential.GetNetworkCredential().password  
    scope = $Scope  
    grant_type = 'client_credentials'  
}  
  
$GraphUrl = "https://login.microsoftonline.com/$($Tenant).onmicrosoft.com/oauth2/v2.0/token"  
$AuthorizationRequest = Invoke-RestMethod -Uri $GraphUrl -Method "Post" -Body $Body  
$Access_token = $AuthorizationRequest.Access_token  
  
$Header = @{  
    Authorization = $AuthorizationRequest.access_token  
    "Content-Type"= "application/json"  
}  
#endregion  
  
#region get drives  
  
  
$GraphUrl = "https://graph.microsoft.com/v1.0/sites/$SiteID/drives"  
  
$BodyJSON = $Body | ConvertTo-Json -Compress  
$Result = Invoke-RestMethod -Uri $GraphUrl -Method 'GET' -Headers $Header -ContentType "application/json"   
$DriveID = $Result.value| Where-Object {$_.webURL -eq $LibraryURL } | Select-Object id -ExpandProperty id  
  
If ($DriveID -eq $null){  
  
    Throw "SharePoint Library under $LibraryURL could not be found."  
}  
  
#endregion  
  
#region upload file  
  
$FileName = $Path.Split("\")[-1]  
$Url  = "https://graph.microsoft.com/v1.0/drives/$DriveID/items/root:/$($FileName):/content"  
  
Invoke-RestMethod -Uri $Url -Headers $Header -Method Put -InFile $Path -ContentType 'multipart/form-data' -Verbose  
#endregion   