<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
Dim del_mentor_no : del_mentor_no	= request("del_mentor_no")


Dim fs
Set fs = Server.CreateObject("Scripting.FileSystemObject")	


dbCon.Open Application("DBInfo_FAIR")


	Dim strSql, arrRs, upFile, strFolder
	strSql = "SELECT �ΰ��̹��� FROM ���_���� WITH(NOLOCK) WHERE ��Ϲ�ȣ= '" & del_mentor_no & "'"
	arrRs = arrGetRsSql(dbCon, strSql, "", "")

	If isArray(arrRs) Then			
		strFolder	= Split(arrRs(0,0), "/")(0)
		upFile		= Split(arrRs(0,0), "/")(1)
	End If

	strFolder	= Trim(strFolder)
	upFile		= Trim(upFile)

	'Response.write "strFolder : " & strFolder & "<br>"
	'Response.write "upFile : " & upFile & "<br>"

	Dim objFS
	set objFS = CreateObject("Scripting.FileSystemObject")

	Dim sourcepath : sourcepath	= "D:\solution\" & site_title & "\files\mentor\" & strFolder & "\"

	'Response.write "sourcepath : " & sourcepath & "<br>"
	'response.end

	'1) ���� ����
	If upFile <> "" Then
		If objFs.FileExists(sourcepath & upFile) Then objFs.DeleteFile sourcepath & upFile
	End If

	'2) ������ ����
	Dim spName, regKey
	
	spName = "asp_������_�������_����"

	ReDim parameter(1)
	parameter(0)    = makeParam("@consult_no", adInteger, adParamInput, 4, del_mentor_no)
	parameter(1)    = makeParam("@RTN", adInteger, adParamOutput, 4, "")

	Call execSP(dbCon,spName,parameter, "", "")
	regKey = getParamOutputValue(parameter, "@RTN")


	Response.Write "<script language=javascript>"&_
		"alert('�����Ǿ����ϴ�.');"&_
		"location.href='mentor_list.asp';"&_
		"</script>"
	Response.End


DisconnectDB dbCon


Set fs = Nothing
%>
