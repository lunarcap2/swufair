<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/inc/function/base_util.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim quest_idx, mento_no
	quest_idx = request("quest_idx")
	mento_no = request("mento_no")

	Dim strQuery : strQuery = ""
	strQuery = strQuery & " SELECT ���丵_��Ϲ�ȣ, ����, �����"
	strQuery = strQuery & " FROM ���丵_�������� WITH(NOLOCK)"
	strQuery = strQuery & " WHERE IDX = " & quest_idx

	Dim arrRs
	arrRs = arrGetRsSql(DBCon, strQuery, "", "")



	ReDim Param(5)
	Param(0) = makeparam("@kw",adVarChar,adParamInput,100,"")
	Param(1) = makeparam("@mentor_day",adVarChar,adParamInput,10,"")
	Param(2) = makeparam("@mentor_no",adInteger,adParamInput,4,"")
	Param(3) = makeparam("@page",adInteger,adParamInput,4,1)
	Param(4) = makeparam("@pagesize",adInteger,adParamInput,4,1)
	Param(5) = makeparam("@totalcnt",adInteger,adParamOutput,4,"")

	Dim arrRsMentor
	arrRsMentor = arrGetRsSP(DBcon, "asp_������_��������_��Ȳ", Param, "", "")

DisconnectDB DBCon
%>

<div class="tb_area">
	<table class="tb tc">
		<colgroup>
			<col style="width:20%">
			<col style="width:30%">
			<col style="width:20%">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th>����</th>
				<td>ȫ�浿 ����</td>
				<th>���丵 �Ͻ�</th>
				<td>8��31�� / 14��</td>
			</tr>
			<tr>
				<td colspan="4" class="input_txt">
					<textarea><%=arrRs(1, 0)%></textarea>
				</td>
			</tr>
		</tbody>
	</table>
</div>