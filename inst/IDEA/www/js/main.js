// switch between modules
function aa(s_id) {
  if( s_id == alert ) {
    showDialogData();
  }
  for (i = 1; i < 9; i++) {
    if (i == s_id) {
      // document.getElementById("s" + i).className = "block"; //内容的样式
      $("div[id=s" + i + "]").show();
      $("#link-mian-nav"+i+"").addClass('actived');
      $("#refreshbutton").click();
      $("#refreshbutton").hide();
      if (s_id == 4) {
        toMethod(0);
        $("div[id=s5]").hide(); 
        $("div[id=s6]").hide(); 
        $("div[id=s7]").hide(); 
        $("div[id=s8]").hide(); 
        $("#link-mian-nav5").removeClass('actived');
        $("#link-mian-nav6").removeClass('actived');
        $("#link-mian-nav7").removeClass('actived');
        $("#link-mian-nav8").removeClass('actived');
      };
      if(s_id ==6 && ($("#s6>div").length==0)) {
        loadhtml("#s6","IDEA/../dom/s6.html","#s6");
      };
      if(s_id ==7 && ($("#s7>div").length==0)) {
        loadhtml("#s7","IDEA/../dom/s7.html","#s7");
      };
      if(s_id ==8 && ($("#s8>div").length==0)) {
        loadhtml("#s8","IDEA/../dom/s8.html","#s8");
        // loadhtml("#s8","IDEA/../dom/modal.html","#model-new");
      };

    } else {
      $("div[id=s" + i + "]").hide(); //内容不显示
      $("#link-mian-nav"+i+"").removeClass('actived');
      // document.getElementById("s" + i).className = "none"; //内容不显示
    }
  }
}

// switch between steps in s1
function toStep(step_id) {
  // if($("#file1_progress label").text()!="Upload complete"&&(step_id>1)&&(workmode==1)){
  //   // alert(workmode)
  //   alert("Please Input readscount file first! Or you can click example button to run demo.");
  //  }
  // else{
    for (i = 0; i < 4; i++) {
      if (i == step_id) {
             document.getElementById("step" + i).className = "block"; //内容的样式
        //$("div[id=step" + i + "]").show();
        $("#refreshbutton").click();
      } else {
        //$("div[id=step" + i + "]").hide();
             document.getElementById("step" + i).className = "none"; //内容不显示
      // }
    }
  }
}

//switch between analysis methods
function toMethod(method_id) {
  // method_name="method"+i;
  for (i = 0; i < 7; i++) {
    if (i == method_id) {
      $("#refreshbutton").click();
      $("#refreshbutton2").click();
      // document.getElementById("method"+i).className = 'block';
      $("div[id=method" + i + "]").show();
    } else {
      // document.getElementById("method"+i).hide();
      $("div[id=method" + i + "]").hide();
      // alert("method"+i);
    }
  }
}

//switch between introduction of analysis methods
function toMethodIntro(methodIntro_id) {
  for (i = 1; i < 7; i++) {
    if (i == methodIntro_id) {
      $("div[id=methodIntro" + i + "]").show();
      $("#methodlink" + i + "").addClass('active');

      //      document.getElementById("methodIntro" + i).className = "block"
    } else {
      $("div[id=methodIntro" + i + "]").hide();
      $("#methodlink" + i + "").removeClass('active');
      //      document.getElementById("methodIntro" + i).className = "none"
    }
  }
}

//scroll to Nth figure in data module
function toDataFig(datafig_id) {
  for (i = 1; i < 8; i++) {
    if (i == datafig_id) {
      $("div[id=datafig" + i + "]").show();
      $("div.fig-data").find("img").css({
        "width": "80%",
        "height": "80%"
      });
      //      document.getElementById("datafig" + i).className = "block"
    } else {
      $("div[id=datafig" + i + "]").hide();
      //      document.getElementById("datafig" + i).className = "none"
    }
  }
}


function navshow1() {
  $("#pulldown1").show();
}

function navhide1() {
  $("#pulldown1").hide();
}

function navshow2() {
  $("#pulldown2").show();
}

function navhide2() {
  $("#pulldown2").hide();
}


