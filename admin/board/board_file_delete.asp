<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<%
Dim gubun	: gubun	= request("gubun")
Dim seq		: seq	= request("seq")
Dim idx		: idx	= request("idx")

If gubun = "" Then 
	gubun = "1"
Else 
	gubun = gubun
End If 

If seq = "" And idx = "" Then
	response.write "<script>"
	response.write "alert('���� ��� ���� ������ �����ϴ�.');"
	response.write "history.go(-1);"
	response.write "</script>"
	response.end
End If


dbCon.Open Application("DBInfo_FAIR")

sql = "SELECT upFile, realFile, strFolder FROM tbl_board_files WHERE seq='"&seq&"' AND idx='"&idx&"' AND gubun='"&gubun&"' "
Rs.Open sql, dbCon
If Not (Rs.BOF Or Rs.EOF) Then
	upFile		= Rs("upFile")
	realFile	= Rs("realFile")
	strFolder	= Rs("strFolder")

	Dim fs
	Set fs = Server.CreateObject("Scripting.FileSystemObject")	

	Dim sourcepath
	sourcepath	= "D:\solution\"& site_title &"\files\notice\"& strFolder &"\"	' �������� ÷������ ���� ��ġ

	Dim objFS, file_name
	set objFS = CreateObject("Scripting.FileSystemObject")

	'1) ���� ����
	If upFile <> "" Then
		If objFs.FileExists(sourcepath & upFile) Then objFs.DeleteFile sourcepath & upFile
	End If

	'2) DB ���� ����
	dbCon.BeginTrans 
	strSql = "DELETE FROM tbl_board_files WHERE seq='"&seq&"' AND idx='"&idx&"' AND gubun='"&gubun&"' "
	dbCon.Execute(strSql)
End If
Rs.close


If dbCon.Errors.Count = 0 Then
	dbCon.CommitTrans

	Response.Write "<script>" & vbCrLf &_
					"alert(""���� �Ǿ����ϴ�."");" & vbCrLf &_
					"location.href='board_form.asp?seq="& seq &"';" & vbCrLf &_
					"</script>"
Else
	dbCon.RollbackTrans

	Response.Write "<script>" & vbCrLf &_
					"alert(""Ȯ�� �� �ٽ� ������ �ּ���."");" & vbCrLf &_
					"history.go(-1);" &_
					"</script>"
End if

Set fs = Nothing


DisconnectDB DBCon
%>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>