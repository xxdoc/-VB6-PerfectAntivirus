Attribute VB_Name = "modRegistry"
Option Explicit

Public Enum RegistryKeys

    HKEY_CLASSES_ROOT = &H80000000
    HKEY_CURRENT_USER = &H80000001
    HKEY_LOCAL_MACHINE = &H80000002
    HKEY_USERS = &H80000003
    HKEY_CURRENT_CONFIG = &H80000005
    HKEY_DYN_DATA = &H80000006

End Enum

Public Const HKEY_PERFORMANCE_DATA = &H80000004

Public Const ERROR_SUCCESS = 0&

Public Const REG_SZ = 1

Public Const REG_DWORD = 4

Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Declare Function RegCreateKey _
        Lib "advapi32.dll" _
        Alias "RegCreateKeyA" (ByVal hKey As Long, _
                               ByVal lpSubKey As String, _
                               phkResult As Long) As Long
Declare Function RegDeleteKey _
        Lib "advapi32.dll" _
        Alias "RegDeleteKeyA" (ByVal hKey As Long, _
                               ByVal lpSubKey As String) As Long
Declare Function RegDeleteValue _
        Lib "advapi32.dll" _
        Alias "RegDeleteValueA" (ByVal hKey As Long, _
                                 ByVal lpValueName As String) As Long
Declare Function RegOpenKey _
        Lib "advapi32.dll" _
        Alias "RegOpenKeyA" (ByVal hKey As Long, _
                             ByVal lpSubKey As String, _
                             phkResult As Long) As Long
Declare Function RegQueryValueEx _
        Lib "advapi32.dll" _
        Alias "RegQueryValueExA" (ByVal hKey As Long, _
                                  ByVal lpValueName As String, _
                                  ByVal lpReserved As Long, _
                                  lpType As Long, _
                                  lpData As Any, _
                                  lpcbData As Long) As Long
Declare Function RegSetValueEx _
        Lib "advapi32.dll" _
        Alias "RegSetValueExA" (ByVal hKey As Long, _
                                ByVal lpValueName As String, _
                                ByVal Reserved As Long, _
                                ByVal dwType As Long, _
                                lpData As Any, _
                                ByVal cbData As Long) As Long

Public Sub SaveKey(ByVal hKey As RegistryKeys, ByVal strPath As String)

    On Error Resume Next
  
    Dim KeyHand As Long
  
    RegCreateKey hKey, strPath, KeyHand
    RegCloseKey KeyHand
  

End Sub

Public Function DeleteKey(ByVal hKey As RegistryKeys, ByVal strKey As String)

    On Error Resume Next
  
    RegDeleteKey hKey, strKey


End Function

Public Function DeleteValue(ByVal hKey As RegistryKeys, _
                            ByVal strPath As String, _
                            ByVal strValue As String)

    On Error Resume Next

    Dim KeyHand As Long
  
    RegOpenKey hKey, strPath, KeyHand
    RegDeleteValue KeyHand, strValue
    RegCloseKey KeyHand


End Function

Public Function GetString(ByVal hKey As RegistryKeys, _
                          ByVal strPath As String, _
                          ByVal strValue As String) As String

    On Error Resume Next

    Dim KeyHand      As Long

    Dim datatype     As Long

    Dim lResult      As Long

    Dim strBuf       As String

    Dim lDataBufSize As Long

    Dim intZeroPos   As Integer

    Dim lValueType   As Long
  
    RegOpenKey hKey, strPath, KeyHand
    lResult = RegQueryValueEx(KeyHand, strValue, 0&, lValueType, ByVal 0&, lDataBufSize)

    If lValueType = REG_SZ Then
        strBuf = String(lDataBufSize, " ")
        lResult = RegQueryValueEx(KeyHand, strValue, 0&, 0&, ByVal strBuf, lDataBufSize)

        If lResult = ERROR_SUCCESS Then
            intZeroPos = InStr(strBuf, Chr(0))

            If intZeroPos > 0 Then
                GetString = Left(strBuf, intZeroPos - 1)
            Else
                GetString = strBuf
            End If
        End If
    End If
    

End Function

Public Sub SaveString(ByVal hKey As RegistryKeys, _
                      ByVal strPath As String, _
                      ByVal strValue As String, _
                      ByVal strData As String)

    On Error Resume Next

    Dim KeyHand As Long
  
    RegCreateKey hKey, strPath, KeyHand
    RegSetValueEx KeyHand, strValue, 0, REG_SZ, ByVal strData, Len(strData)
    RegCloseKey KeyHand


End Sub

Function GetDWORD(ByVal hKey As RegistryKeys, _
                  ByVal strPath As String, _
                  ByVal strValueName As String) As Long

    On Error Resume Next

    Dim lResult      As Long

    Dim lValueType   As Long

    Dim lBuf         As Long

    Dim lDataBufSize As Long

    Dim KeyHand      As Long

    RegOpenKey hKey, strPath, KeyHand
    lDataBufSize = 4
    lResult = RegQueryValueEx(KeyHand, strValueName, 0&, lValueType, lBuf, lDataBufSize)

    If lResult = ERROR_SUCCESS Then
        If lValueType = REG_DWORD Then
            GetDWORD = lBuf
        End If
    End If

    RegCloseKey KeyHand
    

End Function

Function SaveDWORD(ByVal hKey As RegistryKeys, _
                   ByVal strPath As String, _
                   ByVal strValueName As String, _
                   ByVal lData As Long)

    On Error Resume Next

    Dim lResult As Long

    Dim KeyHand As Long
   
    RegCreateKey hKey, strPath, KeyHand
    lResult = RegSetValueEx(KeyHand, strValueName, 0&, REG_DWORD, lData, 4)
    RegCloseKey KeyHand
    

End Function