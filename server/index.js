var app = require('express')();
var server = require('http').createServer(app);
var io = require('socket.io')(server);
var bodyParser = require('body-parser');
var secret = 'shhhhhh';
var jwt = require('jsonwebtoken');
var clients = {};
var sockets = {};
var musics = {};
var rooms = [];
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
function User()
{
    this.socketid = '';
    this.userid = '';
    return this;
}
User.prototype.setInfo = function(socketid, userid){
    this.socketid = socketid;
    this.userid = userid;
};

function Room()
{
    this.user1 = '';
    this.user2 = '';
    this.roomid = '';
    this.musicid = '';
    this.title = '';
    this.username = '';
    this.avataUrl = '';
    this.streamUrl = '';
    return this;
}
Room.prototype.setInfo = function(user1, user2, roomid, musicid, title, username, avataUrl, streamUrl){
    this.user1 = user1;
    this.user2 = user2;
    this.roomid = roomid;
    this.musicid = musicid;
    this.title = title;
    this.username = username;
    this.avataUrl = avataUrl;
    this.streamUrl = streamUrl;
};

Array.prototype.getIemtByParam = function(paramPair) {
    var key = Object.keys(paramPair)[0];
    return this.find(function(item){return ((item[key] == paramPair[key]) ? true: false)});
}

function MusicRoom(id,user1, user2) {
  this.id = id;
  this.user1 = user1;
  this.user2 = user2; 
}
function getObjectLength( obj )
{
    var length = 0;
    for ( var p in obj )
    {
        if ( obj.hasOwnProperty( p ) )
        {
            length++;
        }
    }
    return length;
}


server.listen(3000, function () {
              console.log('express server up and running');
              });


app.get('/', function (req, res) {
        res.sendFile(__dirname + '/index.html');
        });

app.post('/api/login', function (req, res) {
         console.log('create room: '+ req.body.accessToken);
         var user = {
         accessToken: req.body.accessToken
         };
         
         var token = jwt.sign(user, secret, {expiresIn: '1d'});
         console.log(token);
         res.json({token: token});
         });
app.post('/api/getHistory', function (req, res) {
         
         });


io.use(require('socketio-jwt').authorize({
                                         secret: secret,
                                         handshake: true
                                         }));

io.on('connection', function (socket) {
      io.sockets.emit('room',JSON.stringify(rooms));
      socket.on('disconnect', function(){
        console.log( socket.name + ' has disconnected from the chat.' + socket.id);
                delete clients[sockets[socket.id].userid];
                delete sockets[socket.id];
                console.log(getObjectLength(clients));
            });
      
      socket.on('join', function(userID){
                var user = new User();
                user.setInfo(socket.id, userID);
                clients[userID] = user;
                sockets[socket.id] = user;
                console.log(userID + ' join server!');
                console.log('num of clients: ' + getObjectLength(clients));
            });
      
      socket.on('chat', function(msg){
                console.log(msg);
                var t = JSON.parse(msg);
				if(t['userid'] != null){
						if(clients[t['userid']] == null){
						console.log(t['userid'] + ' have leave socket connect!');
					}
					else{
						io.sockets.connected[clients[t['userid']].socketid].emit('chat', msg);
						io.sockets.connected[socket.id].emit('chat', msg);
					}
				}
				else{
					console.log('cant find user');
				}
            });
      
      socket.on('createroom', function(data){
                  var t = JSON.parse(data);
                var room = new Room();
                room.setInfo(t['user1'], t['user2'], t['roomid'], t['musicid'], t['title'], t['username'], t['avataUrl'], t['streamUrl']);
                rooms.push(room);
                console.log(data);
                io.sockets.emit('room', JSON.stringify(rooms));
            });
      });