$(document).ready(function () {
  // $("div.fig-data").find("img").css({
  //   "width": "500px"
  // });
  //  alert('hello')
  //  $('#example6').attr("data-rel", "lightcase");
  //  $('#example6').attr("href", "img/pic.gif");
  $('#example5').attr("data-rel", "lightcase");
  $('#example5').attr("href", "img/pic.gif");
  // $(".fig-data").find("img").attr("data-rel","lightcase");
  // $(".fig-data").find("img").attr("href","img/pic.gif");
  // $(".fig-data").find("img").css({
  //   "width":"500px"
  // });
  // $('#example6').lightcase();
  //  $('a[data-rel^=lightcase]').lightcase();
  $(".icon--fullView").hover(function () {
    $(this).lightcase();

    //  alert($(".figure-analysis").find("img").attr("src"));
    //    alert('hello')
    //    $(this).parents(".figure-analysis").find("a").attr("data-rel", "lightcase");
    $(this).parents(".figure-analysis").find("a").attr("href", $(this).parents(".figure-analysis").find(".shiny-plot-output").find("img").attr("src"));
    //    alert($(this).parents(".figure-analysis").find("a").attr("class"));
    //  $(".figure-analysis").find("a").attr("data-rel", "lightcase");
    //  $(".figure-analysis").find("a").attr("href", $(".figure-analysis").find("img").attr("src"));

    //  $(this).parents(".figure-analysis").find("a").attr("data-rel", "lightcase");
    //  $(this).parents("figure-analysis") find("a").attr("href", $(this).parents("figure-analysis").find("img").attr("src"));
    //    $('a[data-rel^=lightcase]').lightcase();
  });
  //  $(".icon--fullView").click(function () {
  //    $('a[data-rel^=lightcase]').lightcase();
  //  });
});

var status=0;
$(document).ready(function () {
  $('a[data-rel^=lightcase]').lightcase();
})

var workmode=0
$(document).ready(function () {
  $(".button-new").click(function() {
    workmode=1;
    toStep(1);
  });

  $(".button-example").click(function() {
    workmode=0;
    toStep(1);
    // alert(workmode)
  });
})

//startAnalysis()
function startAnalysis() {
  
  if((workmode==1)&&(($("#file1_progress .progress-bar").text()!="Upload complete")||($("#designfile_progress .progress-bar").text()!="Upload complete"))){
    // alert(workmode)
    //alert("Please Input readscount or design file first! Or you can click example button to run demo.");
    showDialogStartanalysis();
   }
   else{
  status=1;
  aa(4);
  // $(".label-nav").css({
  //   "cursor": "pointer"
  // })
  
  $(".icon--data").removeClass('inactivebt');
  $(".icon--data").addClass('pointer');
  $(".icon--analysis").removeClass('inactivebt');
  $(".icon--analysis").addClass('pointer');
  $(".icon--compare").removeClass('inactivebt');

  $(".data").attr("onmousedown", "aa(3)");
  $(".analysis").attr("onmousedown", "aa(4)");
  $(".compare").attr("onmousedown", "aa(5);FreassActive(5)");
  $(".progress-success").find(".bar[style$='width: 100%;']").parent().parent().removeClass('none');
  }
}

//inactive analysis method after choose experiment type
function inactive(classname) {
  $('.' + classname + '').addClass('inactivebt');
  $('.' + classname + '').parent().removeClass('btn-default');
  // $('.' + classname + '').attr("disabled","disabled");
  $('.' + classname + '').parent().addClass('unclickable');
}

//
function reactive(classname) {
  // var originname = classname.substring(0, s.Length - 9);
  // alert(originname);
  // $('.' + classname + '').addClass(originname);
  $('.' + classname + '').removeClass('inactivebt');
  $('.' + classname + '').parent().addClass('btn-default');
  // $('.' + classname + '').attr("disabled","disabled");
  $('.' + classname + '').parent().removeClass('unclickable');
  // $('.' + classname + '').parent().parent().attr("onmousedown", "");
}

