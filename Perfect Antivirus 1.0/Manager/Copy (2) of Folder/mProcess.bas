Attribute VB_Name = "mProcess"
' 3 Februari 2009
' 12:28 AM
'=======================================
' Module Process Manager
'=======================================
Option Explicit
Private Declare Function GetFileAttributes Lib "kernel32" Alias "GetFileAttributesA" (ByVal lpFileName As String) As Long

'Get icon
Public Declare Function ImageList_Draw Lib "comctl32.dll" (ByVal himl&, ByVal i&, ByVal hdcDest&, ByVal x&, ByVal Y&, ByVal flags&) As Long
Public Declare Function GetShortPathName Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal lBuffer As Long) As Long
Public Declare Sub MoveMemory Lib "kernel32" Alias "RtlMoveMemory" (dest As Any, ByVal Source As Long, ByVal Length As Long)
Public Declare Function lstrcpy Lib "kernel32" Alias "lstrcpyA" (ByVal lpString1 As String, ByVal lpString2 As Long) As Long

Public Declare Function GetLongPathName Lib "kernel32.dll" Alias "GetLongPathNameA" (ByVal lpszShortPath As String, ByVal lpszLongPath As String, ByVal cchBuffer As Long) As Long
Public Declare Function GetShortPathNameA Lib "kernel32" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long) As Long

Private Declare Function Module32First Lib "kernel32" (ByVal hSnapShot As Long, uProcess As MODULEENTRY32) As Long
Private Declare Function Module32Next Lib "kernel32" (ByVal hSnapShot As Long, uProcess As MODULEENTRY32) As Long
Private Declare Function EnumProcessModules Lib "psapi.dll" (ByVal hProcess As Long, lphModule As Long, ByVal cb As Long, lpcbNeeded As Long) As Long
Public Declare Function SetPriorityClass Lib "kernel32" (ByVal hProcess As Long, ByVal dwPriorityClass As Long) As Long
Public Declare Function GetPriorityClass Lib "kernel32" (ByVal hProcess As Long) As Long

Private Type MODULEENTRY32
    dwSize As Long
    th32ModuleID As Long
    th32ProcessID As Long
    GlblcntUsage As Long
    ProccntUsage As Long
    modBaseAddr As Long
    modBaseSize As Long
    hModule As Long
    szModule As String * 256
    szExePath As String * 260
End Type

Public Type VERHEADER
    CompanyName As String
    FileDescription As String
    FileVersion As String
    InternalName As String
    LegalCopyright As String
    OrigionalFileName As String
    ProductName As String
    ProductVersion As String
    Comments As String
    LegalTradeMarks As String
    PrivateBuild As String
    SpecialBuild As String
End Type

Public Const HIGH_PRIORITY_CLASS = &H80
Public Const IDLE_PRIORITY_CLASS = &H40
Public Const NORMAL_PRIORITY_CLASS = &H20
Public Const REALTIME_PRIORITY_CLASS = &H100

Public Declare Function GetFileSize Lib "kernel32" (ByVal hFile As Long, lpFileSizeHigh As Long) As Long
Public Declare Function GetFileVersionInfo Lib "Version.dll" Alias "GetFileVersionInfoA" (ByVal lptstrFilename As String, ByVal dwhandle As Long, ByVal dwLen As Long, lpData As Any) As Long
Public Declare Function GetFileVersionInfoSize Lib "Version.dll" Alias "GetFileVersionInfoSizeA" (ByVal lptstrFilename As String, lpdwHandle As Long) As Long
Public Declare Function VerQueryValue Lib "Version.dll" Alias "VerQueryValueA" (pBlock As Any, ByVal lpSubBlock As String, lplpBuffer As Any, puLen As Long) As Long

Public Const WTS_CURRENT_SERVER_HANDLE = 0&

Public Type WTS_PROCESS_INFO
    SessionID As Long
    ProcessID As Long
    pProcessName As Long
    pUserSid As Long
End Type

