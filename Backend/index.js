require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();

// 🔐 Middleware
app.use(cors());
app.use(express.json());

// 🌐 MongoDB Connection
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('✅ MongoDB connected'))
  .catch(err => {
    console.error('❌ MongoDB connection error:', err);
    process.exit(1); // Optional: exit on fail
  });

// 🪵 Logger Middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
  next();
});

// 🛣️ Routes
const participantRoutes = require('./routes/participants');
const historyRoutes = require('./routes/history');

app.use('/participants', participantRoutes);   // e.g. /participants POST/GET/DELETE
app.use('/races', historyRoutes);              // e.g. /races/save or /races/:id/push-history

// 🩺 Health Check
app.get('/ping', (req, res) => {
  console.log('✅ Flutter app pinged the backend at', new Date().toISOString());
  res.json({ message: 'Backend is alive!' });
});

// 🚀 Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);
