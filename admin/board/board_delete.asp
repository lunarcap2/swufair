<%
Option Explicit
'On Error Resume Next
%>
<!--#include virtual="/inc/db/DBConnection.asp"-->
<%
Dim g_Debug
Dim fname,ArrRs,i

Dim seq		: seq	= request("seq")
Dim gubun	: gubun = request("gubun")

If seq = "" Then
	response.write "<script>"
	response.write "alert('�����Ͻ� ������ �����ϴ�.');"
	response.write "history.go(-1);"
	response.write "</script>"
	response.End 
End If

Dim spName
ReDim parameter(0)

Set fs = Server.CreateObject("Scripting.FileSystemObject")	
Dim fs

dbCon.Open Application("DBInfo_FAIR")

Dim sql, arrList, idx, upFile, strFolder, strSql
sql = "SELECT idx, upFile, strFolder FROM tbl_board_files WHERE seq='"&seq&"' AND gubun='"&gubun&"' "
arrList = arrGetRsSql(dbCon, sql,"","")
If IsArray(arrList) Then
	For i = LBound(arrList,2) To UBound(arrList,2)
		idx			= Trim(arrList(0,i))
		upFile		= Trim(arrList(1,i))
		strFolder	= Trim(arrList(2,i))

		Dim sourcepath
		sourcepath	= "D:\solution\starfieldjob\files\notice\"& strFolder &"\"	' �������� ÷������ ���� ��ġ

		Dim objFS, file_name
		set objFS = CreateObject("Scripting.FileSystemObject")

		'1) ���� ����
		If upFile <> "" Then
			If objFs.FileExists(sourcepath & upFile) Then objFs.DeleteFile sourcepath & upFile
		End If

		'2) DB ���� ����
		strSql = "DELETE FROM tbl_board_files WHERE seq='"&seq&"' AND idx='"&idx&"' AND gubun='"&gubun&"' "
		dbCon.Execute(strSql)
	Next
End If


dbCon.BeginTrans

spName = "usp_board_delete"

parameter(0) = makeParam("@seq", adInteger, adParamInput, 4, seq)
Call execSP(DBCon,spName,parameter,"","")

If dbCon.Errors.Count = 0 Then
	dbCon.CommitTrans

	Response.Write "<script>" & vbCrLf &_
					"alert(""���� �Ǿ����ϴ�."");" & vbCrLf &_
					"location.href='board_list.asp?gubun="& gubun &"';" & vbCrLf &_
					"</script>"
Else
	dbCon.RollbackTrans

	Response.Write "<script>" & vbCrLf &_
					"alert(""Ȯ�� �� �ٽ� ������ �ּ���."");" & vbCrLf &_
					"history.go(-1);" &_
					"</script>"
End if

Set fs = Nothing


dbcon.close
%>
