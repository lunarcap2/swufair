	//������ 1�� data list �� �����մϴ�.
	function getCtOptDepth1List() {
		var arrRet = new Array();
		var k = 0;
		for (var i = 0; i < cat_ct1.length; i++) {
			arrRet[k] = new Array();
			arrRet[k][0] = cat_ct1[i][0];
			arrRet[k][1] = cat_ct1[i][1];
			k++;
		}
		return arrRet;
	}
	//������ 2�� data list �� �����մϴ�.
	function getCtOptDepth2List(depthval1) {
		var arrRet = new Array();
		var k = 0;
		for (var i = 0; i < cat_ct2.length; i++) {
			if (cat_ct2[i][1] == depthval1) {
				arrRet[k] = new Array();
				arrRet[k][0] = cat_ct2[i][0];
				arrRet[k][1] = cat_ct2[i][2];
				k++;
			}
		}
		return arrRet;
	}
	//������ 3�� data list �� �����մϴ�.
	function getCtOptDepth3List(depthval1) {
		var arrRet = new Array();
		var k = 0;
		for (var i = 0; i < cat_ct3.length; i++) {
			if (cat_ct3[i][1] == depthval1) {
				arrRet[k] = new Array();
				arrRet[k][0] = cat_ct3[i][0];
				arrRet[k][1] = cat_ct3[i][2];
				k++;
			}
		}
		return arrRet;
	}
	
	// ����1�� ����Ʈ
	function fn_append_ct() {
		var arrCt1 = getCtOptDepth1List();
		var str = '';
		var k = 1;
		var key = 0;

		for (var i = 0; i < arrCt1.length; i++) {
			str += '<li><button type="button" class="button" onclick="fn_append_ct2(this, \'' + arrCt1[i][0] + '\')">' + arrCt1[i][1] + '</button></li>'
		}
		$('#col_ul_ct1').html(str);
		$('#col_ul_ct2').html("");
		$('#col_ul_ct3').html("");
	}
	// ����2�� ����Ʈ
	function fn_append_ct2(obj, val) {
		
		//��ü ����Ʈ class�ʱ�ȭ �� ���ÿ�� class on
		$('#col_ul_ct1').children().children().attr('class', 'button');
		$(obj).attr('class', 'button on');

		var arrCt2 = getCtOptDepth2List(val);
		var str = '';
		var k = 1;
		var key = 0;

		for (var i = 0; i < arrCt2.length; i++) {
			str += '<li>'
			str += '	<button class="" type="button" onclick="fn_append_ct3(this)" value="'+arrCt2[i][0] +'">'
			str += '		<span>'+ arrCt2[i][1] +'</span>'
			str += '	</button>'
			str += '	<label class="checkbox off" for="">'
			str += '		<input type="checkbox" id="" class="chk" onclick="fn_appand_ctkey2(this)" name="ctKeyWord2" value="'+ arrCt2[i][0] +'|'+ arrCt2[i][1] +'">'
			str += '	</label>'
			str += '</li>'
		}
		$('#col_ul_ct2').html(str);
		$('#col_ul_ct3').html("");

		//����2�� üũ
		var category_out_ct2_val = "";
		$('[name="category_out_ct2"]').each(function() {
			category_out_ct2_val += "," + this.value;
		});
		if (category_out_ct2_val != "") {
			$('[name="ctKeyWord2"]').each(function() {
				if (category_out_ct2_val.indexOf(this.value.split('|')[0]) > 0) {
					this.checked = true;
				}
			});
		}
		checkboxFnc();//üũ�ڽ�.
	}
	// ����3�� ����Ʈ
	function fn_append_ct3(obj) {

		//��ü ����Ʈ class�ʱ�ȭ �� ���ÿ�� class on
		$('#col_ul_ct2').children().children('button').attr('class', '');
		$(obj).attr('class', 'sel');

		var ct2_val, ct2_nm
		ct2_val = $(obj).val();
		ct2_nm = $(obj).children().html().trim();

		var arrCt3 = getCtOptDepth3List(ct2_val);
		var str = '';
		var k = 1;
		var key = 0;

		for (var i = 0; i < arrCt3.length; i++) {
			str += '<li>'
			str += '	<label class="checkbox off">'
			str += '		<input type="checkbox" class="chk" name="ctKeyWord3" onclick="fn_appand_ctkey3(this, \''+ ct2_val +'\', \''+ ct2_nm +'\')" value="'+arrCt3[i][0] +'">'
			str += '		<span>'+ arrCt3[i][1] +'</span>'
			str += '	</label>'
			str += '</li>'
		}
		$('#col_ul_ct3').html(str);

		//����3�� üũ
		var category_out_ct3_val = "";
		$('[name="category_out_ct3"]').each(function() {
			category_out_ct3_val += "," + this.value;
		});
		if (category_out_ct3_val != "") {
			$('[name="ctKeyWord3"]').each(function() {
				if (category_out_ct3_val.indexOf(this.value) > 0) {
					this.checked = true;
				}
			});
		}
		checkboxFnc();//üũ�ڽ�.
	}

	// ����2���ڵ� Ŭ��
	function fn_appand_ctkey2(obj) {
		var ct2_chk, ct2_val, ct2_nm
		ct2_chk = $(obj).is(":checked");
		ct2_val = $(obj).val().split('|')[0];
		ct2_nm = $(obj).val().split('|')[1];

		if (ct2_chk) {
			var ct2_chk_cnt = $('[name="category_out_ct2"]').length;
			if (ct2_chk_cnt >= 4) {
				$(obj).attr("checked", false);
				alert("��� ������ �ִ� 4������ ������ �����մϴ�.");
				return;
			} else {
				var up_html = '';
				up_html += '<li>'
				up_html += '	<div class="c_recommend"><span>'+ ct2_nm +'</span><button type="button" class="del" name="category_out_ct2" value="'+ ct2_val +'" onclick="fn_ctkey2_del(\''+ ct2_val +'\')">����</button></div>'
				up_html += '	<div class="c_jobs">'
				up_html += '		<ul>'
				up_html += '		</ul>'
				up_html += '	</div>'
				up_html += '</li>'
				$('#btm_category_ct').append(up_html);
			}
		} else { //����������
			fn_ctkey2_del(ct2_val);
		}
	}

	// ����3���ڵ� Ŭ��
	function fn_appand_ctkey3(obj, ct2_val, ct2_nm) {
		var ct3_chk, ct3_val, ct3_nm
		ct3_chk = $(obj).is(":checked");
		ct3_val = $(obj).val();
		ct3_nm = $(obj).next().html();

		if (ct3_chk) {

			var ct2_chk_cnt = $('[name="category_out_ct2"]').length;
			if (ct2_chk_cnt >= 4) {
				$(obj).attr("checked", false);
				alert("��� ������ �ִ� 4������ ������ �����մϴ�.");
				return;
			}

			var ct3_chk_cnt = $('[name="category_out_ct3"]').length;
			if (ct3_chk_cnt >= 10) {
				$(obj).attr("checked", false);
				alert("��� ����Ű����� �ִ� 10������ ������ �����մϴ�.");
				return;
			} else {
				var up_html = '';
				var ct2_cnt = 0;
				$('[name="category_out_ct2"]').each(function() {
					if (this.value == ct2_val) {
						ct2_cnt = ct2_cnt + 1;
						up_html += '			<li><span>'+ ct3_nm +'</span><button type="button" class="del" name="category_out_ct3" value="'+ ct3_val +'" onclick="fn_ctkey3_del(\''+ ct3_val +'\')">����</button></li>'
						$(this).parents('.c_recommend').next().children().append(up_html);
					}
				});

				if (ct2_cnt == 0) {
					up_html += '<li>'
					up_html += '	<div class="c_recommend">'
					up_html += '		<span>'+ ct2_nm +'</span>'
					up_html += '		<button type="button" class="del" name="category_out_ct2" value="'+ ct2_val +'" onclick="fn_ctkey2_del(\''+ ct2_val +'\')">����</button>'
					up_html += '	</div>'
					up_html += '	<div class="c_jobs">'
					up_html += '		<ul>'
					up_html += '			<li><span>'+ ct3_nm +'</span><button type="button" class="del" name="category_out_ct3" value="'+ ct3_val +'" onclick="fn_ctkey3_del(\''+ ct3_val +'\')">����</button></li>'
					up_html += '		</ul>'
					up_html += '	</div>'
					up_html += '</li>'
					$('#btm_category_ct').append(up_html);

					//���� 2�� üũ�ڽ�
					$('[name="ctKeyWord2"]').each(function() {
						if (this.value.split('|')[0] == ct2_val) {
							this.checked = true;
						}
					});
					checkboxFnc();//üũ�ڽ�.
				}
			}
		} else { //����������
			fn_ctkey3_del(ct3_val);
		}
	}

	// ����2�� ����
	function fn_ctkey2_del(_val) {
		// �ϴܺ� ���õ� ����ǥ�� ����
		$('[name="category_out_ct2"]').each(function() {
			if (this.value == _val) {
				$(this).parent().parent().remove();
			}
		});

		// ����2�� ���õ� üũ�ڽ� ����
		$('input:checkbox[name="ctKeyWord2"]').each(function() {
			if (this.value.split('|')[0] == _val) {
				this.checked = false;
			}
		});

		// ����3�� üũ�ڽ� ����
		$('input:checkbox[name="ctKeyWord3"]').each(function() {
			this.checked = false;
		});
		checkboxFnc();//üũ�ڽ�.
	}
	
	// ����3�� ����
	function fn_ctkey3_del(_val) {
		// �ϴܺ� ���õ� ����ǥ�� ����
		$('[name="category_out_ct3"]').each(function() {
			if (this.value == _val) {
				$(this).parent().remove();
			}
		});

		// �ϴܺ� 2��ǥ�� ����(���Ե� 3�� �������)
		$('[name="category_out_ct2"]').each(function() {
			if (this.value == _val.substring(0, 4)) {
				if ($(this).parent().next().children().children().length == 0) {
					fn_ctkey2_del(this.value);
				}
			}
		});

		// ����3�� ���õ� üũ�ڽ� ����
		$('input:checkbox[name="ctKeyWord3"]').each(function() {
			if (this.value == _val) {
				this.checked = false;
			}
		});
		checkboxFnc();//üũ�ڽ�.
	}


	// ����� ������ ����
	function fn_save_ct3_del(_obj, _val) {

		fn_ctkey3_del(_val);

		if ($(_obj).parent().parent().children().length == 1) {
			$(_obj).parents('.c_jobs').parent().remove();
		} else {
			$(_obj).parent().remove();
		}
	}
	function fn_save_ct2_del(_obj, _val) {
		$(_obj).parent().parent().remove();
		fn_ctkey2_del(_val);
	}

	// ���� �ʱ�ȭ
	function fn_reset_ct() {
		// �ϴܺ� ����ǥ�� �ʱ�ȭ
		$("#btm_category_ct").html("");
		// ����Ʈ �ʱ�ȭ
		$("#col_ul_ct2").html("");
		$("#col_ul_ct3").html("");
		fn_append_ct();
	}

	// ������ ��������
	function fn_save_ct() {
		var out_html = '';

		var set_ct2_cnt = $('[name="category_out_ct2"]').length;
		var set_ct3_cnt = $('[name="category_out_ct3"]').length;

		for (i=0; i<set_ct2_cnt; i++) {
			var resume_ct2 = $('[name="category_out_ct2"]').eq(i).val();
			var resume_ct2_nm = $('[name="category_out_ct2"]').eq(i).prev().html();

			out_html += '<li>'
			out_html += '	<div class="c_recommend"><span>'+ resume_ct2_nm +'</span><button type="button" onclick="fn_save_ct2_del(this, \''+ resume_ct2 +'\')">����</button></div>'
			out_html += '	<div class="c_jobs">'
			out_html += '		<ul>'
			out_html +=	'		<input type="hidden" name="resume_jobtype" value="'+ resume_ct2 +'">'
			for (j=0; j<set_ct3_cnt; j++) {
				var resume_ct3 = $('[name="category_out_ct3"]').eq(j).val();
				var resume_ct3_nm = $('[name="category_out_ct3"]').eq(j).prev().html();

				if (resume_ct2 == resume_ct3.substring(0, 4)) {
					out_html += '<li>'
					out_html += '<input type="hidden" name="ct_keyword" value="'+ resume_ct3 +'">'
					out_html += '<span>'+ resume_ct3_nm +'</span>'
					out_html += '<button type="button" onclick="fn_save_ct3_del(this, \''+ resume_ct3 +'\')">����</button>'
					out_html += '</li>'
				}
			}
			out_html += '		</ul>'
			out_html += '	</div>'
			out_html += '</li>'
		}
		$('#ul_place_ct').html(out_html);

		if (set_ct2_cnt > 0) {
			$('#c_head_ct_title').html("���");
		} else {
			$('#c_head_ct_title').html("");
		}
	}