function User(id,userid) {
  // always initialize all instance properties
  this.id = id;
  this.userid = userid; // default value
}
// class methods
User.prototype.fooBar = function() {

};
// export the class
module.exports = User;