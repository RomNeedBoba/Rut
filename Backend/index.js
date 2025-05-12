require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB error:', err));

// Routes
const participantRoutes = require('./routes/participants');
const raceRoutes = require('./routes/races');

app.use('/participants', participantRoutes);
app.use('/races', raceRoutes);

app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
  next();
});

app.get('/ping', (req, res) => {
  console.log('✅ Flutter app pinged the backend at', new Date().toISOString());
  res.json({ message: 'Backend is alive!' });
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));

