<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: �Խ��� ���� - ���/����
' 	History		: 2020-07-21, �̻��� 
'--------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
Response.Charset = "euc-kr"

ConnectDB DBCon, Application("DBInfo_FAIR")


Dim temppath, sourcepath
temppath	= "D:\solution\"& site_title &"\files\temp\"
sourcepath	= "D:\solution\"& site_title &"\files\notice\"	' �������� ÷������ ���� ��ġ


Dim targetpath, datepath
datepath	= Left(Replace(FormatDateTime(Now(), 2),"-",""), 6)	' ÷������ ������ ���� �и� ����
targetpath	= sourcepath & datepath & "\"


Dim objFS
Set objFS = CreateObject("Scripting.FileSystemObject")


Dim Post, UploadedFile
Dim fileExtension, fileSize, oriFileName
Dim AllowExtension, intIndex
Dim maxFileSize


'-- ÷������ ���ε�
If InStr(Request.ServerVariables("CONTENT_TYPE"), "multipart/form-data") > 0 Then 
	
	' Perform the upload
	Set Post = Server.CreateObject("ActiveFile.Post")
	On Error Resume Next

	ReDim arrNewFile(5)
	ReDim arrOriFile(5)
	
	For i = 1 To 5 ' ÷������ ��� ���� �� ��ŭ ��ȿ�� ����
		
		Post.Upload temppath ' ÷������ �ӽ� ������ ����
	
		fileExtension	= ""
		fileSize		= 0
		oriFileName		= ""

		Set UploadedFile = Post("file"&i).File			' �ӽ� ���� ���� ���� ��ü ���� ���� ���
		fileExtension	= UploadedFile.FileExtension	' ���� Ȯ����
		fileSize		= UploadedFile.Size		' ���� ũ��
		oriFileName		= UploadedFile.FileName	' ���ϸ�

		' ÷������ Ȯ���� üũ
		Dim blnAllowExtension	: blnAllowExtension = True 
		AllowExtension = Array("asp", "php", "jsp", "aspx", "js", "vbs", "htm", "html", "txt", "sql", "com", "bat", "cgi", "dll", "exe")
		For intIndex=0 To Ubound(AllowExtension)
			If LCase(fileExtension) = AllowExtension(intIndex) Then 
				blnAllowExtension = False 
				Exit For
			End If
		Next

		maxFileSize = 1024 * 1024 * 5	' �ִ� ���� ���� ���� �뷮(20971520)


		' 1) ��ϰ��� Ȯ���ڰ� �ƴ� ��� ����
		If blnAllowExtension = False Then 
			UploadedFile.Delete
			Set UploadedFile = Nothing 
			
			Post.Flush
			Set Post = Nothing 

			Response.Write "<script language=javascript>"&_
				"alert('÷������ ���ε� ����\n- ����� �� ���� ���� ���� �Դϴ�. ���� Ȯ���ڸ� �ٽ� Ȯ���Ͻð� ���ε��� �ּ���.');"&_
				"location.href=history.go(-1);"&_
				"</script>"
			Response.End 
		End If


		' 2) ���� ������ �ʰ� �� ����
		If CLng(fileSize) > maxFileSize Then 			
			UploadedFile.Delete
			Set UploadedFile = Nothing
			
			Post.Flush
			Set Post = Nothing
		
			Response.Write "<script language=javascript>"&_
				"alert('÷������ ���ε� ����\n- ���� ũ�Ⱑ �ʰ��Ǿ����ϴ�. ���� ����� ������ �� ���ε��� �ּ���.\n- �ִ� 5MB ������ ��� ����');"&_
				"location.href=history.go(-1);"&_
				"</script>"
			Response.End 
		End If

		
		' 3) ÷�� ���� ����
		Randomize()
		Dim randomno	: randomno = Int(10000* Rnd())
		randomno = Right("0000"&randomno,5)

		' ���ϸ� ����Ͻú���+���� ���� ���·� ��ü
		Dim newFileName : newFileName = Replace(FormatDateTime(Now(), 2),"-","") & Replace(FormatDateTime(Now(), 4),":","") & Right(now(),2) & randomno 

		' 3-1) ���� ������ ���� ��� ����
		If objFs.FolderExists(targetpath) = False Then
			objFs.CreateFolder(targetpath)
		End If
		
		' 3-2) �������� ���� ��ο� ���� ����
		UploadedFile.Copy targetpath & newFileName & "." & fileExtension

		' 3-3) ���� ���� ����
