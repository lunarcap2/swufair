$(document).ready(function () {

    $("#hp_num").bind("keyup keydown", function () {
        phoneFomatter(this);
    });

    $("#hp_num_biz").bind("keyup keydown", function () {
        phoneFomatter(this);
    });

});

function fieldChk_new(msg, f) {
    alert(msg);
    var off = $(f).offset();
    $('html, body').animate({
        scrollTop: off.top
    }, 200);
	$(f).focus();
}

//���ڸ� �Է�
function numkeyCheck(e) {
    var keyValue = event.keyCode;
    if ((keyValue >= 48) && (keyValue <= 57)) {
        return true;
    } else {
        alert('���ڸ� �Է� �����մϴ�.');
        return false;
    }
}

// ��ȭ��ȣ �ڸ���
function phoneFomatter(obj) {
    var formatNum = $(obj).val();
    formatNum = formatNum.replace(/-/gi, "");

    if (formatNum.length == 11) {
        formatNum = formatNum.replace(/([0-9]{3})([0-9]{4})([0-9]{4})/, "$1-$2-$3");;
    } else if (formatNum.length == 10) {
        if (formatNum.substring(0, 2) == '02') {
            formatNum = formatNum.replace(/(^02)([0-9]{4})([0-9]{4})/, "$1-$2-$3");;
        } else {
            formatNum = formatNum.replace(/([0-9]{3})([0-9]{3})([0-9]{4})/, "$1-$2-$3");;
        }
    } else {
        formatNum = formatNum.replace(/([0-9]{2})([0-9]{3})([0-9]{4})/, "$1-$2-$3");
    }

    $(obj).val(formatNum);
}

// ����ȸ�� ���̵� ã�� =========================================================================================

