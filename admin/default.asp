<%
option Explicit
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<%
' ������ ������ ��쿡�� ���� ���   
If Request.Cookies(site_code & "WKADMIN")("admin_id")="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If
%>
<script type="text/javascript">

</script>
</head>

<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- ������ -->
<div id="contents" class="admin">
	<div class="content">
		<div class="home_area">
			<div class="tit">
				<h3>���� ������ �ý���</h3>
			</div>

			<ul>
				<li>
					<div class="menu">
						<a href="/admin/board/board_list.asp">��������</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/user_list.asp">������û ��Ȳ</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/apply_list.asp">������ Ư��&��� ��û��</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/lcture_apply_list.asp">��.â��Ư�� ��û��</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/question_list.asp">��������</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/send_sms_list.asp">������ Ư��&��� ���ڹ߼�</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/lcture_send_sms_list.asp">��.â��Ư�� ���ڹ߼�</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/mentor_list.asp">������ Ư��&��� ��������</a>
					</div>
				</li>
				<li>
					<div class="menu">
						<a href="/admin/mentoring/lcture_list.asp">��.â��Ư�� ��� ����</a>
					</div>
				</li>
			</ul>
		</div>
	</div><!-- //content -->
</div>
<!--// ������ -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>
