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

	Set UploadedFile = Post("img_logo").File	' �ӽ� ���� ���� ���� ��ü ���� ���� ���
	fileExtension	= UploadedFile.FileExtension	' ���� Ȯ����
	fileSize		= UploadedFile.Size		' ���� ũ��
	oriFileName		= UploadedFile.FileName	' ���ϸ�

	Dim img_logo : img_logo = ""

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
		img_logo		= datepath & "/" & newFileName & "." & fileExtension

	End If
	
	' input �� ��������
	Dim mentor_no, title, explain, mentoring_day, mentoring_time, link_url, s_date, s_time, e_date, e_time, limit_cnt, mentoring_gubun

	mentor_no		= Post.FormInputs("mentor_no").Value		' ��Ϲ�ȣ
	title			= Post.FormInputs("title").Value			' ����
	explain			= Post.FormInputs("explain").Value			' ����(�Ҽ�)
	mentoring_day	= Post.FormInputs("mentoring_day").Value	' ��㳯¥
	mentoring_time	= Post.FormInputs("mentoring_stime").Value & "," & Post.FormInputs("mentoring_etime").Value	' ���ð�
	link_url		= Post.FormInputs("link_url").Value			' ��ũ�ּ�
	s_date			= Post.FormInputs("s_date").Value			' ��û ���۳�¥
	s_time			= Post.FormInputs("s_time").Value			' ��û ����ð�
	e_date			= Post.FormInputs("e_date").Value			' ��û ���ᳯ¥
	e_time			= Post.FormInputs("e_time").Value			' ��û ����ð�
	limit_cnt		= Post.FormInputs("limit_cnt").Value		' �ο�����
	mentoring_gubun	= Post.FormInputs("mentoring_gubun").Value
	
	mentoring_time = Replace(mentoring_time, " ", "")	' ��������
	If s_time = "" Then s_time = "00"					' �⺻�� 00��
	If limit_cnt = "" Then limit_cnt = "4"				' �⺻�� 4��

	' zoom �ּ� �ٽü���
	Dim set_link_url
	If InStr(link_url, "http") > 0 Then 
		set_link_url = link_url
	Else 
		set_link_url = "http://" & link_url
	End If

	'Response.write "mentor_no		: " & mentor_no			& "<br>"
	'Response.write "title			: " & title				& "<br>"
	'Response.write "mentoring_day	: " & mentoring_day		& "<br>"
	'Response.write "mentoring_time	: " & mentoring_time	& "<br>"
	'Response.write "link_url		: " & link_url			& "<br>"
	'Response.write "s_date			: " & s_date			& "<br>"
	'Response.write "s_time			: " & s_time			& "<br>"
	'Response.write "e_date			: " & e_date			& "<br>"
	'Response.write "e_time			: " & e_time			& "<br>"
	'Response.write "limit_cnt		: " & limit_cnt			& "<br>"

	'Response.write "img_logo		 : " & img_logo	 & "<br>"
	'Response.End
	
	'������ �����̸鼭 ÷������ ���οø��� �ʾ������ ���� ���������� ������Ʈ
	If mentor_no <> "" And img_logo = "" Then img_logo = Post.FormInputs("str_img_logo").Value

	Dim regKey : regKey = 0
	Dim spName
	spName = "asp_������_�������_���"
	
	ReDim parameter(13)
	parameter(0)	= makeParam("@MENTOR_NO",		adInteger,	adParamInput,	4,		mentor_no)
	parameter(1)	= makeParam("@TITLE",			adVarChar,	adParamInput,	200,	title)
	parameter(2)	= makeParam("@EXPLAIN",			adVarChar,	adParamInput,	200,	explain)
	parameter(3)	= makeParam("@MENTORING_DAY",	adVarChar,	adParamInput,	10,		mentoring_day)
	parameter(4)	= makeParam("@MENTORING_TIME",	adVarChar,	adParamInput,	100,	mentoring_time)
	parameter(5)	= makeParam("@IMG_LOGO",		adVarChar,	adParamInput,	200,	img_logo)
	parameter(6)	= makeParam("@LINK_URL",		adVarChar,	adParamInput,	1000,	set_link_url)
	parameter(7)	= makeParam("@S_DATE",			adVarChar,	adParamInput,	10,		s_date)
	parameter(8)	= makeParam("@S_TIME",			adVarChar,	adParamInput,	2,		s_time)
	parameter(9)	= makeParam("@E_DATE",			adVarChar,	adParamInput,	10,		e_date)
	parameter(10)	= makeParam("@E_TIME",			adVarChar,	adParamInput,	2,		e_time)
	parameter(11)	= makeParam("@LIMIT_CNT",		adInteger,	adParamInput,	4,		"")

	parameter(12)	= makeParam("@mentoring_gubun",	adVarChar,	adParamInput,	100,	mentoring_gubun)

	parameter(13)	= makeParam("@RTN",				adInteger,	adParamOutput,	4,		"")
	
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