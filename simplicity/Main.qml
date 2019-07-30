import QtQuick 2.0
import SddmComponents 2.0
import "SimpleControls" as Simple

Rectangle {
    
    width: 640
    height: 480
    
    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }
    
    Connections {
        target: sddm
        onLoginSucceeded: {}
        onLoginFailed: {
            pw_entry.text = ""
            pw_entry.focus = true
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }
    
    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Simple.SimpleUserComboBox {
            id: user_entry
            width: 250
            color: Qt.rgba(0, 0, 0, 0.2)
            dropDownColor: Qt.rgba(0, 0, 0, 0.2)
            borderColor: "transparent"
            textColor: "white"
            arrowIcon: "images/arrow-down.png"
            arrowColor: "transparent"
            model: userModel
            index: userModel.lastIndex
            font.pointSize: 14
            KeyNavigation.backtab: session
            KeyNavigation.tab: pw_entry
        }

        PasswordBox {
            id: pw_entry
            width: 250
            color: Qt.rgba(0, 0, 0, 0.2)
            borderColor: "transparent"
            focusColor: Qt.rgba(0, 0, 0, 0.3)
            hoverColor: Qt.rgba(0, 0, 0, 0.3)
            textColor: "white"
            font.pointSize: 14
            focus: true
            KeyNavigation.backtab: user_entry
            KeyNavigation.tab: loginButton

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    sddm.login(user_entry.currentText, pw_entry.text, session.index)
                    event.accepted = true
                }
            }
        }

        Button {
            id: loginButton
            text: textConstants.login
            width: 250
            color: Qt.rgba(0, 0, 0, 0.2)
            activeColor: Qt.rgba(0, 0, 0, 0.3)
            pressedColor: Qt.rgba(0, 0, 0, 0.3)
            font.pointSize: 14
            font.bold: false
            onClicked: sddm.login(user_entry.currentText, pw_entry.text, session.index)
            KeyNavigation.backtab: pw_entry
            KeyNavigation.tab: restart
        }

        Text {
            id: errorMessage
            text: ""
            font.pointSize: 15
            font.bold: true
            font.capitalization: Font.AllUppercase
        }
    }
      
    Rectangle {
        width: parent.width - 10
        height: 40
        color: "transparent"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        
        Button {
            id: restart
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: shutdown.left
            anchors.rightMargin: 10
            text: textConstants.reboot
            color: Qt.rgba(0, 0, 0, 0.2)
            pressedColor: Qt.rgba(0, 0, 0, 0.25)
            activeColor: Qt.rgba(0, 0, 0, 0.2)
            font.pixelSize: 15
            font.bold: false
            onClicked: sddm.reboot()
            KeyNavigation.backtab: loginButton; KeyNavigation.tab: shutdown
        }
        
        Button {
            id: shutdown
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            text: textConstants.shutdown
            color: Qt.rgba(0, 0, 0, 0.2)
            pressedColor: Qt.rgba(0, 0, 0, 0.25)
            activeColor: Qt.rgba(0, 0, 0, 0.2)
            font.pixelSize: 15
            font.bold: false
            onClicked: sddm.powerOff()
            KeyNavigation.backtab: restart; KeyNavigation.tab: session
        }
        
    }

    Simple.SimpleComboBox {
        id: session
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        width: 200
        color: Qt.rgba(0, 0, 0, 0.2)
        dropDownColor: Qt.rgba(0, 0, 0, 0.2)
        borderColor: "transparent"
        textColor: "White"
        font.pointSize: 14
        arrowIcon: "images/arrow-down.png"
        arrowColor: "transparent"
        model: sessionModel
        index: sessionModel.lastIndex
        KeyNavigation.backtab: shutdown
        KeyNavigation.tab: user_entry
    }
    
    Rectangle {
        id: dateClock
        width: parent.width - 10
        height: 40
        color: "transparent"
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter        
     
        Timer {
            id: timetr
            interval: 100
            running: true
            repeat: true
            onTriggered: {
                timelb.text = Qt.formatDateTime(new Date(), "HH:mm");
            }  
        }
        
        Rectangle {
            color: Qt.rgba(0, 0, 0, 0.2)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: session.height
            
            Text {
                id: timelb
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: Qt.formatDateTime(new Date(), "HH:mm")
                color: "white"
                font.pixelSize: 18
            }
        }
        
        
    }
    
    Component.onCompleted: {
        /*if (user_entry.text === "")
            user_entry.focus = true
        else
            pw_entry.focus = true*/
        pw_entry.focus = true
    }
}
