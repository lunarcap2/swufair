<% Option Explicit %>
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<!--#include virtual="/inc/function/paging.asp"-->
<%
	' ������ ������ ��쿡�� ���� ���   
	If Request.Cookies(site_code & "WKADMIN")("admin_id")="" Then 
		Response.Write "<script language=javascript>"&_
			"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
			"location.href='/';"&_
			"</script>"
		response.End 
	End If

	Dim mentor_no : mentor_no = request("mentor_no")
	Dim mode, com_name, dept_name, mentor_name, mentoring_day, mentoring_hour, mentoring_min, file_com_logo
	If mentor_no <> "" Then
	ConnectDB DBCon, Application("DBInfo_FAIR")
		
		mode = "edit"

		Dim strQuery, arrRs
		strQuery = ""
		strQuery = strQuery & " SELECT ��Ϲ�ȣ,�̸�,�����,�μ���,�ؽ��±�,ȸ��ΰ�,���丵_��,���丵_��,���丵_��,�����"
		strQuery = strQuery & " FROM �������� WITH(NOLOCK) WHERE ��Ϲ�ȣ = " & mentor_no

		arrRs = arrGetRsSql(DBCon, strQuery, "", "")

		If isArray(arrRs) Then
			mentor_name		= arrRs(1, 0)
			com_name		= arrRs(2, 0)
			dept_name		= arrRs(3, 0)
			mentoring_day	= arrRs(6, 0)
			mentoring_hour	= arrRs(7, 0)
			mentoring_min	= arrRs(8, 0)
			file_com_logo	= arrRs(5, 0)
		End If

	DisconnectDB DBCon
	End If
%>
<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	
	function fn_submit() {

		if ($('#com_name').val() == '') {
			alert('�Ҽ�ȸ�縦 �Է��� �ּ���.');
			$('#com_name').focus();
			return;
		}
		
		/*
		if ($('#dept_name').val() == '') {
			alert('�μ����� �Է��� �ּ���.');
			$('#dept_name').focus();
			return;
		}

		if ($('#mentor_name').val() == '') {
			alert('���� �̸��� �Է��� �ּ���.');
			$('#mentor_name').focus();
			return;
		}
		*/

		if ($('#mentoring_day').val() == '' || $('#mentoring_hour').val() == '' || $('#mentoring_min').val() == '') {
			alert('���丵 �Ͻø� ��� �Է��� �ּ���.');
			return;
		}
		
		if ($("#mode").val() == "" && $('#file_com_logo').val() == '') {
			alert('ȸ��ΰ� �̹����� ÷�����ּ���');
			$('#file_com_logo').focus();
			return;
		}

		document.frm.action = "./mentor_reg_proc.asp";
		document.frm.submit();
	}


	//���� ÷�� �̸�����
	function fn_load_img(obj) {
		var file_name = $(obj).val();
		$('#upload_name').val(file_name);
	}


</script>
</head>

<body id="loginWrap">
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- ������ -->
<form method="post" id="frm" name="frm" enctype="multipart/form-data">
<input type="hidden" id="mentor_no" name="mentor_no" value="<%=mentor_no%>">
<input type="hidden" id="mode" name="mode" value="<%=mode%>">

