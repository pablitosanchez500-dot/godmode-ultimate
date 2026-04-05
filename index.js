const express = require("express");
const fetch = require("node-fetch");
const app = express();
const PORT = process.env.PORT || 3000;

const ODDS_API_KEY = process.env.ODDS_API_KEY;

app.use(express.static("public"));

app.get("/api/odds", async (req, res) => {
  try {
    const response = await fetch(`https://api.oddspapi.io/v4/odds?sportId=10&apiKey=${ODDS_API_KEY}`);
    const data = await response.json();
    res.json(data);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Error al obtener cuotas" });
  }
});

app.listen(PORT, () => console.log(`Servidor iniciado en puerto ${PORT}`));
