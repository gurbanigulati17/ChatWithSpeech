<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ChatWithSpeech.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Chat Box</title>
    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.2.2.min.js"></script>
    <script src="signalr/hubs"></script>
 
    <style>
        body{
          background-image:url("https://i.pinimg.com/originals/e8/d9/4e/e8d94e1e8b6b530ad315e9385290141b.jpg");
          background-position:center;
          background-size:cover;
          }
    </style>
    </head>
<body>
    <h2 style="color:white; font-size:medium;">Enter Name:</h2> <input type="text" id="txtName" />
    <input id="btnSetName" type="button" value="Set Name" />
    <br />
    <br />


   <h2 style="color:white; font-size:medium;">Enter Message:</h2>  <input id="txtMessage" type="text" style="width:400px;" />
    <input type="button" id="btnGiveCommand" value="Get Voice Command" />
   <br />
    <br />
    <input type="button" id="btnSend" value="Send Message" />




    <div id="divName" style="display:block; margin:5px auto; font-size:20px; width:200px; text-align:center; color:bisque"></div>
  <div id="divMessages" style="display:block; width:500px; margin:0 auto; border:5px solid darkseagreen; color:white; height:1000px;"></div>
    <br />
    <br />
    <script>
        $(function () {

            let txtName = document.querySelector('#txtName');
            let txtMessage = document.querySelector('#txtMessage');
            let btnSetName = document.querySelector('#btnSetName');
            let btnSend = document.querySelector('#btnSend');
            let divMessages = document.querySelector('#divMessages');

            let chat = $.connection.chatHub;
            btnSetName.onclick = function () {
                divName.innerText = `Name: ${txtName.value}`;
            }
            chat.client.sendMessage = function (name, message) {
                $(divMessages).append($(`<div style="border: 1px solid greenyellow; color:white; padding: 5px; margin: 5px;"><b>${name}: </b> ${message}</div>`))
                 

            }
            $.connection.hub.start().done(function () {
                btnSend.onclick = function () {
                    chat.server.send(`${txtName.value}`, `${txtMessage.value}`);

                };

            });



        /*Speech Recognition code*/

            var SpeechRecognition = SpeechRecognition || webkitSpeechRecognition;
            var SpeechGrammarList = SpeechGrammarList || webkitSpeechGrammarList;

            var grammar = `#JSGF V1.0;`
            var recognition = new SpeechRecognition();
            var speechRecognitionList = new SpeechGrammarList();
            speechRecognitionList.addFromString(grammar, 1);
            recognition.grammars = speechRecognitionList;
            recognition.lang = `en-US`;
            recognition.interimResults = true;

            recognition.onresult = function (event) {
                let command = event.results[0][0].transcript;
                let isFinal = event.results[0].isFinal;
                txtMessage.value = command;
                if (isFinal) {

                    chat.server.send(txtName.value, command);
                   
                } 

            }

            document.querySelector(`#btnGiveCommand`).onclick = function () {
                recognition.start();
            };
            recognition.onspeechend = function () {
                recognition.stop();
            };
            recognition.onerror = function (event) {
                txtMessage.value = `Error occured in recognition:` + event.error;
            }
        });

    </script>


</body>
</html>
