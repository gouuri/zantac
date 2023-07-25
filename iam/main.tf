# Create an Azure AD user
variable "displayname" {}
variable "password" {}
variable "emailid" {}

resource "azuread_user" "cutomiam" {
  display_name = var.displayname  # Replace with the display name of the user
  user_principal_name =  var.emailid # Replace with the user's UPN
  password = var.password
}

# Define the custom role with necessary permissions
resource "azurerm_role_definition" "custom_role" {
  name        = "WebServerCustomRestartRole"
  scope       = "/subscriptions/1e961570-e389-493d-8228-b9da2b73c086"  # Replace with your subscription ID
  description = "Custom role to restart web server in VMSS"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachineScaleSets/restart/action",
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/1e961570-e389-493d-8228-b9da2b73c086",  # Replace with your subscription ID
  ]
}

# Assign the custom role to the user
resource "azurerm_role_assignment" "custom_role_assignment" {
  scope                = "/subscriptions/1e961570-e389-493d-8228-b9da2b73c086"  # Replace with your subscription ID
  role_definition_name = azurerm_role_definition.custom_role.name
  principal_id         = azuread_user.cutomiam.object_id
}