// Email ���� ��ȣ ����
function fnAuthemail() {
    if ($("#emailAuthNumChk").val() == "4") {
        alert("������ �Ϸ�Ǿ����ϴ�.");
        return;
    }

    $("#hd_idx").val("");

    var strEmail;
    if (Authchk_ing) {
        alert("ó���� �Դϴ�. ��ø� ��ٷ� �ּ���.");
    } else {
        $("#email").val($.trim($("#email").val()));
        $("#user_nm").val($.trim($("#user_nm").val()));

        if ($("#user_nm").val() == "") {
            alert("�̸��� �Է��� �ּ���.");
            $("#user_nm").focus();
            return;
        }  else {

            if ($("#email").val().length > 0) {
                var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
                if ($("#email").val().match(regExp) != null) {
                    strEmail = $("#email").val();
                } else {
                    alert('�̸����� ��Ȯ�ϰ� �Է��� �ּ���.');
                    $("#email").focus();
                    return;
                }
            } else {
                alert("�̸����� �Է��� �ּ���.");
                $("#email").focus();
                return;
            }
			
			$.ajax({
				type: "POST"
				, url: "/my/search/infoChk.asp"
				, data: {gubun: "User_E", user_nm: escape($("#user_nm").val()), email: strEmail }
				, dataType: "html"
				, async: true
				, success: function (data) {
					if (data != "1") {
						alert("ȸ�������� ���� �ʽ��ϴ�. \n�ٽ� �Է��� �ּ���.");
						return false;
					}
					else {
						Authchk_ing = true;
						var strUrl = "https://app.career.co.kr/sms/career/Authentication";
						var parm = {};
						parm.authCode = "2";//sms:1 /email:2
						parm.authvalue = strEmail;  //email �ּ�
						parm.username = $.trim($("#user_nm").val()); //�߼� �� �̸�
						parm.sitename = $.trim($("#site_short_name").val()); //�߼� ����(sms �߼۽� �ڵ� �߰� �˴ϴ�.)
						parm.sitecode = "37"; //sitecode(�� �ش� ����Ʈ �ڵ带 �Է��ϼ���) �߼� log �� email �߼۽� �����մϴ�.
						parm.memkind = "����";
						parm.ip = $("#userIP").val(); //���� IP 
						parm.callback = "jsonp_email_callback";
						$("#aEmail").text("������ȣ ������");
						$.ajax({
							url: strUrl
							, dataType: "jsonp"
							, type: "post"
							, data: parm
							, success: function (data) {
								//alert("sccess : " + data.length);
							}
							, error: function (jqXHR, textStatus, errorThrown) {
								//alert(textStatus + ", " + errorThrown);
							}
						});
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert("code:"+XMLHttpRequest.textStatus+"\n"+"message:"+XMLHttpRequest.responseText+"\n"+"error:"+errorThrown);
				}
			});
        }
    }
}

//Result ó���� �̰����� �մϴ�.
function jsonp_email_callback(data) {
    Authchk_ing = false;
    if ($.trim(data.result) == "true") {
        $("#emailAuthNumChk").val("1");

        $("#hd_idx").val(data.result_idx);
        alert("������ȣ�� �߼۵Ǿ����ϴ�.");
        $("#emailAuthNumber").val("");
        $("#emailAuthNumber").focus();
        $("#hd_kind").val("2");
    } else {
        $("#emailAuthNumChk").val("0");
        alert("������ȣ �߼��� �����Ͽ����ϴ�."); 
    }
}


//SMS ���� ��ȣ ����
function fnAuthSms() {

    if ($("#mobileAuthNumChk").val() == "4") {
        alert("������ �Ϸ�Ǿ����ϴ�.");
        return;
    }

    $("#hd_idx").val("");

    var strEmail;
    if (Authchk_ing) {
        alert("ó���� �Դϴ�. ��ø� ��ٷ� �ּ���.");
    } else {
		if ($("#user_nm").val() == "") {
			$("#ment_user_nm").text("�̸��� �Է��� �ּ���.");
			$("#ment_user_nm").show();
			$("#user_nm").focus();
            return;
        } else {
			$("#ment_user_nm").hide();
		}

		if ($("#hp_num").val() == "") {
			$("#ment_hp_num").text("�޴��� ��ȣ�� �Է��� �ּ���.");
			$("#ment_hp_num").show();
			$("#hp_num").focus();
			return;
		} else {
			$("#ment_hp_num").hide();
		}

		$.ajax({
			type: "POST"
			, url: "/my/search/infoChk.asp"
			, data: {gubun: "User_S", user_nm: escape($("#user_nm").val()), hp_num: $("#hp_num").val() }
			, dataType: "html"
			, async: true
			, success: function (data) {
				if (data != "1") {
					$("#ment_hp_num").text("ȸ�������� ���� �ʽ��ϴ�. �ٽ� �Է��� �ּ���.");
					$("#ment_hp_num").show();
					//alert("ȸ�������� ���� �ʽ��ϴ�. \n�ٽ� �Է����ּ���.");
					return false;
				} else {
					$("#ment_hp_num").hide();
					Authchk_ing = true;
					var strUrl = "https://app.career.co.kr/sms/career/Authentication";
					var parm = {};
					parm.authCode = "1";//sms:1 /email:2
					parm.authvalue = $("#hp_num").val(); //�ڵ��� no( - �� �Է� �ص� �ǰ� ���ص� �˴ϴ�.)
					parm.sitename = $.trim($("#site_short_name").val()); // sms �߼۽� �ش� �������� �Է� �˴ϴ�.
					parm.sitecode = "37"; //sitecode(�� �ش� ����Ʈ �ڵ带 �Է��ϼ���) �߼� log �� email �߼۽� �����մϴ�.
					parm.memkind = "����";
					parm.ip = $("#userIP").val(); //���� IP
					parm.callback = "jsonp_sms_callback";
					$("#aMobile").text("������ȣ ������");
					$.ajax({
						url: strUrl
						, dataType: "jsonp"
						, type: "post"
						, data: parm
						, success: function (data) {
							//alert("sccess : " + data.length);
						}
						, error: function (jqXHR, textStatus, errorThrown) {
							//alert(textStatus + ", " + errorThrown);
						}
					});
				}
			}
			, error: function (XMLHttpRequest, textStatus, errorThrown) {
				alert("code:"+XMLHttpRequest.textStatus+"\n"+"message:"+XMLHttpRequest.responseText+"\n"+"error:"+errorThrown);
			}
		});
    }
}

//Result ó���� �̰����� �մϴ�.
function jsonp_sms_callback(data) {
    Authchk_ing = false;

    if ($.trim(data.result) == "true") {
        $("#mobileAuthNumChk").val("1");
        $("#hp_count").show();
        fnDpFirst();
        fncDpTm(); //ī��Ʈ

        $("#hd_idx").val(data.result_idx);
        alert("������ȣ�� �߼۵Ǿ����ϴ�.");
		$("#rsltAuthArea").show();	// ������ȣ �Է¶� Ȱ��ȭ(���̵� ã��, ��й�ȣ ã��)
        $("#mobileAuthNumber").val("");
        $("#mobileAuthNumber").focus();
        $("#hd_kind").val("1");
    } else {
        $("#hp_count").hide();
        $("#emailAuthNumChk").val("0");
        alert("������ȣ �߼��� �����Ͽ����ϴ�."); 
    }
}

//������ȣ Ȯ��
function fnAuth() {
    if ($("#hd_kind").val() == "2" && $("#emailAuthNumChk").val() == "4") {
        alert("�̹� ������ �Ϸ�Ǿ����ϴ�.");
        return;
    } else if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
        alert("�̹� ������ �Ϸ�Ǿ����ϴ�.");
        return;
    }
	
	if ($.trim($("#hd_idx").val()) == "") {
        if ($("#hd_kind").val() == "1") {
            $('#alertBox_sms').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
			$('#alertBox_sms').show();
        } else {
            $('#alertBox_email').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
			$('#alertBox_email').show();
        }
        return;
    } else {
		$('#alertBox_sms').hide();
	}

    $("#emailAuthNumber").val($.trim($("#emailAuthNumber").val()));
    $("#mobileAuthNumber").val($.trim($("#mobileAuthNumber").val()));

    if ($("#hd_kind").val() == "2") {
        if ($.trim($("#emailAuthNumber").val()) == "") {
			$("#alertBox_sms").text("������ȣ�� �Է��� �ּ���.");
			$("#alertBox_sms").show();
            $("#emailAuthNumber").focus();
            return;
        } else {
			$("#alertBox_sms").hide();
		}

    }

    var strUrl = "https://app.career.co.kr/sms/career/AuthenticationResult";
    var parms = {};

    var strAuthKey = "";
    if ($("#hd_kind").val() == "2") {
        strAuthKey = $("#emailAuthNumber").val();
    } else if ($("#hd_kind").val() == "1") {
        strAuthKey = $("#mobileAuthNumber").val();
    } else {
        return;
    }

    if ($.trim($("#hd_idx").val()) == "" || ($.trim($("#emailAuthNumber").val()) == "" && $.trim($("#mobileAuthNumber").val()) == "")) {
        return;
    }
    parms.authCode = $("#hd_kind").val(); //sms:1 /email:2
    parms.authvalue = strAuthKey; //�߼۵� ���� KEY Value
    parms.idx = $("#hd_idx").val();//�߼۵� ���� ��ȣ
    parms.callback = "jsonp_result_callback";
    $.ajax({
        url: strUrl
			, dataType: "jsonp"
			, type: "post"
			, data: parms
			, success: function (data) {
			    alert("sccess : " + data.length);
			}
			, error: function (jqXHR, textStatus, errorThrown) {
			    //alert(textStatus + ", " + errorThrown);
			}
    });
}

