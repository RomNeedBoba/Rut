const express = require('express');
const router = express.Router();
const HistoryResult = require('../models/historyResult'); 

// ✅ POST /races/save
router.post('/save', async (req, res) => {
  const { raceName, results } = req.body;

  if (!raceName || !Array.isArray(results)) {
    return res.status(400).json({ error: 'raceName and results[] are required' });
  }

  try {
    const raceId = Date.now().toString(); // auto-generate a group ID

    const entries = results.map((r) => ({
      raceId,
      raceName,
      participantName: r.participantName,
      bibNumber: r.bibNumber,
      swimTime: r.swimTime,
      cycleTime: r.cycleTime,
      runTime: r.runTime,
      totalTime: r.totalTime,
    }));

    const saved = await HistoryResult.insertMany(entries);

    res.json({
      message: `✅ ${saved.length} results saved to history`,
      data: saved,
    });
  } catch (err) {
    console.error('❌ Save error:', err);
    res.status(500).json({ error: 'Failed to save race results' });
  }
});

router.delete('/history/:raceId', async (req, res) => {
  try {
    await HistoryResult.deleteMany({ raceId: req.params.raceId });
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete history' });
  }
});

router.get('/history', async (req, res) => {
  try {
    const grouped = await HistoryResult.aggregate([
      {
        $group: {
          _id: '$raceId',
          raceName: { $first: '$raceName' },
          createdAt: { $first: '$createdAt' },
          results: {
            $push: {
              participantName: '$participantName',
              bibNumber: '$bibNumber',
              swimTime: '$swimTime',
              cycleTime: '$cycleTime',
              runTime: '$runTime',
              totalTime: '$totalTime'
            }
          }
        }
      },
      { $sort: { createdAt: -1 } }
    ]);

    res.json(grouped);
  } catch (err) {
    console.error('❌ Error fetching history:', err.message);
    res.status(500).json({ error: 'Failed to fetch race history' });
  }
});

module.exports = router;