//
$(document).ready(function () {
  $("#mfExampleButton").click(function () {
    $("#methodlink3").attr("onmousedown", "");
    $("#methodlink4").attr("onmousedown", "");
    $("#methodlink5").attr("onmousedown", "");
    inactive("bg-noiseq");
    inactive("bg-poissonseq");
    inactive("bg-samseq");

    // $(".bg-samseq").addClass("bg-samseq-inactive");
    // $(".bg-samseq").removeClass("bg-samseq");
    // $(".bg-noiseq").;
    // $(".bg-poissonseq").;
  })
  $("#mfNewButton").click(function () {
    $("#methodlink3").attr("onmousedown", "");
    $("#methodlink4").attr("onmousedown", "");
    $("#methodlink5").attr("onmousedown", "");
    inactive("bg-noiseq");
    inactive("bg-poissonseq");
    inactive("bg-samseq");
    // $.cookie("example", "foo",{path:"/admin"}); 
    // alert($.cookie("example")); 

    // location.reload();
  })
  $("#wrExampleButton").click(function () {
    $("#methodlink3").attr("onmousedown", "toMethodIntro(3)");
    $("#methodlink4").attr("onmousedown", "");
    $("#methodlink5").attr("onmousedown", "");
    inactive("bg-poissonseq");
    inactive("bg-samseq");
    reactive("bg-noiseq");
  })
  $("#wrNewButton").click(function () {
    $("#methodlink3").attr("onmousedown", "toMethodIntro(3)");
    $("#methodlink4").attr("onmousedown", "");
    $("#methodlink5").attr("onmousedown", "");
    inactive("bg-poissonseq");
    inactive("bg-samseq");
    reactive("bg-noiseq");
  })
  $("#scExampleButton").click(function () {
    $("#methodlink3").attr("onmousedown", "toMethodIntro(3)");
    $("#methodlink4").attr("onmousedown", "toMethodIntro(4)");
    $("#methodlink5").attr("onmousedown", "toMethodIntro(5)");
    reactive("bg-samseq")
    reactive("bg-noiseq");
    reactive("bg-poissonseq");
  })
  $("#scNewButton").click(function () {
    $("#methodlink3").attr("onmousedown", "toMethodIntro(3)");
    $("#methodlink4").attr("onmousedown", "toMethodIntro(4)");
    $("#methodlink5").attr("onmousedown", "toMethodIntro(5)");
    reactive("bg-samseq")
    reactive("bg-noiseq");
    reactive("bg-poissonseq");
  })
  $("#scNewButton").hide();
  $("#mfNewButton").hide();
  $("#wrNewButton").hide();
  $("#scNewButton-fake").click(function(){
    if(status==1){
    $("#dialog-confirmSave").html('<p>Current analysis results will be discarded, do you want to save them before starting a new analysis task?</p>');
    $("#dialog-confirmSave").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 300,
        width: 300,
        Dialog: true,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
                 aa(4);
            },"No, thanks": function () {
                $(this).dialog('close');
                status=0;
        $(".icon--data").addClass('inactivebt');
        $(".icon--analysis").addClass('inactivebt');
        $(".data").attr("onmousedown", "");
        $(".analysis").attr("onmousedown", "");
        reset();
        $("#scNewButton").click();
            }
        }
    });
    }
    else{
      $("#scNewButton").click();
    }
  })
  $("#mfNewButton-fake").click(function(){
    
    
    if(status==1){
      
       $("#dialog-confirmSave").html('<p>Current analysis results will be discarded, do you want to save them before starting a new analysis task?</p>');
    $("#dialog-confirmSave").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 300,
        width: 300,
        Dialog: true,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
                 aa(4);
            },"No, thanks": function () {
                $(this).dialog('close');
                status=0;
        $(".icon--data").addClass('inactivebt');
        $(".icon--analysis").addClass('inactivebt');
        $(".data").attr("onmousedown", "");
        $(".analysis").attr("onmousedown", "");
         reset();
        $("#mfNewButton").click();
            }
        }
    });
      
      
      
      
      /*var r=confirm('Do you want to save your analysis result first? Press \"Yes\" to save result first, press \"NO\" to start a new analysis');
      if(r==false){
        status=0;
        $(".icon--data").addClass('inactivebt');
        $(".icon--analysis").addClass('inactivebt');
        $(".data").attr("onmousedown", "");
        $(".analysis").attr("onmousedown", "");
        // reset();
        $("#mfNewButton").click();
      }
      else{
        aa(4);
      }*/
    }
    else{
      $("#mfNewButton").click();
    }
  })
  $("#wrNewButton-fake").click(function(){
    if(status==1){
      $("#dialog-confirmSave").html('<p>Current analysis results will be discarded, do you want to save them before starting a new analysis task?</p> ');
    $("#dialog-confirmSave").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 300,
        width: 300,
        Dialog: true,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
                 aa(4);
            },"No, thanks": function () {
                $(this).dialog('close');
                status=0;
        $(".icon--data").addClass('inactivebt');
        $(".icon--analysis").addClass('inactivebt');
        $(".data").attr("onmousedown", "");
        $(".analysis").attr("onmousedown", "");
        reset();
        $("#wrNewButton").click();
            }
        }
    });
    }
    else{
      $("#wrNewButton").click();
    }
  })

})


