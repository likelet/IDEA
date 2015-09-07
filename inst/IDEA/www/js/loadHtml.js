$(document).ready(function () {
  // loadhtml(".header-main","index.html",".header-main");
  // loadhtml("#side-nav","index.html","#side-nav");
  loadhtml("#frame","IDEA/../dom/frame.html","#frame");
  loadhtml("#s1","IDEA/../dom/s1.html","#s1");
  loadhtml("#step0","IDEA/../dom/s2-intro.html","#step0");
  loadhtml(".hd-data","IDEA/../dom/s3-header.html",".hd-data");
  loadhtml("#s4-nav","IDEA/../dom/s4-nav.html",".nav--method-analysis");
  loadhtml("#s4-de","IDEA/../dom/s4-de.html","#methodIntro1");
  loadhtml("#s4-edger","IDEA/../dom/s4-edger.html","#methodIntro2");
  loadhtml("#s4-noiseq","IDEA/../dom/s4-noiseq.html","#methodIntro3");
  loadhtml("#s4-poissonseq","IDEA/../dom/s4-poissonseq.html","#methodIntro4");
  loadhtml("#s4-samseq","IDEA/../dom/s4-samseq.html","#methodIntro5");
  loadhtml("#s4-combine","IDEA/../dom/s4-combine.html","#methodIntro6");
  loadhtml("#s6","IDEA/../dom/s6.html","#s6");
  loadhtml("#s7","IDEA/../dom/s7.html","#s7");
  loadhtml("#s8","IDEA/../dom/s8.html","#s8");
});

function loadhtml(to,page,from){
  $(to).load(''+page+' '+from+'', function (responseTxt, statusTxt, xhr) {
    if (statusTxt == "success")
         // alert("'+from+'加载成功！");
      if (statusTxt == "error")
      alert("Error: " + xhr.status + ": " + xhr.statusText);
  });
}
