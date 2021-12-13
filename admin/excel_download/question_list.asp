<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->

<%
	Response.CharSet		= "euc-kr"
	Response.ContentType	= "application/x-msexcel"
	Response.CacheControl	= "public"
	Response.AddHeader  "Content-Disposition", "attachment;filename=���￩��_����������.xls"

	Dim gubun		: gubun			= Request("gubun")
	Dim schKeyword	: schKeyword	= Request("schKeyword") ' �˻���(����/����)
	Dim sDate		: sDate			= Request("sDate")
	Dim eDate		: eDate			= Request("eDate")
	Dim mentorNo	: mentorNo		= Request("mentorNo")
	Dim page		: page			= Request("page")
	Dim pageSize	: pageSize		= 100000


	If page = "" Then page=1
	page = CInt(page)

	If sDate = "" Then sDate = ""
	If eDate = "" Then eDate = ""
	If mentorNo = "" Then mentorNo = ""


	ConnectDB DBCon, Application("DBInfo_FAIR")

		ReDim Param(8)
		Param(0) = makeparam("@KW_GUBUN",adVarChar,adParamInput,100,gubun)
		Param(1) = makeparam("@KW",adVarChar,adParamInput,100,schKeyword)
		Param(2) = makeparam("@MENTORING_NO",adInteger,adParamInput,4,mentorNo)
		Param(3) = makeparam("@S_DATE",adVarChar,adParamInput,10,sDate)
		Param(4) = makeparam("@E_DATE",adVarChar,adParamInput,10,eDate)
		Param(5) = makeparam("@USER_ID",adVarChar,adParamInput,20,"")
		Param(6) = makeparam("@PAGE",adInteger,adParamInput,4,page)
		Param(7) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,pagesize)
		Param(8) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")

		Dim arrRs, totalCnt, pageCount
		arrRs		= arrGetRsSP(DBcon, "asp_������_�������_��������_����Ʈ", Param, "", "")
		totalCnt	= getParamOutputValue(Param, "@TOTAL_CNT")
		pageCount	= int(totalCnt / pagesize) + 1

	DisconnectDB DBCon
%>

<!DOCTYPE html>
<html lang="ko">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head>
</head>

<body>
	<table border="1" cellpadding="0" cellspacing="0" summary="">
		<colgroup>
			<col style="width:50px" />
			<col style="width:200px" />
			<col style="width:220px" />
			<col style="width:200px" />
			<col style="width:200px" />
			<col style="width:200px" />
			<col style="width:200px" />
			<col style="width:200px" />
		</colgroup>

		<thead>
			<tr height="50">
				<th style="background-color:#dfdfdf;">No</th>
				<th style="background-color:#dfdfdf;">�����о�</th>
				<th style="background-color:#dfdfdf;">��������ȸ����</th>
				<th style="background-color:#dfdfdf;">��������ȸ�ð�</th>
				<th style="background-color:#dfdfdf;">��û�� �̸�</th>
				<th style="background-color:#dfdfdf;">��û�� ID</th>
				<th style="background-color:#dfdfdf;">��������</th>
				<th style="background-color:#dfdfdf;">���� �����</th>
			</tr>
		</thead>

		<tbody>
			<%
				If isArray(arrRs) Then
					For i=0 To UBound(arrRs,2)
					quest_noDesc			= arrRs(0,i)	' ROW_NUM(dbo.���_��������.�����.DESC)
					quest_noAsc				= arrRs(1,i)	' ROW_NUM(dbo.���_��������.�����.ASC)
					quest_memId				= arrRs(2,i)	' ���ξ��̵�
					quest_memNm				= arrRs(3,i)	' ����
					quest_memPhone			= arrRs(4,i)	' �޴���
					quest_memEmail			= arrRs(5,i)	' ���ڿ���
					quest_joinDate			= arrRs(6,i)	' ȸ��������
					quest_counselTitle		= arrRs(7,i)	' �������
					quest_counselIntro		= arrRs(8,i)	' ����
					quest_counselDay		= arrRs(9,i)	' �����
					quest_counselTimeCd		= arrRs(10,i)	' ���ð�
					quest_counselLogo		= arrRs(11,i)	' �ΰ��̹���
					quest_counselGuestUrl	= arrRs(12,i)	' ��ũ�ּ�
					quest_cont				= arrRs(13,i)	' ����
					quest_regiDate			= arrRs(14,i)	' ���������
					quest_idx				= arrRs(15,i)	' IDX(dbo.���_��������.IDX)
					
					strQuestCont = quest_cont
					If strQuestCont <> "" Then strQuestCont = Replace(strQuestCont, Chr(10), "<br>")
			%>
			<tr>
				<td align="center"><%=quest_noAsc%></td>
				<td align="center"><%=quest_counselTitle%></td>
				<td align="center"><%=quest_counselDay%></td>
				<td align="center"><%=getInterviewTime(quest_counselTimeCd)%></td>
				<td align="center"><%=quest_memNm%></td>
				<td align="center"><%=Replace(quest_memId,"_wk","")%></td>
				<td align="left"><%=strQuestCont%></td>
				<td align="center"><%=quest_regiDate%></td>
			</tr>
			<%
					Next
				End If
			%>
		</tbody>
	</table>
</body>
</html>