// function expand()
// {
//   if($("#file1_progress label").text()=="Upload complete"){
//     // alert("hello")
//     $(".panel-data").show();
//     $(".panel-format").show();
//   };
//   if($("#designfile_progress label").text()=="Upload complete"){
//     $(".panel-design").show()
//   }
// } 

// $(document).ready(function(){
//   window.setInterval(expand, 3000);
// })

$(document).ready(function () {
  //$(".absoluteSelf").toggle();
  $(".bt-config").click(function(){
    $(this).parents(".figure-analysis").find(".absoluteSelf").slideToggle(1000);
  });
  // $(".option-analysis .shiny-download-link").addClass("btn btn-block btn-primary")
})


function hideProgress() {
  $(".progress-success").find(".bar[style$='width: 100%;']").parent().parent().addClass('none')
}
$(document).ready(function(){
  window.setInterval(hideProgress, 3000);
})

function wsug(e, str){ 
    var oThis = arguments.callee;
    if(!str) {
        oThis.sug.style.visibility = 'hidden';
        document.onmousemove = null;
        return;
    }  
    if(!oThis.sug){
        var div = document.createElement('div'), css = 'top:0; left:0; position:absolute; z-index:100; visibility:hidden';
        div.style.cssText = css;
        div.setAttribute('style',css);
        var sug = document.createElement('div'), css= 'font:normal 12px/16px "宋体";font-family:Arial; white-space:nowrap; color:#1F4769; padding:3px; position:absolute; left:0; top:0; z-index:10; background:#f9fdfd; border:1px solid #1F4769';
        sug.style.cssText = css;
        sug.setAttribute('style',css);
        var dr = document.createElement('div'), css = 'position:absolute; top:3px; left:3px; background:#333; filter:alpha(opacity=50); opacity:0.5; z-index:9';
        dr.style.cssText = css;
        dr.setAttribute('style',css);
        var ifr = document.createElement('iframe'), css='position:absolute; left:0; top:0; z-index:8; filter:alpha(opacity=0); opacity:0';
        ifr.style.cssText = css;
        ifr.setAttribute('style',css);
        div.appendChild(ifr);
        div.appendChild(dr);
        div.appendChild(sug);
        div.sug = sug;
        document.body.appendChild(div);
        oThis.sug = div;
        oThis.dr = dr;
        oThis.ifr = ifr;
        div = dr = ifr = sug = null;
    }
    var e = e || window.event, obj = oThis.sug, dr = oThis.dr, ifr = oThis.ifr;
    obj.sug.innerHTML = str;

    var w = obj.sug.offsetWidth, h = obj.sug.offsetHeight, dw = document.documentElement.clientWidth||document.body.clientWidth; dh = document.documentElement.clientHeight || document.body.clientHeight;
    var st = document.documentElement.scrollTop || document.body.scrollTop, sl = document.documentElement.scrollLeft || document.body.scrollLeft;
    var left = e.clientX +sl +17 + w < dw + sl  &&  e.clientX + sl + 15 || e.clientX +sl-8 - w, top = e.clientY + st + 17;
    obj.style.left = left+ 10 + 'px';
    obj.style.top = top + 10 + 'px';
    dr.style.width = w + 'px';
    dr.style.height = h + 'px';
    ifr.style.width = w + 3 + 'px';
    ifr.style.height = h + 3 + 'px';
    obj.style.visibility = 'visible';
    document.onmousemove = function(e){
        var e = e || window.event, st = document.documentElement.scrollTop || document.body.scrollTop, sl = document.documentElement.scrollLeft || document.body.scrollLeft;
        var left = e.clientX +sl +17 + w < dw + sl  &&  e.clientX + sl + 15 || e.clientX +sl-8 - w, top = e.clientY + st +17 + h < dh + st  &&  e.clientY + st + 17 || e.clientY + st - 5 - h;
        obj.style.left = left + 'px';
        obj.style.top = top + 'px';
    }
}

// $(document).ready(function () {
//   //$(".absoluteSelf").toggle();
//   $(".figure-analysis img").css(
//   {
//     "width":"60%"
//   })
// })
