using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace ChatWithSpeech
{
    public class ChatHub : Hub
    {
        public void send(string name, string message)
        {
            Clients.All.sendMessage(name, message);
        }
    }
}