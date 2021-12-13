$(function() {
	$(document).ready(function() {
		//tabFnc();//��
		accordionFnc();//���ڵ��
        selectboxFnc();//����Ʈ�ڽ�
		selectDown();//����Ʈ�� UL
		showBox();//click �ڽ� Show or hidden
        checkboxFnc();//üũ�ڽ�.
		chkpassFnc();//üũ�ڽ� ��й�ȣ ���̱�/���߱�
        radioboxFnc();//�����ڽ�
		popUp();//�˾�

		//if ($('input.placehd, textarea.placehd').length > 0) $('input.placehd, textarea.placehd').placeholder();//input,textarea placehd
		if ($('.datepicker').length > 0) useDatePicker();//�޷�
	});
	
	tabFnc = function(){
		$(".tab_content").hide();
		$(".tabs li:first").addClass("on").show();
		$(".tab_content:first").show();

		$(".tabs li").click(function() {
			$(".tabs li").removeClass("on");
			$(".acco li a").removeClass("on")
			$(".acco_txt").hide();
			$(this).addClass("on"); 
			$(".tab_content").hide();
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).fadeIn();
			return false;
		});
	}//��

	accordionFnc = function(){
		$(".acco li a").click(function(){
			$(this).toggleClass('on');
			$(this).next().slideToggle(300);
			$(".acco li a").not(this).next().slideUp(300);
			$(".acco li a").not(this).removeClass('on');
			return false;
		});
	}//���ڵ��

	selectboxFnc = function (obj) {
		var _select = null
		if (!obj)
			_select = $('.selectbox select');
		else
			_select = ($(obj).find('.selectbox select').length > 0) ? $(obj).find('.selectbox select') : $(obj);
		_select.unbind().each(function (index, value) {
			$(this).prev().html($(this).children('option:selected').text());
			if ($(this).val() == 'direct') {//�����Է�
				$(this).parent().prev().css('display', 'inline');
			}
		}).bind('change keyup', function (evt) {
			$(this).prev().html($(this).children('option:selected').text());
			if ($(this).prev().is('.ellipsis')) $(this).prev().ellipsis();//������ ����
			if ($(this).find("option[value='direct']").length == 1) {//�����Է� ����
				if ($(this).val() == 'direct') {
					$(this).parent().prev().css('display', 'inline');
					if (evt.type == 'change') $(this).parent().prev().focus();//�����Է� ��Ŀ�� �̵�
				} else {
					$(this).parent().prev().css('display', 'none');
				}
			}
		}).bind('focus', function () {
			$(this).prev().addClass('on');
		}).bind('blur', function () {
			$(this).prev().removeClass('on');
		});
	}//����Ʈ�ڽ�

	selectDown = function() {
		$(".select_box .name a").click(function() {
			$(this).parents('.name').next('.sel').find('ul').show();
		});
					
		$(".select_box .sel ul li a").click(function() {
			var text = $(this).html();
			$(this).parents('.sel').prev('.name').find('span').html(text);
			$(this).parents('.sel').find('ul').hide();
		});

		$(document).bind('click', function(e) {
			var $clicked = $(e.target);
			if (! $clicked.parents().hasClass("select_box"))
				$(".select_box .sel ul").hide();
		});			
	}//����Ʈ�� UL

	showBox = function() {
		$(".show_box .name a").click(function() {
			$(this).parents('.name').next('.sel').find('ul').show();
		});
					
		$(".show_box .sel ul li a").click(function() {
			$(this).parents('.sel').find('ul').hide();
		});

		$(document).bind('click', function(e) {
			var $clicked = $(e.target);
			if (! $clicked.parents().hasClass("show_box"))
				$(".show_box .sel ul").hide();
		});			
	}// click �ڽ� Show or hidden

    checkboxFnc = function () {//üũ�ڽ�
        var _chk = $('.chk').parent();
        _chk.each(function() {
            if ($(this).find('input').is(':checked')) {
                $(this).removeClass('off').addClass('on');

            } else {
                $(this).removeClass('on').addClass('off');
            }
        }).click(function() {
            if ($(this).find('input').is(':checked')) {
                $(this).removeClass('off').addClass('on');
            } else {
                $(this).removeClass('on').addClass('off');
            }
        });
    }//üũ�ڽ�

	chkpassFnc = function () {
		$("#passChk").change(function(){
			// Check the checkbox state
			if($(this).is(':checked')){
				// Changing type attribute
				$("#inPass").attr("type","text");

				// Change the Text
				//$(".pass_txt").text("��й�ȣ ���̱�");
			}else{
				// Changing type attribute
				$("#inPass").attr("type","password");

				// Change the Text
				//$(".pass_txt").text("��й�ȣ ���߱�");
			}
		});
	} //�н����� ���̱�/���߱�

    radioboxFnc = function () {

		//��Ȱ��ȭ Ŭ������
		$(".disable").attr("readonly",true);
		$(".disable").attr("disabled",true);

        var _rdi = $('.rdi').parent();
        _rdi.unbind().each(function() {
            if ($(this).find('input').is(':checked')) {
                $(this).removeClass('off').addClass('on');
            }else if ($(this).find('input').is('[disabled=disabled]'))//��Ȱ��ȭ��ų��
			{
				$(this).find("span").css({'color':'#a8a8a8','cursor':'default'});
				$(this).find('input').attr('name','disable')
			} else {
                $(this).removeClass('on').addClass('off');
            }
        }).bind('click', function() {
            var _name = $(this).find('input').attr('name');
            var _radio = $('label input[name$='+_name+']');
            var _index = _radio.parent().index(this);
            _radio.each(function(index, value) {
                if (_index == index) {
                    $(this).checked = true;
                    $(this).parent().removeClass('off').addClass('on');
					if ($(this).is('[disabled=disabled]'))
					{
						$(this).parent().removeClass('on');
					}
                } else {
                    $(this).checked = false;
                    $(this).parent().removeClass('on').addClass('off');
                }
            });
        });
        
        $('input:radio').click(function() {
            $('input:radio[name='+$(this).attr('name')+']').parent().removeClass('on');
            $(this).parent().addClass('on');
        });
		
    }//�����ڽ�

	popUp = function(){//���̾��˾�*/
		$openPop = $(".pop");
		$closePop = $(".pop_up .btn.close, .pop_up .pop_close");

		$openPop.click(function(){
			var popHref = $(this).attr("href");
			$(popHref).show().find(".dim").show();
		});

		$closePop.click(function(){
			$(this).parents(".pop_up").hide().find(".dim").hide();
		});

	}//���̾��˾�*/

	useDatePicker = function() {
	
		$(document).ready(function() {

			//datepicker �ѱ���� ����ϱ� ���� ����
			$.datepicker.setDefaults($.datepicker.regional['ko']);     
		
			// Datepicker
			$(".datepicker.only").datepicker({
				dateFormat: "yy-mm-dd",
				dayNamesMin: ["��", "��", "ȭ", "��", "��", "��", "��"],
				monthNames: ["1��", "2��", "3��", "4��", "5��", "6��", "7��", "8��", "9��", "10��", "11��", "12��"],
				monthNamesShort: ["1��", "2��", "3��", "4��", "5��", "6��", "7��", "8��", "9��", "10��", "11��", "12��"],
				changeMonth: true,
				changeYear: true,
				showButtonPanel: true,
				closeText: '�ݱ�',
				currentText: '����',

			});

			$(".datepicker.two").datepicker({
				dateFormat: "yy-mm-dd",
				dayNamesMin: ["��", "��", "ȭ", "��", "��", "��", "��"],
				monthNames: ["1��", "2��", "3��", "4��", "5��", "6��", "7��", "8��", "9��", "10��", "11��", "12��"],
				monthNamesShort: ["1��", "2��", "3��", "4��", "5��", "6��", "7��", "8��", "9��", "10��", "11��", "12��"],
				changeMonth: true,
				changeYear: true,
				showButtonPanel: true,
				closeText: '�ݱ�',
				currentText: '����',
				onClose : function ( selectedDate ) {
					var eleId = $(this).attr("id");
					var optionName = "";
					if(eleId.indexOf("StartDate") > 0) {
						eleId = eleId.replace("StartDate", "EndDate");
						optionName = "minDate";
					} else {
						eleId = eleId.replace("EndDate", "StartDate");
						optionName = "maxDate";
					}
					$("#"+eleId).datepicker( "option", optionName, selectedDate);        
					$(".searchDate").find(".chkbox2").removeClass("on"); 

					var $dates = $('.start_date, .end_date').datepicker();
					$('.datePick .reset').on('click', function () {	
						 $dates.val('').datepicker('option', {minDate: null, maxDate: null});
					});
				}
			});

			$.datepicker._gotoToday = function(id) { 
				$(id).datepicker('setDate', new Date()).datepicker('hide').blur(); 
			};

			$(".dateclick").dateclick();    // DateClick
			$(".searchDate").schDate();        // searchDate
			
		});   

		// Search Date
		jQuery.fn.schDate = function(){
			var $obj = $(this);
			var $chk = $obj.find("input[type=radio]");
			$chk.click(function(){                
				$('input:not(:checked)').parent(".chkbox2").removeClass("on");
				$('input:checked').parent(".chkbox2").addClass("on");                    
			});
		};

		// DateClick
		jQuery.fn.dateclick = function(){
			var $obj = $(this);
			$obj.click(function(){
				$(this).parent().find("input").focus();
			});
		}

	}

	view_layer = function (num){
		var popUp = $("#pop" + num);
		popUp.show().find(".dim").show();
	}

});

