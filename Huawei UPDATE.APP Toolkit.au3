#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resource\Icon.ico
#AutoIt3Wrapper_Outfile=Huawei UPDATE.APP Toolkit.exe
#AutoIt3Wrapper_Res_Description=Huawei UPDATE.APP Toolkit
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2015 Kyaw Swar Thwin
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <File.au3>
#include "Include\Busy.au3"
#include "Include\UPDATEAPP.au3"

Global Const $sAppName = "Huawei UPDATE.APP Toolkit"
Global Const $sAppVersion = "1.0"
Global Const $sAppPublisher = "Kyaw Swar Thwin"

Global Const $sTitle = $sAppName

FileChangeDir(@MyDocumentsDir)

$frmMain = GUICreate($sTitle, 400, 330, -1, -1)
$tabOptions = GUICtrlCreateTab(10, 10, 380, 280)
$tabOptionsUPDATEAPP = GUICtrlCreateTabItem("UPDATE.APP")
$fraUnpackUPDATEAPP = GUICtrlCreateGroup("Unpack UPDATE.APP", 24, 45, 350, 110)
$lblFilePath = GUICtrlCreateLabel("UPDATE.APP File:", 34, 65, 94, 17)
$txtFilePath = GUICtrlCreateInput("", 34, 83, 245, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$cmdBrowse = GUICtrlCreateButton("Browse...", 289, 80, 75, 25)
$cmdUnpack = GUICtrlCreateButton("Unpack", 289, 115, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$fraRepackUPDATEAPP = GUICtrlCreateGroup("Repack UPDATE.APP", 24, 165, 350, 110)
$lblFilePath2 = GUICtrlCreateLabel("Sequence File:", 34, 185, 76, 17)
$txtFilePath2 = GUICtrlCreateInput("", 34, 203, 245, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$cmdBrowse2 = GUICtrlCreateButton("Browse...", 289, 200, 75, 25)
$cmdRepack = GUICtrlCreateButton("Repack", 289, 235, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$lblVersion = GUICtrlCreateLabel("Version: " & $sAppVersion, 10, 303, 60, 17)
$lblDeveloper = GUICtrlCreateLabel("Developed By: " & $sAppPublisher, 228, 303, 162, 17)
GUISetState()

While 1
	$iMsg = GUIGetMsg()
	Switch $iMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cmdBrowse
			$sFilePath = FileOpenDialog("Open", @WorkingDir, "Huawei Firmware Files (*.app)|All Files (*.*)", $FD_FILEMUSTEXIST, "UPDATE.APP", $frmMain)
			If @error Then
				GUICtrlSetData($txtFilePath, "")
				GUICtrlSetState($cmdUnpack, $GUI_DISABLE)
			Else
				GUICtrlSetData($txtFilePath, $sFilePath)
				GUICtrlSetState($cmdUnpack, $GUI_ENABLE)
			EndIf
		Case $cmdUnpack
			_Busy_Create("Unpacking...", -1, -1, $frmMain)
			DirRemove(@WorkingDir & "\UPDATE", 1)
			DirCreate(@WorkingDir & "\UPDATE")
			_UPDATEAPP_Unpack($sFilePath, @WorkingDir & "\UPDATE")
			_Busy_Close()
		Case $cmdBrowse2
			$sFilePath = FileOpenDialog("Open", @WorkingDir & "\UPDATE", "Sequence Files (*.ini)|All Files (*.*)", $FD_FILEMUSTEXIST, "Sequence.ini", $frmMain)
			If @error Then
				GUICtrlSetData($txtFilePath2, "")
				GUICtrlSetState($cmdRepack, $GUI_DISABLE)
			Else
				GUICtrlSetData($txtFilePath2, $sFilePath)
				GUICtrlSetState($cmdRepack, $GUI_ENABLE)
			EndIf
		Case $cmdRepack
			_Busy_Create("Repacking...", -1, -1, $frmMain)
			FileDelete(StringLeft(@WorkingDir, StringInStr(@WorkingDir, "\", Default, -1) - 1) & "\UPDATE.APP.NEW")
			_UPDATEAPP_Repack($sFilePath, StringLeft(@WorkingDir, StringInStr(@WorkingDir, "\", Default, -1) - 1) & "\UPDATE.APP.NEW")
			_Busy_Close()
	EndSwitch
WEnd
