<%
Option Explicit 
%>
<!--#include virtual = "/common/constant.asp"-->
<%
Dim file
Dim filePolder, fileName, fileOrigin
filePolder	= Request("filePolder")
fileName	= Request("fileName")
fileOrigin	= Request("fileOrigin")


Set file = Server.CreateObject("ActiveFile.File")
file.Name = "D:\solution\"& site_title &"\files\notice\"& filePolder &"\"& fileName
Response.write "D:\solution\"& site_title &"\files\notice\"& filePolder &"\"& fileName


If Not file.Exists() Then 
	response.write "�����Ͻ� ������ �������� �ʽ��ϴ�."
	response.End 
End If 


'Response.Clear
Response.ContentType = "application/unknown"    'ContentType �� �����մϴ�.
Response.Addheader "Content-Disposition", "attachment;filename=" & fileOrigin
File.Download

Response.End 
%>