function jsonp_result_callback(data) {
    if ($("#hd_kind").val() == "2") {
        if ($.trim(data.result_idx) == "Y") {
            $("#emailAuthNumChk").val("4");
            $("#alertBox_email").addClass('good').removeClass('bad');
            $('#alertBox_email').text("������ �Ϸ�Ǿ����ϴ�.");
        } else {
            $("#emailAuthNumChk").val("3");
            $("#alertBox_email").addClass('bad').removeClass('good');
            $('#alertBox_email').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
        }
    } else if ($("#hd_kind").val() == "1") {
        if ($.trim(data.result_idx) == "Y") {
            $("#mobileAuthNumChk").val("4");
			$("#alertBox_sms").addClass('good').removeClass('bad');
			$('#alertBox_sms').text("������ �Ϸ�Ǿ����ϴ�.");
			$('#alertBox_sms').show();
			$("#hp_count").hide();
			$("#ment_hp_num").hide();
        } else {
            $("#mobileAuthNumChk").val("3");
            $("#alertBox_sms").addClass('bad').removeClass('good');
            $('#alertBox_sms').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
			$('#alertBox_sms').show();
        }
    }
}
/* end */

// ���ȸ�� ======================================================================================


// Email ���� ��ȣ ����
function fnAuthemail_biz() {
    if ($("#emailAuthNumChk_biz").val() == "4") {
        alert("�̹� ������ �Ϸ�Ǿ����ϴ�.");
        return;
    }

    $("#hd_idx_biz").val("");

    var strEmail;
    if (Authchk_ing) {
        alert("ó���� �Դϴ�. ��ø� ��ٷ��ּ���.");
    } else {
        $("#email_biz").val($.trim($("#email_biz").val()));
        $("#comp_nm").val($.trim($("#comp_nm").val()));

        if ($("#comp_num").val() == "") {
            alert("����ڵ�Ϲ�ȣ�� �Է����ּ���.");
            $("#comp_num").focus();
            return;
        }

        if ($("#comp_nm").val() == "") {
            alert("�̸��� �Է����ּ���.");
            $("#comp_nm").focus();
            return;
        } else {

            if ($("#email_biz").val().length > 0) {
                var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
                if ($("#email_biz").val().match(regExp) != null) {
                    strEmail = $("#email_biz").val();
                } else {
                    alert('�̸����� ��Ȯ�ϰ� �Է����ּ���.');
                    $("#email_biz").focus();
                    return;
                }
            } else {
                alert("�̸����ּҸ� �Է����ּ���.");
                $("#email_biz").focus();
                return;
            }

			$.ajax({
				type: "POST"
				, url: "/my/search/infoChk.asp"
				, data: {gubun: "Biz_E", biz_num: $("#comp_num").val(), biz_nm: escape($("#comp_nm").val()), email: strEmail }
				, dataType: "html"
				, async: true
				, success: function (data) {
					if (data != "1") {
						alert("ȸ�������� ���� �ʽ��ϴ�. \n�ٽ� �Է��� �ּ���.");
						return false;
					}
					else {
						Authchk_ing = true;
						var strUrl = "https://app.career.co.kr/sms/career/Authentication";
						var parm = {};
						parm.authCode = "2";//sms:1 /email:2
						parm.authvalue = strEmail;  //email �ּ�
						parm.username = $.trim($("#comp_nm").val()); //�߼� �� �̸�
						parm.sitename = "�����ڴ��б� ���� Dream Festival"; //�߼� ����(sms �߼۽� �ڵ� �߰� �˴ϴ�.)
						parm.sitecode = "37"; //sitecode(�� �ش� ����Ʈ �ڵ带 �Է��ϼ���) �߼� log �� email �߼۽� �����մϴ�.
						parm.memkind = "����";
						parm.ip = ''; //���� IP 
						parm.callback = "jsonp_email_biz_callback";
						$("#aEmail_biz").text("������ȣ ������");
						$.ajax({
							url: strUrl
							, dataType: "jsonp"
							, type: "post"
							, data: parm
							, success: function (data) {
								//alert("sccess : " + data.length);
							}
							, error: function (jqXHR, textStatus, errorThrown) {
								//alert(textStatus + ", " + errorThrown);
							}
						});
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert("code:"+XMLHttpRequest.textStatus+"\n"+"message:"+XMLHttpRequest.responseText+"\n"+"error:"+errorThrown);
				}
			});
        }
    }
}

//Result ó���� �̰����� �մϴ�.
function jsonp_email_biz_callback(data) {
    Authchk_ing = false;
    if ($.trim(data.result) == "true") {
        $("#emailAuthNumChk_biz").val("1");
        $("#hd_idx_biz").val(data.result_idx);
        alert("������ȣ�� �߼۵Ǿ����ϴ�.");
		$('#aEmail_bizNum').show();
        $("#emailAuthNumber_biz").val("");
        $("#emailAuthNumber_biz").focus();
        $("#hd_kind_biz").val("2");
    } else {
        $("#emailAuthNumChk_biz").val("0");
        alert("������ȣ �߼��� �����Ͽ����ϴ�.");
    }
}


//SMS ���� ��ȣ ����
function fnAuthSms_biz() {
    if ($("#mobileAuthNumChk_biz").val() == "4") {
        alert("������ �Ϸ�Ǿ����ϴ�.");
        return;
    }

    $("#hd_idx_biz").val("");

    var strEmail;
    if (Authchk_ing) {
        alert("ó���� �Դϴ�. ��ø� ��ٷ� �ּ���.");
    } else {

        if ($("#hp_num_biz").val() == "") {
            alert("�޴��� ��ȣ�� �Է��� �ּ���.");
            $("#hp_num_biz").focus();
            return;
        } else {
			$.ajax({
				type: "POST"
				, url: "/my/search/infoChk.asp"
				, data: {gubun: "Biz_S", biz_num: $("#comp_num").val(), biz_nm: escape($("#comp_nm").val()), hp_num: $("#hp_num_biz").val() }
				, dataType: "html"
				, async: true
				, success: function (data) {
					if (data != "1") {
						alert("ȸ�������� ���� �ʽ��ϴ�. \n�ٽ� �Է����ּ���.");
						return false;
					}
					else {
						Authchk_ing = true;
						var strUrl = "https://app.career.co.kr/sms/career/Authentication";
						var parm = {};
						parm.authCode = "1";//sms:1 /email:2
						parm.authvalue = $("#hp_num_biz").val(); //�ڵ��� no( - �� �Է� �ص� �ǰ� ���ص� �˴ϴ�.)
						parm.sitename = "�����ڴ��б� ���� Dream Festival"; // sms �߼۽� �ش� �������� �Է� �˴ϴ�.
						parm.sitecode = "37"; //sitecode(�� �ش� ����Ʈ �ڵ带 �Է��ϼ���) �߼� log �� email �߼۽� �����մϴ�.
						parm.memkind = "����";
						parm.ip = "" //$("#userIP").val(); //���� IP
						parm.callback = "jsonp_sms_biz_callback";
						$("#aMobile_biz").text("������ȣ ������");
						$.ajax({
							url: strUrl
							, dataType: "jsonp"
							, type: "post"
							, data: parm
							, success: function (data) {
								//alert("sccess : " + data.length);
							}
							, error: function (jqXHR, textStatus, errorThrown) {
								//alert(textStatus + ", " + errorThrown);
							}
						});
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert("code:"+XMLHttpRequest.textStatus+"\n"+"message:"+XMLHttpRequest.responseText+"\n"+"error:"+errorThrown);
				}
			});
        }
    }
}

//Result ó���� �̰����� �մϴ�.
function jsonp_sms_biz_callback(data) {
    Authchk_ing = false;

    if ($.trim(data.result) == "true") {
        $("#mobileAuthNumChk_biz").val("1");
        $("#hp_count_biz").show();
        fnDpFirst();
        fncDpTm_biz(); //ī��Ʈ

        $("#hd_idx_biz").val(data.result_idx);
        alert("������ȣ�� �߼۵Ǿ����ϴ�.");
        $("#mobileAuthNumber_biz").val("");
        $("#mobileAuthNumber_biz").focus();
        $("#hd_kind_biz").val("1");
    } else {
        $("#hp_count_biz").hide();
        $("#emailAuthNumChk_biz").val("0");
        alert("������ȣ �߼��� �����Ͽ����ϴ�.");
    }
}

//������ȣ Ȯ��
function fnAuth_biz() {
    if ($("#hd_kind_biz").val() == "2" && $("#emailAuthNumChk_biz").val() == "4") {
        alert("�̹� ������ �Ϸ�Ǿ����ϴ�.");
        return;

    } else if ($("#hd_kind_biz").val() == "1" && $("#mobileAuthNumChk_biz").val() == "4") {
        alert("�̹� ������ �Ϸ�Ǿ����ϴ�.");
        return;

    } else if ($.trim($("#hd_idx_biz").val()) == "") {
        if ($("#hd_kind_biz").val() == "1") {
            $('#alertBox_sms_biz').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
        } else {
            $('#alertBox_email_biz').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
        }
        return;
    }

    $("#emailAuthNumber_biz").val($.trim($("#emailAuthNumber_biz").val()));
    $("#mobileAuthNumber_biz").val($.trim($("#mobileAuthNumber_biz").val()));

    if ($("#hd_kind_biz").val() == "2") {
        if ($.trim($("#emailAuthNumber_biz").val()) == "") {
            alert("������ȣ�� �Է��� �ּ���.");
            $("#emailAuthNumber_biz").focus();
            return;
        }
    } else if ($("#hd_kind_biz").val() == "1") {
        if ($.trim($("#mobileAuthNumber_biz").val()) == "") {
            alert("������ȣ�� �Է��� �ּ���.");
            $("#mobileAuthNumber_biz").focus();
            return;
        }
    }

    var strUrl = "https://app.career.co.kr/sms/career/AuthenticationResult";
    var parms = {};

    var strAuthKey = "";
    if ($("#hd_kind_biz").val() == "2") {
        strAuthKey = $("#emailAuthNumber_biz").val();
    } else if ($("#hd_kind_biz").val() == "1") {
        strAuthKey = $("#mobileAuthNumber_biz").val();
    } else {
        return;
    }

    if ($.trim($("#hd_idx_biz").val()) == "" || ($.trim($("#emailAuthNumber_biz").val()) == "" && $.trim($("#mobileAuthNumber_biz").val()) == "")) {
        return;
    }
    parms.authCode = $("#hd_kind_biz").val(); //sms:1 /email:2
    parms.authvalue = strAuthKey; //�߼۵� ���� KEY Value
    parms.idx = $("#hd_idx_biz").val();//�߼۵� ���� ��ȣ
    parms.callback = "jsonp_result_biz_callback";
    $.ajax({
        url: strUrl
			, dataType: "jsonp"
			, type: "post"
			, data: parms
			, success: function (data) {
			    //alert("sccess : " + data.length);
			}
			, error: function (jqXHR, textStatus, errorThrown) {
			    //alert(textStatus + ", " + errorThrown);
			}
    });
}

function jsonp_result_biz_callback(data) {
    if ($("#hd_kind_biz").val() == "2") {
        if ($.trim(data.result_idx) == "Y") {
            $("#emailAuthNumChk_biz").val("4");
            $("#alertBox_email_biz").addClass('good').removeClass('bad');
            $('#alertBox_email_biz').text("������ �Ϸ�Ǿ����ϴ�.");
        } else {
            $("#emailAuthNumChk_biz").val("3");
            $("#alertBox_email_biz").addClass('bad').removeClass('good');
            $('#alertBox_email_biz').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
        }
    } else if ($("#hd_kind_biz").val() == "1") {
        if ($.trim(data.result_idx) == "Y") {
            $("#mobileAuthNumChk_biz").val("4");
            $("#alertBox_sms_biz").addClass('good').removeClass('bad');
            $('#alertBox_sms_biz').text("������ �Ϸ�Ǿ����ϴ�.");
            $("#hp_count_biz").hide();
        } else {
            $("#mobileAuthNumChk_biz").val("3");
            $("#alertBox_sms_biz").addClass('bad').removeClass('good');
            $('#alertBox_sms_biz').text("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
        }
    }
}

// ======================================================================================

var emailchk_ing = false;
var Authchk_ing = false;

var min = 60;
var sec = 60;
var ctm; // ǥ�� �ð�
var inputtime = 3;//�Էº�
var tstop;//Ÿ�̸� ����

Number.prototype.dptm = function () { return this < 10 ? '0' + this : this; } //�п� "0" �ֱ�

function fnDpFirst() {
    clearTimeout(tstop);
    ctm = sec * inputtime;
}

function fncDpTm() {
    var cmi = Math.floor((ctm % (min * sec)) / sec).dptm();
    var csc = Math.floor(ctm % sec).dptm();
    $("#hp_count").text('(' + cmi + ' : ' + csc + ")");
    if ((ctm--) <= 0) {
        ctm = sec * inputtime;
        clearTimeout(tstop);
        //�����۹�ư
        //�����ð� �ʰ� meassage
    }
    else {
        tstop = setTimeout("fncDpTm()", 1000);
    }
}

function fncDpTm_biz() {
    var cmi = Math.floor((ctm % (min * sec)) / sec).dptm();
    var csc = Math.floor(ctm % sec).dptm();
    $("#hp_count_biz").text('(' + cmi + ' : ' + csc + ")");
    if ((ctm--) <= 0) {
        ctm = sec * inputtime;
        clearTimeout(tstop);
        //�����۹�ư
        //�����ð� �ʰ� meassage
    }
    else {
        tstop = setTimeout("fncDpTm_biz()", 1000);
    }
}

// ====================================================================================

function onSubmit_ID(gubun) {
    var AuthValue = '';

    if (gubun == 'USER') {
		
        if ($('#user_nm').val() == '') {
			$("#ment_user_nm").text("�̸��� �Է��� �ּ���.");
			$("#ment_user_nm").show();
			$("#user_nm").focus();
            return;
        } else {
			$("#ment_user_nm").hide();
		}

		AuthValue = $('#hp_num').val();		
		
		if (AuthValue==""){	
			$("#ment_hp_num").text("�޴�����ȣ�� �Է��� �ּ���.");
			$("#ment_hp_num").show();
			$("#hp_num").focus();
			return;
		} else {
			if ($("#mobileAuthNumChk").val() != "4") {
				alert("�޴�����ȣ�� ������ �ּ���.");
				$("#ment_hp_num").text("�޴�����ȣ�� ������ �ּ���.");
				$("#ment_hp_num").show();
				return;
			} else {
				$("#ment_hp_num").hide();
			}
		}
		
		/*
		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			AuthValue = $('#hp_num').val();
			$("#alertBox_sms").hide();
		} else if ($("#hd_kind").val() == "2" && $("#emailAuthNumChk").val() == "4") {
			AuthValue = $('#email').val();
		} else {
			$("#alertBox_sms").text("�������� �ʾҽ��ϴ�.");
			$("#alertBox_sms").show();
			return;
		}
		*/

        $.ajax({
            type: "POST"
            , url: "/my/search/searchID_find.asp"
            , data: { user_nm: $("#user_nm").val(), authType: $('#hd_kind').val(), AuthValue: AuthValue }
			//, data: { user_nm: $("#user_nm").val(), authType: '2', AuthValue: 'dblee@career.co.kr' }
            , dataType: "html"
            , async: true
            , success: function (data) {
//				console.log(data);
				var result = data.split("|");
				if (result[0] == "1") {
					$("#result_id").val(result[1]);
					$("#result_date").val(result[2]);
					
					$("#frm").attr("action", "/my/search/searchID_result.asp");
					$("#frm").submit();
				} else {
					alert("��ġ�ϴ� ȸ���� �����ϴ�.");					
				}
            }
            , error: function (XMLHttpRequest, textStatus, errorThrown) {
               alert("������ �߻��Ͽ����ϴ�.\n" + XMLHttpRequest.responseText);
            }
        });
    } else if (gubun == 'Biz') {

        if ($("#comp_num").val() == "") {
            alert('����� ��Ϲ�ȣ�� �Է��� �ּ���.');
            return;
        }

        if ($('#comp_nm').val() == '') {
            fieldChk_new("�̸��� �Է��� �ּ���.", $("#comp_nm"));
            return;
        }

        if ($("#hd_kind_biz").val() == "1" && $("#mobileAuthNumChk_biz").val() == "4") {
            AuthValue = $('#hp_num_biz').val();
        } else if ($("#hd_kind_biz").val() == "2" && $("#emailAuthNumChk_biz").val() == "4") {
            AuthValue = $('#email_biz').val();
        } else {
            alert('�������� �ʾҽ��ϴ�.');
            return;
        }

        $.ajax({
            type: "POST"
            , url: "/company/search/searchID_find.asp"
            , data: { comp_type : $('#comp_type').val(), comp_num: $("#comp_num").val(), comp_nm: $("#comp_nm").val(), authType: $('#hd_kind_biz').val(), AuthValue: AuthValue }
			//, data: { comp_type : $('#comp_type').val(), comp_num: $("#comp_num").val(), comp_nm: $("#comp_nm").val(), authType: '2', AuthValue: 'dblee@career.co.kr' }
            , dataType: "html"
            , async: true
            , success: function (data) {
                //displayFnc('#addInfoComp', 'block');
				fn_pop_show();
                $('#compid_list').html(data);
            }
            , error: function (XMLHttpRequest, textStatus, errorThrown) {
                //console.log(XMLHttpRequest.responseText);
            }
        });
    }
}

function onSubmit_PW(gubun) {
    var AuthValue = '';
    var user_id = '';

    if (gubun == 'USER') {
        if ($('#user_id').val() == '') {
			$("#ment_user_id").text("���̵� �Է��� �ּ���.");
			$("#ment_user_id").show();
			$("#user_id").focus();
            return;
        } else {
			$("#ment_user_id").hide();
		}

        user_id = $('#user_id').val() + '_wk';

        if ($('#user_nm').val() == '') {
			$("#ment_user_nm").text("�̸��� �Է��� �ּ���.");
			$("#ment_user_nm").show();
			$("#user_nm").focus();
            return;
        }

		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			AuthValue = $('#hp_num').val();
		} else if ($("#hd_kind").val() == "2" && $("#emailAuthNumChk").val() == "4") {
			AuthValue = $('#email').val();
		} else {
			alert('�޴�����ȣ�� ������ �ּ���.');
			return;
		}

		$.ajax({
			type: "POST"
			, url: "/my/search/searchPW_find.asp"
			, data: { user_nm: $("#user_nm").val(), authType: $('#hd_kind').val(), AuthValue: AuthValue, user_id: user_id, idxNum: $('#hd_idx').val() }
			, dataType: "html"
			, async: true
			, success: function (data) {
				if (data.trim() != '') {
					$.ajax({
					   type: "POST"
					   , url: "/my/search/searchPW_find_authchk.asp"
					   , data: { authType: $('#hd_kind').val(), AuthNumber: $('#hd_idx').val(), user_id: user_id }
					   , dataType: "html"
					   , async: true
					   , success: function (data) {
							console.log("2������ : " + data);
							if (data.trim() != '') {

								$("#result_id").val(user_id);
								$("#result_auth_type").val($('#hd_kind').val());
								$("#result_auth_value").val($('#hd_idx').val());
								
								$("#frm").attr("action", "/my/search/searchPW_setpw.asp");
								$("#frm").submit();

							} else {
								alert('�������� ���� �����Դϴ�.');
							}
					   }
					   , error: function (XMLHttpRequest, textStatus, errorThrown) {
						   //console.log(XMLHttpRequest.responseText);
					   }
					});

			   } else {
				   alert('��ϵ� ������ �����ϴ�.');
			   }
		   }
		   , error: function (XMLHttpRequest, textStatus, errorThrown) {
			   //console.log(XMLHttpRequest.responseText);
		   }
		});
    } else if (gubun == 'Biz') {
        if ($("#comp_num").val() == "") {
            fieldChk_new('����� ��Ϲ�ȣ�� �Է��� �ּ���.', $("#comp_num"));
            return;
        }

        if ($("#com_id").val() == "") {
            fieldChk_new('���̵� �Է��� �ּ���.', $("#com_id"));
            return;
        }

        if ($('#comp_nm').val() == '') {
            fieldChk_new("�̸��� �Է��� �ּ���.", $("#comp_nm"));
            return;
        }

        if ($("#hd_kind_biz").val() == "1" && $("#mobileAuthNumChk_biz").val() == "4") {
            AuthValue = $('#hp_num_biz').val();
        } else if ($("#hd_kind_biz").val() == "2" && $("#emailAuthNumChk_biz").val() == "4") {
            AuthValue = $('#email_biz').val();
        } else {
            alert('�������� �ʾҽ��ϴ�.');
            return;
        }

        $.ajax({
            type: "POST"
            , url: "/company/search/searchPW_find.asp"
            , data: { com_type: $('#comp_type').val(), comp_num: $("#comp_num").val(), comp_nm: $("#comp_nm").val(), authType: $('#hd_kind_biz').val(), AuthValue: AuthValue, com_id: $('#com_id').val() }
			//, data: { com_type: $('#comp_type').val(), comp_num: $("#comp_num").val(), comp_nm: $("#comp_nm").val(), authType: '2', AuthValue: 'dblee@career.co.kr', com_id: $('#com_id').val() }
            , dataType: "html"
            , async: true
            , success: function (data) {
                //displayFnc('#addInfoComp', 'block');
				fn_pop_show();
                $('#compid_list').html(data);
            }
            , error: function (XMLHttpRequest, textStatus, errorThrown) {
                //console.log(XMLHttpRequest.responseText);
            }
        });
    }
}

function PW_Modify(gubun) {
    var authValue, authType, user_id;

    if (gubun == 'USER') {
		/*
        if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
            authValue = $('#hp_num').val();
            authType = "1";
        } else if ($("#hd_kind").val() == "2" && $("#emailAuthNumChk").val() == "4") {
            authValue = $('#email').val();
            authType = "0";
        } else {
            alert('�������� �ʾҽ��ϴ�.');
            return;
        }
		*/
		
		user_id		= $('#user_id').val();
		authType	= $('#authType').val();
		authValue	= $('#authValue').val();

        if ($('#new_pw1').val().length == 0) {
			$("#ment_new_pw1").text("��й�ȣ�� �Է��� �ּ���.");
			$("#ment_new_pw1").show();
			$("#new_pw1").focus();
            return;
        } else {
			$("#ment_new_pw1").hide();
		}
		
		if (!Validchar($('#new_pw1').val(), num + alpha + etc)) {
			$("#ment_new_pw1").text("����� �� ���� ��й�ȣ�Դϴ�.");
			$("#ment_new_pw1").show();
			$("#new_pw1").focus();
            return;
        } else {
			$("#ment_new_pw1").hide();
        }

		var pwdChk = new PwdChecker();
		if (!pwdChk.mainProgress($("#user_id").val(), $('#new_pw1').val())) {
			return;
		}


		if ($('#new_pw2').val().split(" ").join("") == "") {
			$("#ment_new_pw2").text("��й�ȣ Ȯ���� �Է��� �ּ���.");
			$("#ment_new_pw2").show();
			$("#new_pw2").focus();
            return;
        } else {
			$("#ment_new_pw2").hide();
		}	
		
		if ($('#new_pw1').val() != $('#new_pw2').val()) {
			/*$("#ment_new_pw2").text("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
			$("#ment_new_pw2").show();*/
			alert("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
			$("#new_pw2").focus();
            return;
        } else {
			$("#ment_new_pw2").hide();
		}

        $.ajax({
            type: "POST"
            , url: "/my/search/searchPW_update.asp"
            , data: { authType: authType, authValue: authValue, user_id: user_id, user_pw: $('#new_pw1').val() }
            , dataType: "html"
            , async: true
            , success: function (data) {				
                alert("��й�ȣ�� ����Ǿ����ϴ�.\n�α��� �������� �̵��մϴ�.");
                location.href = '/my/login.asp';
            }
            , error: function (XMLHttpRequest, textStatus, errorThrown) {
                //console.log(XMLHttpRequest.responseText);
            }
        });
    } else if (gubun == 'Biz') {

        if ($("#hd_kind_biz").val() == "1" && $("#mobileAuthNumChk_biz").val() == "4") {
            authValue = $('#hp_num_biz').val();
        } else if ($("#hd_kind_biz").val() == "2" && $("#emailAuthNumChk_biz").val() == "4") {
            authValue = $('#email_biz').val();
        } else {
            alert('�������� �ʾҽ��ϴ�.');
            return;
        }

        if ($('#new_pw1_biz').val().length == 0) {
            alert('��й�ȣ�� �Է��� �ּ���.');
            return;
        } else if (!Validchar($('#new_pw1_biz').val(), num + alpha + etc)) {
            alert("����� �� ���� ��й�ȣ�Դϴ�.");
            return;
        } else {
            var pwdChk = new PwdChecker();
            if (!pwdChk.mainProgress($("#com_id").val(), $('#new_pw1_biz').val())) {
                return;
            }
        }

        if ($('#new_pw2_biz').val().split(" ").join("") == "") {
            alert("��й�ȣ Ȯ���� �Է��� �ּ���.");
            return;
        } else if ($('#new_pw1_biz').val() != $('#new_pw2_biz').val()) {
            alert("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
            return;
        }

        $.ajax({
            type: "POST"
            , url: "/company/search/searchPW_update.asp"
            , data: { type: $('#comp_type').val(), com_id : $('#com_id').val(), newpw: $('#new_pw1_biz').val() }
            , dataType: "html"
            , async: true
            , success: function (data) {
                if (data.trim() == '1') {
                    alert("��й�ȣ�� ����Ǿ����ϴ�.\n\n�α��� �������� �̵��մϴ�.");
                    location.href = '/company/login.asp';
                } 
            }
            , error: function (XMLHttpRequest, textStatus, errorThrown) {
                //console.log(XMLHttpRequest.responseText);
            }
        });
    }
}

// ��й�ȣ ��ȿ�� �˻� ================================================================================================

var pwdMsg = "�Է��Ͻ� ��й�ȣ�� ���Ȼ� �ſ� ����մϴ�.\n8~32�ڱ��� ����, ����, Ư������ ���� ��������\n���̵�� ������ ���ڿ��� �Է����ּ���.";
var blockWord = new Array();
blockWord.push("dfdf");
blockWord.push("asdf");
blockWord.push("123123");

PwdChecker = function () {
}

PwdChecker.prototype.mainProgress = function (id, pw) {
    if (pw.length < 8 || pw.length > 32) {
		$("#ment_new_pw1").text("��й�ȣ�� 8~32�� ������ ���˴ϴ�.");
		$("#ment_new_pw1").show();
		$("#new_pw1").focus();
        return false;
    } else {
		$("#ment_new_pw1").hide();
	}

    if (!pw.match(/([a-zA-Z].*[0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[0-9].*[a-zA-Z])/)) {
		$("#ment_new_pw1").text("��й�ȣ�� ����,����,Ư�������� �����̾�� �մϴ�.");
		$("#ment_new_pw1").show();
		$("#new_pw1").focus();
        return false;
    } else {
		$("#ment_new_pw1").hide();
	}

    if (!this.step1Check(id, pw)
		|| !this.step2Check(pw)
		|| !this.step3Check(pw)
		|| !this.step4Check(id, pw)) {
		$("#ment_new_pw1").text("����� �� ���� ��й�ȣ�Դϴ�.");
		$("#ment_new_pw1").show();
		$("#new_pw1").focus();
        return false;
    } else {
		$("#ment_new_pw1").hide();
		return true;
    }
}

//ID�� ��ġ�� �˻�
PwdChecker.prototype.step1Check = function (id, pw) {
    if (id.indexOf(pw) != -1) {
        return false;
    }
    if (pw.indexOf(id) != -1) {
        return false;
    }
    return true;
}

//���Ӽ��� ���� �� ������ �˻�
PwdChecker.prototype.step2Check = function (pw) {
	 var cnt = 0;
	 var cnt2 = 0;
	 var tmp = "";
	 var tmp2 = "";
	 var tmp3 = "";

	 for(i=0; i<pw.length; i++) {
		 tmp = pw.charAt(i);
		 tmp2 = pw.charAt(i+1);
		 tmp3 = pw.charAt(i+2);
		 
		 if(tmp.charCodeAt(0) - tmp2.charCodeAt(0) == 1 && tmp2.charCodeAt(0) - tmp3.charCodeAt(0) == 1) {
			 cnt = cnt + 1;
		 }
		 
		 if(tmp.charCodeAt(0) - tmp2.charCodeAt(0) == -1 && tmp2.charCodeAt(0) - tmp3.charCodeAt(0) == -1) {
			 cnt2 = cnt2 + 1;
		 }
	 }

	 if(cnt > 0 || cnt2 > 0) {
		 return false;
	 }else {
		 return true;
	 }

	 for (var i = 0; i < blockWord.length; i++) {
        if (pw.indexOf(blockWord[i]) != -1) {
            return false;
        }
	 }
}

//������ ��,�� ���ڰ� 4�� �̻󿩺� �˻�
PwdChecker.prototype.step3Check = function (pw) {
    var cnt = 1;
    for (var i = 0; i < pw.length - 1; i++) {
        if (this.compare3(pw, i)) {
            ++cnt;
        } else {
            cnt = 1;
        }
        if (cnt > 3) {
            return false;
        }
    }
    return true;
}

//�н����尡 ���̵� ���� �ܾ�� �˻�
PwdChecker.prototype.step4Check = function (id, pw) {
    return this.compare4(pw, 0, id, 0);
}

PwdChecker.prototype.compare3 = function (pw, i) {
    return pw.charAt(i) == pw.charAt(i + 1);
}

PwdChecker.prototype.compare4 = function (pw, i, id, j) {
    if (i >= pw.length) return false;
    var _pw = pw.charAt(i);
    var _id = id.substring(j);
    var k = _id.indexOf(_pw);
    if (k == -1) return true;
    return this.compare4(pw, i + 1, id, k + 1);
}

// ���� üũ
var num = "0123456789";
var alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
var etc = "-_.!@#$%^&*?~";

function Validchar(g, str) {
    for (var i = 0; i < g.length; i++) {
        if (str.indexOf(g.charAt(i)) == -1)
            return false;
    }
    return true;
}