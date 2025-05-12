const mongoose = require('mongoose');

const ResultSchema = new mongoose.Schema({
  raceId: { type: mongoose.Schema.Types.ObjectId, ref: 'Race' },
  participantId: { type: mongoose.Schema.Types.ObjectId, ref: 'Participant' },
  swimTime: Number,
  cycleTime: Number,
  runTime: Number,
  totalTime: Number,
});

module.exports = mongoose.model('Result', ResultSchema);
