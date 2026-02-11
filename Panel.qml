import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Commons
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  readonly property var geometryPlaceholder: panelContainer

  property real contentPreferredWidth: (pluginApi?.pluginSettings?.panelWidth ?? pluginApi?.manifest?.metadata?.defaultSettings?.panelWidth) * Style.uiScaleRatio
  property real contentPreferredHeight: (pluginApi?.pluginSettings?.panelHeight ?? pluginApi?.manifest?.metadata?.defaultSettings?.panelHeight) * Style.uiScaleRatio
  readonly property bool allowAttach: Settings.data.ui.panelsAttachedToBar

  readonly property bool valuePanelMargin: pluginApi?.pluginSettings?.panelMargin ?? pluginApi?.manifest?.metadata?.defaultSettings?.panelMargin
  readonly property bool valueUseSystemFont: pluginApi?.pluginSettings?.useSystemFont ?? pluginApi?.manifest?.metadata?.defaultSettings?.useSystemFont
  readonly property string valueFontSize: pluginApi?.pluginSettings?.fontSize ?? pluginApi?.manifest?.metadata?.defaultSettings?.fontSize
  property string note: pluginApi?.pluginSettings?.note ?? pluginApi?.manifest?.metadata?.defaultSettings?.note ?? ""

  anchors.fill: parent

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors {
        fill: parent
        margins: root.valuePanelMargin ? Style.marginL : null
      }

      // Content area
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        ScrollView {
          anchors {
            fill: parent
            margins: Style.marginS
          }
                
          TextArea {
            id: textInput
            width: parent.width
            text: root.note
            wrapMode: TextEdit.Wrap
            color: Color.mOnSurface
            font.pointSize: Style[`fontSize${root.valueFontSize}`]
            font.family: root.valueUseSystemFont ? Settings.data.ui.fontDefault : undefined
            tabStopDistance: 16
            background: null
            onEditingFinished: {
              pluginApi.pluginSettings.note = textInput.text
              pluginApi.saveSettings()
            }
          }
        }
      }
    }
  }
}