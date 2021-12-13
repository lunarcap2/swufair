<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<%
ConnectDB DBCon, Application("DBInfo_FAIR")

Dim temppath, sourcepath
temppath	= "D:\solution\"& site_title &"\files\temp\"
sourcepath	= "D:\solution\"& site_title &"\files\quest\"

Dim targetpath, datepath
datepath	= Left(Replace(FormatDateTime(Now(), 2),"-",""), 6)	' ÷������ ������ ���� �и� ����
targetpath	= sourcepath & datepath & "\"

Dim objFS
Set objFS = CreateObject("Scripting.FileSystemObject")

Dim Post, UploadedFile
Dim fileExtension, fileSize, oriFileName
Dim AllowExtension, intIndex
Dim maxFileSize


Dim file_yn : file_yn = "N"

'-- ÷������ ���ε�
If InStr(Request.ServerVariables("CONTENT_TYPE"), "multipart/form-data") > 0 Then 
	
	' Perform the upload
	Set Post = Server.CreateObject("ActiveFile.Post")
	On Error Resume Next

	ReDim arrNewFile(2)
	ReDim arrOriFile(2)

	For i = 1 To 2 ' ÷������ ��� ���� �� ��ŭ ��ȿ�� ����

		Post.Upload temppath ' ÷������ �ӽ� ������ ����
		fileExtension	= ""
		fileSize		= 0
		oriFileName		= ""

		Set UploadedFile = Post("ex_file"&i).File	' �ӽ� ���� ���� ���� ��ü ���� ���� ���
		fileExtension	= UploadedFile.FileExtension	' ���� Ȯ����
		fileSize		= UploadedFile.Size		' ���� ũ��
		oriFileName		= UploadedFile.FileName	' ���ϸ�
		

		'÷������ ������츸 ���Ͼ��ε���� ����
		If fileExtension <> "" Then

			file_yn = "Y"

			' ÷������ Ȯ���� üũ
			Dim blnAllowExtension	: blnAllowExtension = True 
			AllowExtension = Array("asp", "php", "jsp", "aspx", "js", "vbs", "htm", "html", "txt", "sql", "com", "bat", "cgi", "dll", "exe")
			For intIndex=0 To Ubound(AllowExtension)
				If LCase(fileExtension) = AllowExtension(intIndex) Then 
					blnAllowExtension = False 
					Exit For
				End If
			Next

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
			maxFileSize = 1024 * 1024 * 4	' �ִ� ���� ���� ���� �뷮(20971520)
			If CLng(fileSize) > maxFileSize Then 			
				UploadedFile.Delete
				Set UploadedFile = Nothing
				
				Post.Flush
				Set Post = Nothing
			
				Response.Write "<script language=javascript>"&_
					"alert('÷������ ���ε� ����\n- ���� ũ�Ⱑ �ʰ��Ǿ����ϴ�. ���� ����� ������ �� ���ε��� �ּ���.\n- �ִ� 4MB ������ ��� ����');"&_
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

			' 3-4) ������ �������� ��������
			If Len(oriFileName) > 0 Then
				arrNewFile(i) = datepath & "/" & newFileName & "." & fileExtension
				arrOriFile(i) = oriFileName
			End If 

		End If
	
	Next



	Dim pop_question_idx, pop_question_cont
	pop_question_idx	= Post.FormInputs("pop_question_idx").Value
	pop_question_cont	= Post.FormInputs("pop_question_cont").Value

	Dim strQuery
	strQuery = "UPDATE ���_�������� SET ���� = ? WHERE IDX = ?"

	ReDim param(1)
	Param(0) = makeparam("@cont",adVarChar,adParamInput,2000,pop_question_cont)
	Param(1) = makeparam("@idx",adInteger,adParamInput,4,pop_question_idx)
	Call execSqlParam(DBCon, strQuery, Param, "", "")

	'÷������ ����
	If file_yn = "Y" Then 		
		strQuery = "DELETE ���丵_��������_÷������ WHERE ����������ȣ = ?"
		ReDim param(0)
		Param(0) = makeparam("@����������ȣ",adInteger,adParamInput,4,pop_question_idx)
		Call execSqlParam(DBCon, strQuery, Param, "", "")
		
		For i = 1 To 2
			If arrNewFile(i) <> "" Then
				ReDim parameter(4)
				spName = "usp_����_���丵_��������_÷������_���"
				parameter(0)    = makeParam("@QUESTION_NO", adInteger, adParamInput, 4, pop_question_idx)
				parameter(1)    = makeParam("@UP_FILE", adVarChar, adParamInput, 2000, arrNewFile(i))
				parameter(2)    = makeParam("@REAL_FILE", adVarChar, adParamInput, 2000, arrOriFile(i))
				parameter(3)    = makeParam("@RTN", adInteger, adParamOutput, 4, "")
				Call execSP(DBCon,spName,parameter,"","")
			End If
		Next
	End If 


	Post.Flush
	Set UploadedFile = Nothing
	Set Post = Nothing

End If 

DisconnectDB DBCon


Response.Write "<script language=javascript>"&_
	"alert('�������� ������ �Ϸ�Ǿ����ϴ�.');"&_
	"location.href='/my/default.asp';"&_
	"</script>"
response.End
%>