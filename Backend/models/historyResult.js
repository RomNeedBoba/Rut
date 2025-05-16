const mongoose = require('mongoose');

const historyResultSchema = new mongoose.Schema({
  raceId: { type: String, required: true },
  raceName: { type: String, required: true },

  participantId: { type: mongoose.Schema.Types.ObjectId, ref: 'Participant', required: false }, // ✅ optional
  participantName: { type: String, required: true },
  bibNumber: { type: String },

  swimTime: { type: Number, default: 0 },
  cycleTime: { type: Number, default: 0 },
  runTime: { type: Number, default: 0 },
  totalTime: { type: Number, default: 0 },

  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('HistoryResult', historyResultSchema);
