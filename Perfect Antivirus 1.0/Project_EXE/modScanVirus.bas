Attribute VB_Name = "modScanVirus"
Dim db As Database
Dim rs As Recordset
Dim WS As Workspace
Dim Max As Long
Dim mData As Recordset
Public xTotalProcess

Public Declare Function DeleteFile Lib "kernel32" Alias "DeleteFileA" (ByVal lpFileName As String) As Long

Public Function CheckVirus(sFile) As String
DoEvents
Dim MD5Cod
Dim InputData As String
Dim sData As String
Dim Str1 As String
Dim Str2 As String


'Check Virus by MD5 code
MD5Cod = HashFile(sFile, MD5)
If MD5Cod <> "D41D8CD98F00B204E9800998ECF8427E" Then
    Set mData = db.OpenRecordset("SELECT * FROM " & "Data" & " WHERE " & "MD5Code" & "='" & MD5Cod & "'")
    If mData.RecordCount > 0 Then
       CheckVirus = mData.Fields("VirusName")
       Exit Function
    Else
        CheckVirus = "No"
    End If
Else
    CheckVirus = "No"
End If


'Check Virus By String
Open sFile For Binary As #1
    sData = Space(LOF(1))
    Get #1, , sData
Close #1

Open AppPath & "Data.str" For Input As #1
Do While Not EOF(1)
Line Input #1, InputData
Str1 = Split(InputData, "|", , vbBinaryCompare)(0)
If InStr(1, sData, Str1) <> 0 Then
    Str2 = Split(InputData, "|", , vbBinaryCompare)(1)
    'MsgBox Text1.Text & " Da bi nhiem virus: " & Str2
    CheckVirus = Str2
Else
    CheckVirus = "No"
End If
Loop
Close #1

End Function

Public Sub ConnectDB()
Set WS = DBEngine.Workspaces(0)
    DbFile = (AppPath & "Data.PAV")
    PwdString = "htgtalcmdltnsc"
    Set db = DBEngine.OpenDatabase(DbFile, False, False, ";PWD=" & PwdString)
End Sub
Public Function GetFileName(ByVal sPath As String) As String
GetFileName = Mid(sPath, InStrRev(sPath, "\") + 1)
End Function

Public Function GetFolderPath(ByVal sPath As String) As String
GetFolderPath = Left(sPath, InStrRev(sPath, "\") - 1)
End Function

Public Function GetFolderCha(ByVal sPath As String) As String
On Error Resume Next
GetFolderCha = Mid(sPath, (InStrRev(sPath, "\", InStrRev(sPath, "\") - 1)) + 1, ((InStrRev(sPath, "\") - 1) - InStrRev(sPath, "\", InStrRev(sPath, "\") - 1)))
End Function

Public Function GetFileCount(strFolder As String) As Integer
On Error Resume Next
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
GetFileCount = fso.GetFolder(strFolder).Files.Count
End Function

Public Function AppPath() As String
Dim x As String
x = App.Path
If Right(x, 1) <> "\" Then x = x & "\"
AppPath = x
End Function

Public Function FileExists(sFile As String) As Boolean
On Error Resume Next
FileExists = ((GetAttr(sFile) And vbDirectory) = 0)
End Function


Public Sub DelAllLV(LV As UniListView)
Dim k
For k = 1 To LV.ListItems.Count
If k > LV.ListItems.Count Then Exit Sub
If LV.ListItems(k).Checked = True Then
LV.ListItems.Remove k
k = k - 1
End If
Next k
End Sub


Public Sub DelAllChecked(LV As UniListView)
Dim k
For k = 1 To LV.ListItems.Count
If k > LV.ListItems.Count Then Exit Sub
If LV.ListItems(k).Checked = True Then
LV.ListItems.Remove k
k = k - 1
End If
Next k
End Sub
