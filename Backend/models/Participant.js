const mongoose = require('mongoose');

const ParticipantSchema = new mongoose.Schema({
  bibNumber: String,
  name: String,
});

module.exports = mongoose.model('Participant', ParticipantSchema);
