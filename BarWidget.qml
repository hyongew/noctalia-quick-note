import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services.UI

NIconButton {
  id: root

  property var pluginApi: null
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""

  baseSize: Style.capsuleHeight
  applyUiScale: false
  customRadius: Style.radiusL
  icon: !!pluginApi?.pluginSettings?.note ? "notes" : "rectangle-vertical"
  tooltipText: pluginApi?.tr("tooltip.quick-note")
  tooltipDirection: BarService.getTooltipDirection()
  colorBg: Style.capsuleColor
  colorFg: Color.mOnSurface
  colorBorder: "transparent"
  colorBorderHover: "transparent"
  border.color: Style.capsuleBorderColor
  border.width: Style.capsuleBorderWidth
  
  Component.onCompleted: {
    if (pluginApi) {
      Logger.i("QuickNote", "Bar widget initialized");
      pluginApi.openPanel(screen, root);
    }
  }

  NPopupContextMenu {
    id: contextMenu

    model: [
      {
        "label": pluginApi?.tr("actions.clear-note"),
        "action": "clear-note",
        "icon": "x"
      },
      {
        "label": I18n.tr("actions.widget-settings"),
        "action": "widget-settings",
        "icon": "settings"
      },
    ]

    onTriggered: action => {
      var popupMenuWindow = PanelService.getPopupMenuWindow(screen);
      if (popupMenuWindow) {
        popupMenuWindow.close();
      }

      if (action === "clear-note") {
        if (pluginApi) {
          pluginApi.pluginSettings.note = "";
          pluginApi.saveSettings();
          ToastService.showNotice(pluginApi?.tr("toast.note-cleared"));
        }
      } else if (action === "widget-settings") {
        if (screen && pluginApi?.manifest) {
          Logger.i("QuickNote", "Opening plugin settings");
          BarService.openPluginSettings(screen, pluginApi.manifest);
        }
      }
    }
  }

  onClicked: {
    if (pluginApi) {
      Logger.i("QuickNote", "Opening Quick Note panel");
      pluginApi.openPanel(screen, root);
    }
  }

  onRightClicked: {
    var popupMenuWindow = PanelService.getPopupMenuWindow(screen);
    if (popupMenuWindow) {
      popupMenuWindow.showContextMenu(contextMenu);
      contextMenu.openAtItem(root, screen);
    }
  }
}