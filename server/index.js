var app = require('express')();
var server = require('http').createServer(app);
var io = require('socket.io')(server);
var bodyParser = require('body-parser');
var secret = 'shhhhhh';
var jwt = require('jsonwebtoken');
var clients = {};
var musics = {};
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
function User(ID,USERID) {
  this.id = ID;
  this.userid = USERID; 
}
function MusicRoom(id,user1, user2) {
  this.id = id;
  this.user1 = user1;
  this.user2 = user2; 
}


server.listen(3000, function () {
              console.log('express server up and running');
              });


app.get('/', function (req, res) {
        res.sendFile(__dirname + '/index.html');
        });

app.post('/api/login', function (req, res) {
         console.log('create room: '+ req);
         var user = {
         accessToken: req.body.accessToken
         };
         
         var token = jwt.sign(user, secret, {expiresIn: '1h'});
         
         res.json({token: token});
         });
app.post('/api/getHistory', function (req, res) {
         
         });


io.use(require('socketio-jwt').authorize({
                                         secret: secret,
                                         handshake: true
                                         }));

io.on('connection', function (socket) {
      console.log('socket id: ' + socket.id + ', socket name:' + socket.name);
      socket.on('disconnect', function(){
        console.log( socket.name + ' has disconnected from the chat.' + socket.id);
                delete clients[socket.id];
            });
      socket.on('join', function(userID){
                var user = new User(socket.id, userID);
                clients[socket.id] = user;
            });
      socket.on('chat', function(msg){
                console.log('socket' + socket.id);
                io.sockets.connected[socket.id].emit('chat', msg);
            });
      socket.on('createRoom', function(roomID){
                  console.log('socket:  ' + socket.id);
                  console.log(clients[socket.id].userid + ' create room: '+ roomID);
            });
      });
