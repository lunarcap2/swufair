<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<%
	Dim result_id, result_date
	result_id = request("result_id")
	result_date = request("result_date")

	If result_id = "" Then
		Response.write "<script>" &_
		"	alert('�߸��� �����Դϴ�.');" &_
		"	history.back();" &_
		"</script>"
		Response.End 
	End If
%>
</head>
<body>
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- ������ -->
<div id="contents" class="util">
	<div class="content">
		<div class="input_area">
			<div class="tit">
				<h3>���̵� ã�� ���</h3>
			</div>
			<div class="sch_area">
				<table class="tb">
					<colgroup>
						<col style="width:100%;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<td class="result">
								<p>
									<span><%=result_id%></span> (������ : <%=result_date%>)
								</p>
							</td>
						</tr>
					</tbody>
				</table>
				<p class="tb_ment">�������� ��ȣ�� ���� ���̵� �Ϻκ��� *�� ǥ���մϴ�.</p>
				<div class="btn_area">
					<a href="/my/login.asp" class="btn blue">�α��� �ϱ�</a>
					<a href="/my/search/searchPW.asp" class="btn gray">��й�ȣ ã��</a>
				</div>
			</div><!-- sch_area -->
		</div>
	</div><!-- //content -->
</div><!-- //contents -->
<!--// ������ -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>