Public Declare Function LookupAccountSid Lib "advapi32.dll" Alias "LookupAccountSidA" (ByVal lpSystemName As String, ByVal sID As Long, ByVal name As String, cbName As Long, ByVal ReferencedDomainName As String, cbReferencedDomainName As Long, peUse As Integer) As Long
Public Declare Function WTSEnumerateProcesses Lib "wtsapi32.dll" Alias "WTSEnumerateProcessesA" (ByVal hServer As Long, ByVal Reserved As Long, ByVal Version As Long, ByRef ppProcessInfo As Long, ByRef pCount As Long) As Long
Public Declare Sub WTSFreeMemory Lib "wtsapi32.dll" (ByVal pMemory As Long)
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

Dim myProcess  As Collection

Function GetUserNameA(sID As Long) As String
    If IsWinNT Then
        On Error Resume Next
        Dim retname As String
        Dim retdomain As String
        retname = String(255, 0)
        retdomain = String(255, 0)
        LookupAccountSid vbNullString, sID, retname, 255, retdomain, 255, 0
        GetUserNameA = Left$(retdomain, InStr(retdomain, vbNullChar) - 1) & "\" & Left$(retname, InStr(retname, vbNullChar) - 1)
    End If
End Function

Sub GetWTSProcesses(coll As Collection)
    On Error Resume Next
    Dim Retval As Long
    Dim count As Long
    Dim i As Integer
    Dim lpBuffer As Long
    Dim p As Long
    Dim udtProcessInfo As WTS_PROCESS_INFO
    
    If IsWinNT Then
        Retval = WTSEnumerateProcesses(WTS_CURRENT_SERVER_HANDLE, 0&, 1, lpBuffer, count)
        If Retval Then
           p = lpBuffer
             For i = 1 To count
                 CopyMemory udtProcessInfo, ByVal p, LenB(udtProcessInfo)
                 coll.Add GetUserNameA(udtProcessInfo.pUserSid), "#" & udtProcessInfo.ProcessID
                 p = p + LenB(udtProcessInfo)
             Next i
             WTSFreeMemory lpBuffer   'Free your memory buffer
         End If
    End If
End Sub


Public Function GetModuleProcessID(lvwProc As ListView, ItemProcID As Integer, lvwModule As ListView, ilsModule As ImageList)
    On Error Resume Next
    Dim ExePath As String
    Dim uProcess As MODULEENTRY32
    Dim hSnapShot As Long
    Dim hPID As Long, lRet As Long
    Dim lMod As Long
    Dim intLVW As Integer
    Dim i As Integer
    Dim lvwItem As ListItem
    Dim hVer As VERHEADER
    Dim sModuleName As String, sFile As String

    hPID = lvwProc.SelectedItem.SubItems(ItemProcID)
    sFile = frmProcess.lvwProcess.SelectedItem.SubItems(2)

    hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, hPID)
    uProcess.dwSize = Len(uProcess)
    lMod = Module32First(hSnapShot, uProcess)

    lvwModule.ListItems.Clear
    ilsModule.ListImages.Clear
    i = 0

    Do While lMod
        DoEvents
        i = i + 1
        ExePath = uProcess.szExePath
        GetVerHeader ExePath, hVer
        sModuleName = Left$(uProcess.szExePath, IIf(InStr(1, uProcess.szExePath, Chr$(0)) > 0, InStr(1, uProcess.szExePath, Chr$(0)) - 1, 0))
        ilsModule.ListImages.Add i, , GetIco.Icon(ExePath, SmallIcon)
        Set lvwItem = frmDetail.lvwModDetail.ListItems.Add(, , file_getName(sModuleName), , i)
            lvwItem.SubItems(1) = file_getName(sFile)
            lvwItem.SubItems(2) = file_getType(sModuleName)
            lvwItem.SubItems(3) = hVer.FileDescription
            lvwItem.SubItems(4) = file_getPath(ExePath)
        lMod = Module32Next(hSnapShot, uProcess)
    Loop
    Call CloseHandle(hSnapShot)
    For intLVW = 1 To lvwModule.ColumnHeaders.count
        LV_AutoSizeColumn lvwModule, lvwModule.ColumnHeaders.Item(intLVW)
    Next intLVW
