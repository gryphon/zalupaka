
$( document ).ready(function() {

  var t = null;

  var config = {
    encoderPath: "/encoderWorker.min.js"
  }

  var rec = new Recorder(config);

  var startRecord = function(){
    rec.start().catch(function(e){
      console.log('Error encountered:', e.message );
    });
  }

  $("#start").on("click", function(){ 
    startRecord();
  });

  $("#stop").on("click", function(){ 
    rec.stop();
    clearTimeout(t);
  });

  rec.onstart = function(){
    console.log("Rec started")

    t = setTimeout(function(){
      console.log("Audo record restart")
      rec.stop();
    }, 5000);

  }

  rec.ondataavailable = function( typedArray ){

    console.log("Data available!")

    var dataBlob = new Blob( [typedArray], { type: 'audio/wav' } );
    var fileName = new Date().toISOString() + ".wav";
    var url = URL.createObjectURL( dataBlob );
    var audio = document.createElement('audio');
    audio.controls = true;
    audio.src = url;
    var link = document.createElement('a');
    link.href = url;
    link.download = fileName;
    link.innerHTML = link.download;
    var li = document.createElement('li');
    li.appendChild(link);
    li.appendChild(audio);
    recordingslist.appendChild(li);

    var fd = new FormData();
    fd.append('fname', fileName);
    fd.append('data', dataBlob);

    $.ajax({
      method: "POST",
      url: "/voice/recognize",
      data: fd,
      processData: false,
      contentType: false,
      success: function( data ) {

        var recognized = document.createElement('b');
        recognized.innerHTML = data;
        li.appendChild(recognized)

        console.log(data);
        $('#response #source').attr('src', "/voice/generate?text="+data);
        $('#response').get(0).load();
        $('#response').get(0).play();

      }
    })

    setTimeout(function(){
      console.log("Will start auto record very soon")
      startRecord();
    }, 200);

  };

});