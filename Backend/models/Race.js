const mongoose = require('mongoose');

const RaceSchema = new mongoose.Schema({
  name: String,
  date: Date,
  status: { type: String, default: 'Not Started' },
});

module.exports = mongoose.model('Race', RaceSchema);
