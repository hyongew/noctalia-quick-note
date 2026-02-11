import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  // Local state - track changes before saving
  property string valueWidgetPosition: pluginApi?.pluginSettings?.widgetPosition ?? pluginApi?.manifest?.metadata?.defaultSettings?.widgetPosition
  property int valuePanelWidth: pluginApi?.pluginSettings?.panelWidth ?? pluginApi?.manifest?.metadata?.defaultSettings?.panelWidth
  property int valuePanelHeight: pluginApi?.pluginSettings?.panelHeight ?? pluginApi?.manifest?.metadata?.defaultSettings?.panelHeight
  property bool valuePanelMargin: pluginApi?.pluginSettings?.panelMargin ?? pluginApi?.manifest?.metadata?.defaultSettings?.panelMargin
  property bool valueUseSystemFont: pluginApi?.pluginSettings?.useSystemFont ?? pluginApi?.manifest?.metadata?.defaultSettings?.useSystemFont
  property string valueFontSize: pluginApi?.pluginSettings?.fontSize ?? pluginApi?.manifest?.metadata?.defaultSettings?.fontSize

  spacing: Style.marginM

  Component.onCompleted: {
    if (pluginApi) {
      Logger.i("QuickNote", "Settings initialized");
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS

    NComboBox { // Currently unable to detect automatically. Update when possible
      label: pluginApi?.tr("settings.widget-position")
      description: pluginApi?.tr("settings.widget-position-description")

      model: [
        {
          "name": I18n.tr("positions.left"),
          "key": "left"
        },
        {
          "name": I18n.tr("positions.center"),
          "key": "center"
        },
        {
          "name": I18n.tr("positions.right"),
          "key": "right"
        }
      ]

      currentKey: root.valueWidgetPosition

      onSelected: key => {
                    root.valueWidgetPosition = key;
                  }
    }

    RowLayout {
      Layout.fillWidth: true

      NLabel {
        label: pluginApi?.tr("settings.panel-dimensions")
      }

      NIconButton {
        baseSize: Style.baseWidgetSize * 0.7
        icon: "reload"
        tooltipText: pluginApi?.tr("settings.reset")
        onClicked: {
          root.valuePanelWidth = pluginApi?.manifest?.metadata?.defaultSettings?.panelWidth
          root.valuePanelHeight = pluginApi?.manifest?.metadata?.defaultSettings?.panelHeight
          widthInput.text = pluginApi?.manifest?.metadata?.defaultSettings?.panelWidth
          heightInput.text = pluginApi?.manifest?.metadata?.defaultSettings?.panelHeight
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      
      NTextInput {
        id: widthInput
        description: pluginApi?.tr("settings.width")
        text: root.valuePanelWidth
        onEditingFinished: {
          widthInput.text = !isNaN(parseFloat(widthInput.text))&&parseInt(widthInput.text)>=50 ?
          parseInt(widthInput.text) : root.valuePanelWidth
        }
      }

      NTextInput {
        id: heightInput
        description: pluginApi?.tr("settings.height")
        text: root.valuePanelHeight
        onEditingFinished: {
          heightInput.text = !isNaN(parseFloat(heightInput.text))&&parseInt(heightInput.text)>=50 ?
          parseInt(heightInput.text).toString() : root.valuePanelHeight.toString()
        }
      }
    }
  }

  NToggle {
    label: pluginApi?.tr("settings.panel-margin")
    description: pluginApi?.tr("settings.panel-margin-description")
    checked: root.valuePanelMargin
    onToggled: checked => root.valuePanelMargin = checked
  }

  NToggle {
    label: pluginApi?.tr("settings.use-system-font")
    description: pluginApi?.tr("settings.use-system-font-description")
    checked: root.valueUseSystemFont
    onToggled: checked => root.valueUseSystemFont = checked
  }

  NComboBox {
    label: pluginApi?.tr("settings.font-size")
    description: pluginApi?.tr("settings.font-size-description")

    model: [
      {
        "name": "XXS",
        "key": "XXS"
      },
      {
        "name": "XS",
        "key": "XS"
      },
      {
        "name": "S",
        "key": "S"
      },
      {
        "name": "M",
        "key": "M"
      },
      {
        "name": "L",
        "key": "L"
      },
      {
        "name": "XL",
        "key": "XL"
      },
      {
        "name": "XXL",
        "key": "XXL"
      }
    ]

    currentKey: root.valueFontSize

    onSelected: key => {
                  root.valueFontSize = key;
                }
  }

  // This function is called by the dialog to save settings
  function saveSettings() {
    if (!pluginApi) {
      Logger.e("QuickNote", "Cannot save settings: pluginApi is null");
      return;
    }

    // Update the plugin settings object
    pluginApi.pluginSettings.widgetPosition = root.valueWidgetPosition
    pluginApi.pluginSettings.panelWidth = parseInt(widthInput.text);
    pluginApi.pluginSettings.panelHeight = parseInt(heightInput.text);
    pluginApi.pluginSettings.panelMargin = root.valuePanelMargin;
    pluginApi.pluginSettings.useSystemFont = root.valueUseSystemFont;
    pluginApi.pluginSettings.fontSize = root.valueFontSize;

    // Save to disk
    pluginApi.saveSettings();

    Logger.i("QuickNote", "Settings saved successfully");
  }
}