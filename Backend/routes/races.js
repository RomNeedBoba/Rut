const express = require('express');
const router = express.Router();
const Race = require('../models/Race');
const Result = require('../models/Result');

router.get('/', async (req, res) => {
  const races = await Race.find();
  res.json(races);
});

router.post('/', async (req, res) => {
  const { name, date } = req.body;
  const race = new Race({ name, date, status: 'Not Started' });
  await race.save();
  res.json(race);
});

router.get('/:id/results', async (req, res) => {
  const results = await Result.find({ raceId: req.params.id }).populate('participantId');
  res.json(results);
});

router.post('/:id/results', async (req, res) => {
  const { participantId, swimTime, cycleTime, runTime } = req.body;
  const totalTime = swimTime + cycleTime + runTime;
  const result = new Result({
    raceId: req.params.id,
    participantId,
    swimTime,
    cycleTime,
    runTime,
    totalTime,
  });
  await result.save();
  res.json(result);
});

module.exports = router;