'			If pre_file_name <> "" Then
'				objFs.DeleteFile sourcepath & pre_file_name
'			End If
		

		' 3-4) ���� ���� DB ����
		If Len(oriFileName)>0 Then
			'sql2 = "SET NOCOUNT ON;"
			'sql2 = sql2 &" INSERT INTO �Խ���_÷������ ("
			'sql2 = sql2 &" �Խ��ǹ�ȣ, ÷�����ϸ�, �������ϸ�, �������� "
			'sql2 = sql2 &" ) VALUES ("
			'sql2 = sql2 &" '"&regKey&"', '"&newFileName&"', '"&oriFileName&"', 'notice'"
			'sql2 = sql2 &" );"
			'DBCon.Execute(sql2)

			arrNewFile(i) = newFileName & "." & fileExtension
			arrOriFile(i) = oriFileName

		End If 

	Next
	'Response.write "file1 : " & arrOriFile(1) & "<br>"
	'Response.write "file2 : " & arrOriFile(2) & "<br>"
	'Response.write "file3 : " & arrOriFile(3) & "<br>"
	'Response.write "file4 : " & arrOriFile(4) & "<br>"
	'Response.write "file5 : " & arrOriFile(5) & "<br>"

	
	
	
	' input �� ��������
	'Dim str_title, txtContent, chkTop, rdoOpenYn
	'str_title	= Post.FormInputs("str_title").Value	' ����
	'txtContent	= Post.FormInputs("txtContent").Value	' ����
	'chkTop		= Post.FormInputs("chkTop").Value		' �ֻ��� ���� ����(Y/N)
	'rdoOpenYn	= Post.FormInputs("rdoOpenYn").Value	' ȭ�� ���� ����(Y/N)

	Dim gubun, seq, title, txtContent, jobs_id, mode
	gubun		= Post.FormInputs("gubun").Value		'�Խ��Ǳ���
	seq			= Post.FormInputs("seq").Value			'�Խ��ǹ�ȣ
	title		= Post.FormInputs("title").Value		'����
	txtContent	= Post.FormInputs("txtContent").Value	'����
	jobs_id		= Post.FormInputs("jobs_id").Value		'?
	mode		= Post.FormInputs("mode").Value			'���/����
	
	If gubun = "" Then 
		gubun = "1"
	Else 
		gubun = gubun
	End If  
	'Response.write "gubun : " & gubun & "<br>"
	'Response.write "seq : " & seq & "<br>"
	'Response.write "title : " & title & "<br>"
	'Response.write "txtContent : " & txtContent & "<br>"
	'Response.write "jobs_id : " & jobs_id & "<br>"
	'Response.write "mode : " & mode & "<br>"

If seq = "" Then	' �ű� ��� ��
	Dim regKey : regKey = 0
	Dim spName
	spName = "usp_board_Insert"
	
	ReDim parameter(6)
	parameter(0)    = makeParam("@Gubun", adVarChar, adParamInput, 2, gubun)		
	parameter(1)    = makeParam("@jobs_id", adChar, adParamInput, 10, jobs_id)
	parameter(2)    = makeParam("@UserName", adVarChar, adParamInput, 100, admin_id)
	parameter(3)    = makeParam("@BizName", adVarChar, adParamInput, 100, "")
	parameter(4)    = makeParam("@Title", adVarChar, adParamInput, 500, title)		
	parameter(5)    = makeParam("@Content", adLongVarWChar, adParamInput, LenB(txtContent), txtContent)
	parameter(6)    = makeParam("@Rtn", adInteger, adParamOutput, 4, "")	
	
	Call execSP(DBCon,spName,parameter, "", "")
	regKey = getParamOutputValue(parameter, "@Rtn")

Else	' ���� ��
	regKey = seq
	spName = "usp_board_modify"

	ReDim parameter(6)
	parameter(0)    = makeParam("@Idx", adInteger, adParamInput, 4, regKey)
	parameter(1)    = makeParam("@jobs_id", adInteger, adParamInput, 4, "")
	parameter(2)    = makeParam("@UserName", adVarChar, adParamInput, 30, admin_id)
	parameter(3)    = makeParam("@BizName", adVarChar, adParamInput, 200, "")
	parameter(4)    = makeParam("@Title", adVarChar, adParamInput, 500, title)	
	parameter(5)    = makeParam("@Content", adLongVarWChar, adParamInput, LenB(txtContent), txtContent)
	parameter(6)    = makeParam("@Rtn", adInteger, adParamOutput, 4, "")	

	Call execSP(DBCon,spName,parameter,"","")
	rtnValue = getParamOutputValue(parameter, "@Rtn")

End If 
	
	'÷������ ����
	For i = 1 To 5
		If arrNewFile(i) <> "" Then

			ReDim parameter(4)
			spName = "usp_board_files_insert"

			parameter(0)    = makeParam("@seq", adInteger, adParamInput, 4, regKey)
			parameter(1)    = makeParam("@gubun", adChar, adParamInput, 1, "1")
			parameter(2)    = makeParam("@upFile", adVarChar, adParamInput, 100, arrNewFile(i))
			parameter(3)    = makeParam("@realFile", adVarChar, adParamInput, 100, arrOriFile(i))
			parameter(4)    = makeParam("@strFolder", adChar, adParamInput, 6, datepath)

			Call execSP(DBCon,spName,parameter,"","")

		End If
	Next


	Post.Flush
	Set UploadedFile = Nothing
	Set Post = Nothing	

End If 

DisconnectDB DBCon

If seq = "" Then 
	Response.Write "<script language=javascript>"&_
		"alert('���� �Ǿ����ϴ�.');"&_
		"location.href='board_list.asp';"&_
		"</script>"
	Response.End 
Else 
	If rtnValue="1" Then 
		Response.Write "<script language=javascript>"&_
			"alert('���� �Ǿ����ϴ�.');"&_
			"location.href='board_list.asp';"&_
			"</script>"
		Response.End 		
	Else
		Response.Write "<script language=javascript>"&_
			"alert('���� �� ���� �߻�! �����ڿ��� �����ϼ���.');"&_
			"location.href='board_list.asp';"&_
			"</script>"
		Response.End 		
	End If 
End If 
%>