End Function

Public Function GetBasePriority(ReadPID As Long) As String
    Dim hPID As Long
    hPID = OpenProcess(PROCESS_QUERY_INFORMATION, 0, ReadPID)
    Select Case GetPriorityClass(hPID)
        Case 32: GetBasePriority = ToUnicode("Bi2nh thu7o72ng")
        Case 64: GetBasePriority = ToUnicode("Tha61p")
        Case 128: GetBasePriority = "Cao"
        Case 256: GetBasePriority = ToUnicode("Cao nha61t")
        Case Else: GetBasePriority = "N/A"
    End Select
    Call CloseHandle(hPID)
End Function

Function GetAttribute(ByVal sFilePath As String) As String
    Select Case GetFileAttributes(sFilePath)
        Case 1: GetAttribute = "R"
        Case 2: GetAttribute = "H"
        Case 3: GetAttribute = "RH"
        Case 4: GetAttribute = "S"
        Case 5: GetAttribute = "RS"
        Case 6: GetAttribute = "HS"
        Case 7: GetAttribute = "RHS"
        '-------------------------------------------------'
        Case 32: GetAttribute = "A"
        Case 33: GetAttribute = "RA"
        Case 34: GetAttribute = "HA"
        Case 35: GetAttribute = "RHA"
        Case 36: GetAttribute = "SA"
        Case 37: GetAttribute = "RSA"
        Case 38: GetAttribute = "HSA"
        Case 39: GetAttribute = "RHSA"
        '-------------------------------------------------'
        Case 128: GetAttribute = "Normal"
        '-------------------------------------------------'
        Case Else: GetAttribute = "N/A"
    End Select
End Function

Public Function GetVerHeader(ByVal fPN$, ByRef oFP As VERHEADER)
    On Error GoTo ErrHeader
    Dim lngBufferlen&, lngDummy&, lngRc&, lngVerPointer&, lngHexNumber&, i%
    Dim bytBuffer() As Byte, bytBuff(255) As Byte, strBuffer$, strLangCharset$, _
        strVersionInfo(11) As String, strTemp$
    If Dir(fPN$, vbHidden + vbArchive + vbNormal + vbReadOnly + vbSystem) = "" Then
        Exit Function
    End If
    lngBufferlen = GetFileVersionInfoSize(fPN$, 0)
    If lngBufferlen > 0 Then
        ReDim bytBuffer(lngBufferlen)
        lngRc = GetFileVersionInfo(fPN$, 0&, lngBufferlen, bytBuffer(0))
        If lngRc <> 0 Then
            lngRc = VerQueryValue(bytBuffer(0), "\VarFileInfo\Translation", _
                lngVerPointer, lngBufferlen)
            If lngRc <> 0 Then
                MoveMemory bytBuff(0), lngVerPointer, lngBufferlen
                lngHexNumber = bytBuff(2) + bytBuff(3) * &H100 + bytBuff(0) * _
                    &H10000 + bytBuff(1) * &H1000000
                strLangCharset = Hex(lngHexNumber)
                Do While Len(strLangCharset) < 8
                    strLangCharset = "0" & strLangCharset
                Loop
                strVersionInfo(0) = "CompanyName"
                strVersionInfo(1) = "FileDescription"
                strVersionInfo(2) = "FileVersion"
                strVersionInfo(3) = "InternalName"
                strVersionInfo(4) = "LegalCopyright"
                strVersionInfo(5) = "OriginalFileName"
                strVersionInfo(6) = "ProductName"
                strVersionInfo(7) = "ProductVersion"
                strVersionInfo(8) = "Comments"
                strVersionInfo(9) = "LegalTrademarks"
                strVersionInfo(10) = "PrivateBuild"
                strVersionInfo(11) = "SpecialBuild"
                For i = 0 To 11
                    strBuffer = String$(255, 0)
                    strTemp = "\StringFileInfo\" & strLangCharset & "\" & _
                        strVersionInfo(i)
                    lngRc = VerQueryValue(bytBuffer(0), strTemp, lngVerPointer, _
                        lngBufferlen)
                    If lngRc <> 0 Then
                        lstrcpy strBuffer, lngVerPointer
                        strBuffer = Mid$(strBuffer, 1, InStr(strBuffer, Chr(0)) - 1)
                        strVersionInfo(i) = strBuffer
                    Else
                        strVersionInfo(i) = ""
                    End If
                Next i
            End If
        End If
    End If
    For i = 0 To 11
        If Trim(strVersionInfo(i)) = "" Then strVersionInfo(i) = ""
    Next i
    oFP.CompanyName = strVersionInfo(0)
    oFP.FileDescription = strVersionInfo(1)
    oFP.FileVersion = strVersionInfo(2)
    oFP.InternalName = strVersionInfo(3)
    oFP.LegalCopyright = strVersionInfo(4)
    oFP.OrigionalFileName = strVersionInfo(5)
    oFP.ProductName = strVersionInfo(6)
    oFP.ProductVersion = strVersionInfo(7)
    oFP.Comments = strVersionInfo(8)
    oFP.LegalTradeMarks = strVersionInfo(9)
    oFP.PrivateBuild = strVersionInfo(10)
    oFP.SpecialBuild = strVersionInfo(11)
    Exit Function
    
