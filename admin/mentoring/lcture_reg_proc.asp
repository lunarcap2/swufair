<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
	ConnectDB DBCon, Application("DBInfo_FAIR")

		' input �� ��������
		Dim lcture_no, lcture_tit, lcture_sday, lcture_shour, lcture_smin, lcture_eday, lcture_ehour, lcture_emin, lcture_zoomurl, proc_gubun, lcture_gubun
		lcture_no		= Request("lcture_no")		'Ư����ȣ
		lcture_tit		= Request("lcture_tit")		'Ư����
		lcture_sday		= Request("lcture_sday")	'Ư��_������
		lcture_shour	= Request("lcture_shour")	'Ư��_���۽�
		lcture_smin		= "00"						'Ư��_���ۺ�
		lcture_eday		= Request("lcture_eday")	'Ư��_������
		lcture_ehour	= Request("lcture_ehour")	'Ư��_�����
		lcture_emin		= "00"						'Ư��_�����
		lcture_zoomurl	= Request("lcture_zoomurl")	'Ư��zoom�ּ�

		proc_gubun		= Request("proc_gubun")		' ���/����-submit || ����-delete

		lcture_gubun	= Request("lcture_gubun")	'Ư������

		' zoom �ּ� �ٽü���
		Dim set_lcture_zoomurl
		If InStr(lcture_zoomurl, "http") > 0 Then 
			set_lcture_zoomurl = lcture_zoomurl
		Else 
			set_lcture_zoomurl = "http://" & lcture_zoomurl
		End If
		


		' ��������
		lcture_no			= Trim(lcture_no)	
		lcture_tit			= Trim(lcture_tit)	
		lcture_sday			= Trim(lcture_sday)	
		lcture_shour		= Trim(lcture_shour)
		lcture_smin			= Trim(lcture_smin)	
		lcture_eday			= Trim(lcture_eday)	
		lcture_ehour		= Trim(lcture_ehour)
		lcture_emin			= Trim(lcture_emin)	
		set_lcture_zoomurl	= Trim(set_lcture_zoomurl)
		lcture_gubun		= Trim(lcture_gubun)

		

		' ���ǽ����Ͻ�, �����Ͻ� ��¥�������� ��ȯ
		Dim set_lcture_sday, set_lcture_eday
		set_lcture_sday = lcture_sday & " " & lcture_shour & ":" & lcture_smin
		set_lcture_eday = lcture_eday & " " & lcture_ehour & ":" & lcture_emin	
		
		set_lcture_sday	= LTrim(RTrim(set_lcture_sday))
		set_lcture_eday	= LTrim(RTrim(set_lcture_eday))



		Dim regKey : regKey = 0
		Dim spName, alert_msg

		If proc_gubun = "submit" Then
			alert_msg = "���� �Ǿ����ϴ�."

			spName = "asp_������_Ư����ʰ���_���"

			ReDim parameter(6)
			parameter(0)    = makeParam("@lcture_no", adInteger, adParamInput, 4, lcture_no)
			parameter(1)    = makeParam("@lcture_tit", adVarWChar, adParamInput, 400, lcture_tit)
			parameter(2)    = makeParam("@lcture_sday", adVarWChar, adParamInput, 100, set_lcture_sday)
			parameter(3)    = makeParam("@lcture_eday", adVarWChar, adParamInput, 100, set_lcture_eday)
			parameter(4)    = makeParam("@lcture_zoomurl", adVarWChar, adParamInput, 400, set_lcture_zoomurl)

			parameter(5)    = makeParam("@lcture_gubun", adVarWChar, adParamInput, 100, lcture_gubun)

			parameter(6)    = makeParam("@RTN", adInteger, adParamOutput, 4, "")			
		
		Else			
			alert_msg = "���� �Ǿ����ϴ�."

			spName = "asp_������_Ư����ʰ���_����"

			ReDim parameter(1)
			parameter(0)    = makeParam("@lcture_no", adInteger, adParamInput, 4, lcture_no)
			parameter(1)    = makeParam("@RTN", adInteger, adParamOutput, 4, "")

		End If

		Call execSP(DBCon,spName,parameter, "", "")
		regKey = getParamOutputValue(parameter, "@RTN")

	DisconnectDB DBCon


	
	Response.Write "<script language=javascript>"&_
		"alert('" & alert_msg & "');"&_
		"location.href='lcture_list.asp';"&_
		"</script>"
	Response.End 
%>