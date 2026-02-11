import QtQuick
import Quickshell.Io
import qs.Services.UI

Item {
  property var pluginApi: null
  width: Screen.width
  height: Screen.height

  readonly property string barPosition: Settings.data.bar.position
  readonly property string widgetPosition: pluginApi?.pluginSettings?.widgetPosition ?? pluginApi?.manifest?.metadata?.defaultSettings?.widgetPosition

  readonly property var horizontalAnchor: (barPosition=="left"||barPosition=="right") ? barPosition : widgetPosition
  readonly property var verticalAnchor: (barPosition=="left"||barPosition=="right") ? widgetPosition : barPosition

  Component.onCompleted: {
    if (pluginApi) {
      Logger.i("QuickNote", "Plugin initialized");
    }
  }

  Item {
    id: anchor
    anchors {
      horizontalCenter: parent[horizontalAnchor=="center" ? "horizontalCenter" : horizontalAnchor]
      verticalCenter: parent[verticalAnchor=="center" ? "verticalCenter" : verticalAnchor]
    }
  }

  IpcHandler {
    target: "plugin:quick-note"
    function clearNote() {
      if (pluginApi) {
        pluginApi.pluginSettings.note = pluginApi?.manifest?.metadata?.defaultSettings?.note ?? ""
        pluginApi.saveSettings();
        ToastService.showNotice(pluginApi?.tr("toast.note-cleared"));
      }
    }
    
    function toggle() {
      if (pluginApi) {
        pluginApi.withCurrentScreen(screen => {
          pluginApi.openPanel(screen, anchor);
        });
      }
    }
  }
}