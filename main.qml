// CoordinateDialogPlugin.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.qfield
import org.qgis
import Theme

Item {
    id: pluginRoot

    // Botón flotante en la interfaz
    QfToolButton {
        id: coordinateButton
        iconSource: 'chat_contact.svg'
        iconColor: Theme.mainColor
        bgcolor: Theme.darkGray
        round: true

        onClicked: {
            // Obtener coordenadas del centro del mapa
            var mapPoint = iface.mapCanvas().mapSettings.viewportCenter
            // Transformar al CRS deseado
            var transformedPoint = iface.mapCanvas().mapSettings.coordinateTransform(mapPoint, "EPSG:4326")

            // Mostrar diálogo
            coordinateDialog.xCoord = transformedPoint.x.toFixed(6)
            coordinateDialog.yCoord = transformedPoint.y.toFixed(6)
            coordinateDialog.open()
        }
    }

    // Diálogo personalizado
    Dialog {
        id: coordinateDialog
        parent: iface.mainWindow().contentItem
        width: 300
        height: 200
        modal: true
        title: "Coordenadas Actuales"

        property real xCoord: 0.0
        property real yCoord: 0.0

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Label {
                text: "Sistema de Referencia:"
                font.bold: true
            }

            Label {
                text: "EPSG:4326 (WGS 84)"
                Layout.fillWidth: true
            }

            GridLayout {
                columns: 2
                Layout.fillWidth: true

                Label { text: "Longitud (X):" }
                Label { text: coordinateDialog.xCoord }

                Label { text: "Latitud (Y):" }
                Label { text: coordinateDialog.yCoord }
            }

            Button {
                text: "Cerrar"
                Layout.alignment: Qt.AlignHCenter
                onClicked: coordinateDialog.close()
            }
        }
    }

    // Conexión con la API de QField
    Connections {
        target: iface.mainWindow()

        // Opcional: Actualizar coordenadas al mover el mapa
        onMapPositionChanged: {
            var transformedPoint = iface.mapCanvas().mapSettings.coordinateTransform(position, "EPSG:4326")
            coordinateDialog.xCoord = transformedPoint.x.toFixed(6)
            coordinateDialog.yCoord = transformedPoint.y.toFixed(6)
        }
    }
}