ErrHeader:
End Function

Public Function TerminateProcessID(lvwProc As ListView, ItemProcessID As Integer) As Long
    Dim hPID As Long
    hPID = OpenProcess(PROCESS_ALL_ACCESS, 0, lvwProc.SelectedItem.SubItems(ItemProcessID))
    TerminateProcessID = TerminateProcess(hPID, 0)
    Call CloseHandle(hPID)
End Function

Public Function SetSuspendResumeThread(lvwProc As ListView, ItemProcessID As Integer, SuspendNow As Boolean) As Long
    Dim Thread() As THREADENTRY32, hPID As Long, hThread As Long, i As Long
    
    hPID = lvwProc.SelectedItem.SubItems(ItemProcessID)
    Thread32_Enum Thread(), hPID
    
    For i = 0 To UBound(Thread)
        If Thread(i).th32OwnerProcessID = hPID Then
            hThread = OpenThread(THREAD_SUSPEND_RESUME, _
                False, (Thread(i).th32ThreadID))
            If SuspendNow Then
                SuspendThread hThread
            Else
                ResumeThread hThread
            End If
            CloseHandle hThread
        End If
    Next i
End Function


Function SuspenResumeThread(PID As Long, isResume As Boolean)
        Dim hThread As Long
        Dim lSuspendCount As Long
        Dim TH() As THREADENTRY32
        
        Thread32_Enum TH, PID
        Dim i As Integer
        For i = 0 To UBound(TH)
            If TH(i).th32OwnerProcessID = PID Then
               If isResume Then
                  hThread = OpenThread(THREAD_SUSPEND_RESUME, False, TH(i).th32ThreadID)
                  lSuspendCount = ResumeThread(hThread)
               Else
                  hThread = OpenThread(THREAD_SUSPEND_RESUME, False, TH(i).th32ThreadID)
                  lSuspendCount = SuspendThread(hThread)
               End If
            End If
        Next i
End Function

Public Function GetPriority(PID As Long)
    Dim Hwnd As Long, pri As Long
    Hwnd = OpenProcess(PROCESS_QUERY_INFORMATION, False, PID)
    pri = GetPriorityClass(Hwnd)
    CloseHandle Hwnd
    GetPriority = pri
End Function

Public Function OpenFolderProcess(lvwItemExe As ListView, ItemID As Integer) As Double
    On Error Resume Next
    Dim OpenFolder
    OpenFolder = Shell("explorer.exe /select," & lvwItemExe.SelectedItem.SubItems(ItemID), vbNormalFocus)
End Function



