Add-Type -AssemblyName System.Web
Import-Csv -Path C:\AD.csv | foreach {
    $password = [System.Web.Security.Membership]::GeneratePassword((Get-Random -Minimum 20 -Maximum 32), 3)
    $secPw = ConvertTo-SecureString -String $password -AsPlainText -Force

	$userName = '{0}{1}' -f $_.FirstName.Substring(0,1),$_.LastName
	$NewUserParameters = @{
		GivenName = $_.FirstName
		Surname = $_.LastName
		Name = ($_.FirstName + " " + $_.LastName) 
		AccountPassword = $secPw
        Company = $_.Workplace
        SamAccountName = $_.Username
        ChangePasswordAtLogon = $True
        Title = $_.Position
        EmployeeNumber = $_.EmployeeID
        Department = $_.Department
        Mobile = $_.MobileNumber
        OfficePhone = $_.OfficeNumber
        Enabled = $True
        UserPrincipalName = "$Username@domain.com"
        DisplayName = ($_.FirstName + " " + $_.LastName) 
        EmailAddress = "$Username@domain.com"

	}
	New-AdUser @NewUserParameters
	Add-AdGroupMember -Identity 'InternetStandard' -Members $Username

}
