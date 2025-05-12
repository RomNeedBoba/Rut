const express = require('express');
const router = express.Router();
const Participant = require('../models/Participant');

router.get('/', async (req, res) => {
  const participants = await Participant.find();
  res.json(participants);
});

router.post('/', async (req, res) => {
  const { bibNumber, name } = req.body;
  const participant = new Participant({ bibNumber, name });
  await participant.save();
  res.json(participant);
});

router.delete('/:id', async (req, res) => {
  await Participant.findByIdAndDelete(req.params.id);
  res.json({ success: true });
});


module.exports = router;
