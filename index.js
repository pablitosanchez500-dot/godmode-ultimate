// index.js
const express = require("express");
const fetch = require("node-fetch");
const app = express();
const PORT = process.env.PORT || 3000;

// Tu API Key como variable de entorno
const ODDS_API_KEY = process.env.ODDS_API_KEY;

// Servir archivos estáticos (HTML, CSS, JS)
app.use(express.static("public"));

// Endpoint para traer cuotas desde OddsPapi
app.get("/api/odds", async (req, res) => {
  try {
    // Aquí es donde pones tu fetch
    const response = await fetch(`https://api.oddspapi.io/v4/odds?apiKey=${ODDS_API_KEY}`);
    const data = await response.json();
    res.json(data); // Devuelve el JSON al frontend
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Error al obtener cuotas", message: e.message });
  }
});

// Iniciar servidor
app.listen(PORT, () => console.log(`Servidor iniciado en puerto ${PORT}`));
