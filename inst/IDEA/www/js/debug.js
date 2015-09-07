//$(document).ready(function(){
  //$(".icon--compare").click(function(){
  //  $("#combinebtn").click();
  //});
  
  function FreassActive(s_id) {
    if(s_id==5){
      $("#combinebtn").click();
    }else if(s_id="method_5"){
      $("#samactiveButton").click();
    }else if(s_id="method_3"){
      $("#noiactiveButton").click();
    }else if(s_id="method_4"){
      $("#poiactiveButton").click();
    }
  }
  
  //function fillcheck() {
   //if($("#file1_progress > label").val()!='Upload complete'){
   //  alert("Please Input readscount file first!");
  // }
//}
  
  
 // $("#btn--next1-nav-upload").click(function(){
 //   if($("#file1_progress label").val()!="Upload complete"){
   //  alert("Please Input readscount file first!");
  // }else{
  //    for (i = 0; i < 4; i++) {
   //   if (i == 2) {
        //      document.getElementById("step" + i).className = "block"; //内容的样式
    //    $("div[id=step" + i + "]").show();
   //  } else {
     //   $("div[id=step" + i + "]").hide();
   //     //      document.getElementById("step" + i).className = "none"; //内容不显示
  
    //  }
 //   }
//   }
 // });
  
  //data upload advanced toggle function
  $(document).ready(function(){

  $("#headingOne1").click(function(){
    $("#headingOne1 ~ #collapseOne1").toggle("slow");
 });


  });
 //dragable



//add space before check box
$(document).ready(function(){
  $(".checkbox > input").before("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
});
$(document).ready(function(){
  $(".absoluteSelf").hover(function(e){
  $(this).css("opacity",1);
},
function(e){
  $(this).css("opacity",0.5);
});
});

function reset(){
        var id = "#file1_progress";  
        var el=$("#file1");
         el.replaceWith(el = el.clone(true));
        var idBar = id + " .bar"; 
        var idLabel = id + " > label";
       
        $(id).css("visibility", "hidden");   
        $(idBar).css("width", "0%"); 
        $(idLabel).text("");
        
        //Shiny.onInputChange("file1", NULL);
    var id2 = "#designfile_progress";
    var el=$("#designfile");
         el.replaceWith(el = el.clone(true));
        var idBar2 = id2 + " .bar"; 
        var idLabel2 = id2 + " > label";
        $(id2).css("visibility", "hidden");
        
        $(idBar2).css("width", "0%"); 
        $(idLabel2).text("");
        //Shiny.onInputChange("file1", NULL);
        $(".shiny-bound-output > img").remove();
        $(".shiny-datatable-output > div").remove(); 
}




function allResetFunction(){
  $(".shiny-bound-output > img").remove();
  //$(".shiny-datatable-output > div").remove();
  //$("#interestvariablesUI").children().remove();
  //$("#ConditionSelectionUI").children().remove();
}


 Shiny.addCustomMessageHandler("resetFileInputHandler", function(x) {   
          var el = $("#" + x);
          el.replaceWith(el = el.clone(true));
          var id = "#" + x + "_progress";
          var idLabel = id + " > label";
          $(id).css("visibility", "hidden");
              
        $(idBar).css("width", "0%"); 
        $(idLabel).text("");
        });
 
    
    
function isUpload(filenameid){
  if(filenameid==1){
    if($("#file1_progress .progress-bar").text()!="Upload complete"){
    showDialogCountInput();
   }else{
    toStep(3); 
   }
    
  }else if(filenameid==2){
    if($("#designfile_progress .progress-bar").text()!="Upload complete"){
    showDialogDesignInput();
   }else{
    toStep(2);
   }
  }
}

//dialog
//fisrt data panel
function showDialogData(){
  $("#dialog-confirmData").html('<p>Without inputing data, this panel is inactive. Now you will be redirected into NEW section</p> ');
    $("#dialog-confirmData").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 250,
        width: 400,
        Dialog: true,
        buttons: {
            "OK": function () {
                $(this).dialog('close');
                aa(2);
                
            }
        }
    });
    
}

//input mattrix check panel
function showDialogCountInput(){
  $("#dialog-confirmMatrix").html('<p>Please load a <strong>count</strong> matrix</p> ');
    $("#dialog-confirmMatrix").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 200,
        width: 300,
        Dialog: true,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
            }
        }
    });
    
}
//input design check panel
function showDialogDesignInput(){
  $("#dialog-confirmDesign").html('<p>Please load a <strong>design</strong> matrix </p> ');
    $("#dialog-confirmDesign").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 200,
        width: 300,
        Dialog: true,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
            }
        }
    });
    
}

//Data analysis check panel
function showDialogStartanalysis(){
  $("#dialog-confirmStartanalysis").html('<p>Please upload readscount and design file first! Or you can click example button to run demo.</p> ');
    $("#dialog-confirmStartanalysis").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 200,
        width: 300,
        Dialog: true,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
            }
        }
    });
    
} 
function showDialogCombineAnalysis(){
  $("#dialog-confirmStartanalysis").html('<p>Now, You are going to Combination Analysis Section, it will take  minutes before other analysis were completed. </p> ');
    $("#dialog-confirmStartanalysis").dialog({
        resizable: false,
        modal: true,
        title: "Warning",
        height: 300,
        width: 400,
        Dialog: true,
        buttons: {
            "Later": function () {
                $(this).dialog('close');
            },"Continue": function () {
                $(this).dialog('close');
                aa(5);
            }
        }
    });
    
} 

//Data analysis check panel

//});