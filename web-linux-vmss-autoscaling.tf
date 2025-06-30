resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "${local.resource_name_prefix}-web-vmss-autoscale"
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  target_resource_id   = azurerm_linux_virtual_machine_scale_set.web_vmss.id
  tags                = local.common_tags

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 5
    }

    # This rule scales out if the average CPU usage exceeds 75%
    # It increases the number of instances by 1 and has a cooldown period of 1
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }
#     Scale action to increase the number of instances
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    # Additional rule for CPU usage
    # This rule scales in if the average CPU usage drops below 25%
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    # Additional rule for memory usage
    # This rule scales out if the available memory drops below 500MB
    rule {
      metric_trigger {
        metric_name        = "Available Memory Bytes"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 524288000 # 500MB in bytes
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
  
# Predictive autoscaling configuration
# This section enables predictive scaling based on historical data
  predictive {
    scale_mode      = "Enabled"
    look_ahead_time = "PT5M"
  }

# Notification settings for autoscale events
  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["adebunmi33@gmail.com"]
    }
  }
}