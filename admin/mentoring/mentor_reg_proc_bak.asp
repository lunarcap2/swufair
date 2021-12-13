<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<%
ConnectDB DBCon, Application("DBInfo_FAIR")

Dim temppath, sourcepath
temppath	= "D:\solution\"& site_title &"\files\temp\"
sourcepath	= "D:\solution\"& site_title &"\files\mentor\"

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

	Post.Upload temppath ' ÷������ �ӽ� ������ ����
	fileExtension	= ""
	fileSize		= 0
	oriFileName		= ""

	Set UploadedFile = Post("file_com_logo").File	' �ӽ� ���� ���� ���� ��ü ���� ���� ���
	fileExtension	= UploadedFile.FileExtension	' ���� Ȯ����
	fileSize		= UploadedFile.Size		' ���� ũ��
	oriFileName		= UploadedFile.FileName	' ���ϸ�

	Dim com_logo : com_logo = ""

	'÷������ ������츸 ���Ͼ��ε���� ����
	If fileExtension <> "" Then

		' ÷������ Ȯ���� üũ
		dim blnAllowExtension : blnAllowExtension = false
		AllowExtension = Array("gif", "jpg", "jpeg", "png")
		For intIndex=0 To Ubound(AllowExtension)
			If LCase(fileExtension) = AllowExtension(intIndex) Then 
				blnAllowExtension = true 
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
		maxFileSize = 1024 * 1024 * 5	' �ִ� ���� ���� ���� �뷮(20971520)
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

		com_logo		= datepath & "/" & newFileName & "." & fileExtension

	End If
	
	' input �� ��������
	Dim mentor_no, mentor_name, com_name, dept_name, mentoring_day, mentoring_hour, mentoring_min
	mentor_no		= Post.FormInputs("mentor_no").Value		'�����ȣ
	mentor_name		= Post.FormInputs("mentor_name").Value		'�����̸�
	com_name		= Post.FormInputs("com_name").Value			'�Ҽ�ȸ��
	dept_name		= Post.FormInputs("dept_name").Value		'�μ���
	mentoring_day	= Post.FormInputs("mentoring_day").Value	'���丵_��
	mentoring_hour	= Post.FormInputs("mentoring_hour").Value	'���丵_��
	mentoring_min	= Post.FormInputs("mentoring_min").Value	'���丵_��

	'Response.write "mentor_name		 : " & mentor_name		 & "<br>"
	'Response.write "com_name		 : " & com_name			 & "<br>"
	'Response.write "dept_name		 : " & dept_name		 & "<br>"
	'Response.write "mentoring_day	 : " & mentoring_day	 & "<br>"
	'Response.write "mentoring_hour	 : " & mentoring_hour	 & "<br>"
	'Response.write "mentoring_min	 : " & mentoring_min	 & "<br>"
	'
	'Response.write "com_logo		 : " & com_logo	 & "<br>"
	'Response.End
	
	'������ �����̸鼭 ÷������ ���οø��� �ʾ������ ���� ���������� ������Ʈ
	If mentor_no <> "" And com_logo = "" Then com_logo = Post.FormInputs("str_file_com_logo").Value	

	Dim regKey : regKey = 0
	Dim spName
	spName = "asp_������_��������_���"
	
	ReDim parameter(9)
	parameter(0)    = makeParam("@MENTOR_NO", adInteger, adParamInput, 4, mentor_no)
	parameter(1)    = makeParam("@MENTOR_NAME", adVarChar, adParamInput, 20, mentor_name)
	parameter(2)    = makeParam("@COM_NAME", adVarChar, adParamInput, 100, com_name)
	parameter(3)    = makeParam("@DEPT_NAME", adVarChar, adParamInput, 100, dept_name)
	parameter(4)    = makeParam("@COM_LOGO", adVarChar, adParamInput, 200, com_logo)
	parameter(5)    = makeParam("@TAG", adVarChar, adParamInput, 2000, "")
	parameter(6)    = makeParam("@MENTORING_DAY", adChar, adParamInput, 10, mentoring_day)
	parameter(7)    = makeParam("@MENTORING_HOUR", adChar, adParamInput, 2, mentoring_hour)
	parameter(8)    = makeParam("@MENTORING_MIN", adChar, adParamInput, 2, mentoring_min)
	parameter(9)    = makeParam("@RTN", adInteger, adParamOutput, 4, "")
	
	Call execSP(DBCon,spName,parameter, "", "")
	regKey = getParamOutputValue(parameter, "@RTN")

	Post.Flush
	Set UploadedFile = Nothing
	Set Post = Nothing

End If 

DisconnectDB DBCon


Response.Write "<script language=javascript>"&_
	"alert('���� �Ǿ����ϴ�.');"&_
	"location.href='mentor_list.asp';"&_
	"</script>"
Response.End 
%>