<div id="contents" class="admin">
	<div class="content">
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<% If mode = "edit" Then %>
				<li><a href="#none;">�������</a></li>
				<% Else %>
				<li><a href="#none;">������</a></li>
				<% End If %>
			</ul>
		</div>
		<div class="list_area view">
			<div class="tit">
				<% If mode = "edit" Then %>
				<h3>�������</h3>
				<% Else %>
				<h3>������</h3>
				<% End If %>
			</div>
			<table class="tb">
				<colgroup>
					<col style="width:20%;">
					<col style="width:30%;">
					<col style="width:20%;">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th>���� �Ҽ�ȸ��</th>
						<td colspan="3">
							<input type="text" class="txt" id="com_name" name="com_name" value="<%=com_name%>" placeholder="" style="width:100%;">
						</td>
						<!--
						<th>�μ���</th>
						<td>
							<input type="text" class="txt" id="dept_name" name="dept_name" value="<%=dept_name%>" placeholder="" style="width:100%;">
						</td>
						-->
					</tr>
					<!--
					<tr>
						<th>���丵 �׸� / ����</th>
						<td colspan="3" class="input_add">
							<div class="input_add_box">
								<input type="text" class="txt" name="" placeholder="">
								<button type="button" class="add_btn">�߰�</button>
							</div>
							<script>
								$('.add_btn').click(function() {
									$('.input_add_box').append('<input type="text" class="txt" name="" placeholder="">');
								});
							</script>
						</td>
					</tr>
					-->
					<!--
					<tr>
						<th>���� �̸�</th>
						<td colspan="3" class="input_add">
							<input type="text" class="txt" id="mentor_name" name="mentor_name" value="<%=mentor_name%>" placeholder="" style="width:210px;">
						</td>
					</tr>
					-->
					<tr>
						<th>���丵 �Ͻ�</th>
						<td  colspan="3">
							<div class="time_box">
								<div class="datePick">
									<span>
										<input type="text" class="datepicker" id="mentoring_day" name="mentoring_day" value="<%=mentoring_day%>" style="width:210px;">
										<button type="button" class="btncalendar dateclick">��¥����</button>
									</span>
								</div>

								<span class="selectbox" style="width:210px;">
									<span class="">����</span>
									<select id="mentoring_hour" name="mentoring_hour" title="�����">
										<option value="">����</option>
										<option value="09" <%If mentoring_hour = "09" Then%>selected="selected"<%End If%>>09��</option>
										<option value="10" <%If mentoring_hour = "10" Then%>selected="selected"<%End If%>>10��</option>
										<option value="11" <%If mentoring_hour = "11" Then%>selected="selected"<%End If%>>11��</option>
										<option value="12" <%If mentoring_hour = "12" Then%>selected="selected"<%End If%>>12��</option>
										<option value="13" <%If mentoring_hour = "13" Then%>selected="selected"<%End If%>>13��</option>
										<option value="14" <%If mentoring_hour = "14" Then%>selected="selected"<%End If%>>14��</option>
										<option value="15" <%If mentoring_hour = "15" Then%>selected="selected"<%End If%>>15��</option>
										<option value="16" <%If mentoring_hour = "16" Then%>selected="selected"<%End If%>>16��</option>
										<option value="17" <%If mentoring_hour = "17" Then%>selected="selected"<%End If%>>17��</option>
										<option value="18" <%If mentoring_hour = "18" Then%>selected="selected"<%End If%>>18��</option>
									</select>
								</span>
								<em>��</em>
								<span class="selectbox" style="width:210px;">
									<span class="">����</span>
									<select id="mentoring_min" name="mentoring_min" title="�����">
										<option value="">����</option>
										<option value="00" <%If mentoring_min = "00" Then%>selected="selected"<%End If%>>00��</option>
										<option value="30" <%If mentoring_min = "30" Then%>selected="selected"<%End If%>>30��</option>
									</select>
								</span>
								<em>��</em>
							</div>
						</td>
					</tr>
					<!--
					<tr>
						<th>Image (���λ���)</th>
						<td colspan="3">
							<div class="file_box">
								<input type="file" id="file_profile" name="file_profile">
								<span>5 MB������ jpg���Ϸ� ����� �ּ���. (image size 150 X 450)</span>
							</div>
						</td>
					</tr>
					-->
					<tr>
						<th>Image (ȸ��ΰ�)</th>
						<td colspan="3">
							<div class="file_box">
								<input type="hidden" name="str_file_com_logo" value="<%=file_com_logo%>">
								<input type="text" class="upload_name" id="upload_name" placeholder="�ΰ� ����� �ּ���." disabled="disabled" style="width:430px;" value="<%=file_com_logo%>">
								<label for="file_com_logo">���ε�</label>
								<span>5 MB������ jpg���Ϸ� ����� �ּ���. (image size 300 X 100)</span>
								<input type="file" id="file_com_logo" name="file_com_logo" onchange="fn_load_img(this);">
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_area right">
				<a href="mentor_list.asp" class="btn list">���</button>
				<a href="javascript:" class="btn blue" onclick="fn_submit();">��������</button>
				<a href="javascript:history.back();" class="btn gray">���</button>
			</div>
		</div><!-- list_area view -->
	</div><!-- //content -->
</div><!-- //contents -->
</form>
<!--// ������ -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->
</body>	
</html>